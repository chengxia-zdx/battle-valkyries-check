::$bvvar{namespace}.applySkinToActor <- function( _actor, _setDirty = true )
{
	::$bvvar{namespace}.traceSkinActor("applySkinToActor.enter", _actor, "setDirty=" + ::$bvvar{namespace}.skinDebugValue(_setDirty));

	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor) || !_actor.isPlayerControlled())
	{
		return;
	}

	::$bvvar{namespace}.syncActorValkyrieIdentity(_actor);
	local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);

	if (skinID == null || skinID == "")
	{
		::$bvvar{namespace}.traceSkinActor("applySkinToActor.noSkinID", _actor);
		return;
	}

	local skin = ::$bvvar{namespace}.getSkin(skinID);

	if (skin == null)
	{
		::$bvvar{namespace}.traceSkinActor("applySkinToActor.unknownSkin", _actor, "skinID=" + skinID);
		return;
	}

	if (::$bvvar{namespace}.getSettingValue("HideWeapons"))
	{
		if (_actor.hasSprite("arms_icon"))
		{
			_actor.getSprite("arms_icon").Visible = false;
			_actor.getSprite("arms_icon").setBrush("");
		}

		if (_actor.hasSprite("shield_icon"))
		{
			_actor.getSprite("shield_icon").Visible = false;
			_actor.getSprite("shield_icon").setBrush("");
		}
	}

	foreach( spriteName in [
		"head",
		"body",
		"hair",
		"beard",
		"beard_top",
		"helmet",
		"helmet_damage",
		"armor",
		"armor_upgrade_back",
		"armor_upgrade_front",
		"quiver",
		"surcoat",
		"injury",
		"injury_body",
		"tattoo_body",
		"tattoo_head",
		"permanent_injury_1",
		"permanent_injury_2",
		"permanent_injury_3",
		"permanent_injury_4"
	])
	{
		if (_actor.hasSprite(spriteName))
		{
			local sprite = _actor.getSprite(spriteName);
			sprite.Visible = false;
			// Injury refreshes can set Visible=true again after appearance hooks.
			// Alpha=0 keeps the retained core brush readable but never rendered.
			sprite.Alpha = 0;
		}
	}

	::$bvvar{namespace}.hideWholeBustCompatibilitySprites(_actor);

	if (_actor.hasSprite("accessory"))
	{
		local accessory = _actor.getSprite("accessory");
		accessory.setBrush(skin.Brush);
		accessory.Visible = true;
	}

	if (_setDirty)
	{
		_actor.setDirty(true);
	}

	::$bvvar{namespace}.traceSkinActor("applySkinToActor.done", _actor, "brush=" + skin.Brush);
};

// Whole-bust skins replace the actor silhouette completely. Legends and other
// appearance mods can add these overlays after the vanilla appearance fields
// have been resolved, so suppress them separately from the core body layers.
// Every caller goes through hasSprite() to remain safe on a vanilla actor.
::$bvvar{namespace}.WholeBustCompatibilitySpriteNames <- [
	"accessory_special",
	"body",
	"head",
	"hair",
	"beard",
	"beard_top",
	"tattoo_body",
	"tattoo_head",
	"eye_rings",
	"scar_head",
	"scar_body",
	"injury",
	"injury_body",
	"permanent_injury_1",
	"permanent_injury_2",
	"permanent_injury_3",
	"permanent_injury_4",
	"bandage_1",
	"bandage_2",
	"bandage_3",
	"shaft",
	"body_blood",
	"dirt",
	"permanent_injury_scarred",
	"permanent_injury_burned",
	"surcoat",
	"quiver",
	"armor",
	"armor_layer_chain",
	"armor_layer_plate",
	"armor_layer_tabbard",
	"armor_layer_cloak_front",
	"armor_layer_cloak",
	"armor_upgrade_back",
	"armor_upgrade_back_top",
	"armor_upgrade_front",
	"helmet_vanity_lower",
	"helmet_vanity_lower_2",
	"helmet",
	"helmet_helm_lower",
	"helmet_top_lower",
	"helmet_damage",
	"helmet_helm",
	"helmet_top",
	"helmet_vanity",
	"helmet_vanity_2"
];

// These optional overlays are safe to clear after hiding. Core actor layers
// such as body/head/injury must keep a valid brush even while invisible:
// player.onUpdateInjuryLayer reads their brush metadata during equipment
// deserialization, and an empty brush aborts the save stream.
::$bvvar{namespace}.WholeBustSafeBrushClearSpriteNames <- {
	accessory_special = true,
	eye_rings = true,
	scar_head = true,
	scar_body = true,
	bandage_1 = true,
	bandage_2 = true,
	bandage_3 = true,
	shaft = true,
	body_blood = true,
	dirt = true,
	permanent_injury_scarred = true,
	permanent_injury_burned = true
};

// This list is deliberately broader than the layers we suppress. It is used
// only by the short-lived Cartethyia manifestation audit to identify which
// vanilla or Legends sprite is still drawn above a whole-bust skin.
::$bvvar{namespace}.WholeBustSpriteAuditNames <- [
	"socket",
	"arms_icon",
	"shield_icon",
	"body",
	"head",
	"hair",
	"beard",
	"beard_top",
	"tattoo_body",
	"tattoo_head",
	"scar_body",
	"scar_head",
	"eye_rings",
	"injury",
	"injury_body",
	"permanent_injury_1",
	"permanent_injury_2",
	"permanent_injury_3",
	"permanent_injury_4",
	"permanent_injury_scarred",
	"permanent_injury_burned",
	"surcoat",
	"bandage_1",
	"bandage_2",
	"bandage_3",
	"shaft",
	"body_blood",
	"dirt",
	"quiver",
	"armor",
	"armor_upgrade_back",
	"armor_upgrade_front",
	"helmet",
	"helmet_damage",
	"accessory",
	"accessory_special"
];

::$bvvar{namespace}.getWholeBustSpriteAudit <- function( _actor )
{
	if (_actor == null)
	{
		return "actor=null";
	}

	local report = "";

	foreach (spriteName in ::$bvvar{namespace}.WholeBustSpriteAuditNames)
	{
		local entry = spriteName + "=missing";

		try
		{
			if (_actor.hasSprite(spriteName))
			{
				local sprite = _actor.getSprite(spriteName);
				local visible = "?";
				local alpha = "?";
				local brush = "";

				try { visible = sprite.Visible ? "true" : "false"; } catch (e) {}
				try { alpha = "" + sprite.Alpha; } catch (e) {}
				try
				{
					brush = sprite.HasBrush ? sprite.getBrush().Name : "";
				}
				catch (e)
				{
					brush = "<unavailable>";
				}

				entry = spriteName + "={visible:" + visible + ",alpha:" + alpha + ",brush:" + brush + "}";
			}
		}
		catch (e)
		{
			entry = spriteName + "=<audit-error>";
		}

		if (report != "") report += " | ";
		report += entry;
	}

	return report;
};

::$bvvar{namespace}.logWholeBustSpriteAudit <- function( _actor, _label )
{
	try
	{
		::logInfo("[Battle Valkyries] [WholeBustSpriteAudit] label=" + _label + " " + ::$bvvar{namespace}.getWholeBustSpriteAudit(_actor));
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.hideWholeBustCompatibilitySprites <- function( _actor, _preserveBody = false )
{
	if (_actor == null)
	{
		return;
	}

	foreach (spriteName in ::$bvvar{namespace}.WholeBustCompatibilitySpriteNames)
	{
		// The original death routine reuses the body layer for the corpse.  A
		// whole-bust skin must therefore keep that layer intact while preparing
		// a custom DeathBrush, otherwise the game can only leave its blood decal.
		if (_preserveBody && spriteName == "body")
		{
			continue;
		}

		if (_actor.hasSprite(spriteName))
		{
			local sprite = _actor.getSprite(spriteName);
			// Clearing optional overlay brushes keeps a later Visible=true assignment
			// from drawing stale art. Never clear core appearance brushes here.
			if (spriteName in ::$bvvar{namespace}.WholeBustSafeBrushClearSpriteNames)
			{
				try
				{
					sprite.setBrush("");
				}
				catch (e)
				{
				}
			}
			sprite.Visible = false;
			sprite.Alpha = 0;
		}
	}
};

::$bvvar{namespace}.applyValkyrieDeathBrush <- function( _actor, _label = "" )
{
	if (_actor == null || !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return false;
	}

	try
	{
		local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);
		local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
		local deathBrush = skin != null && "DeathBrush" in skin ? skin.DeathBrush : null;

		if (deathBrush == null || deathBrush == "" || !_actor.hasSprite("body"))
		{
			return false;
		}

		// Compatibility fallbacks that keep a dead actor placed need one visible
		// body layer. Normal deaths use the original corpse-detail pipeline instead.
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(_actor, true);
		local body = _actor.getSprite("body");
		body.setBrush(deathBrush);
		body.Visible = true;
		body.Alpha = 1.0;
		_actor.setDirty(true);
		::$bvvar{namespace}.log("[DeathFix] Applied custom skin death brush " + deathBrush + " for " + ::$bvvar{namespace}.getActorNameForSkinDebug(_actor) + (_label == "" ? "" : " label=" + _label));
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to apply valkyrie death brush: " + e);
	}

	return false;
};

::$bvvar{namespace}.spawnValkyrieDeathBrushDecal <- function( _deathBrush, _tile, _flip = false, _actorName = "unknown", _label = "" )
{
	if (_deathBrush == null || _deathBrush == "" || _tile == null)
	{
		return false;
	}

	try
	{
		local decal = _tile.spawnDetail(_deathBrush, ::Const.Tactical.DetailFlag.Corpse, _flip, false, ::Const.Combat.HumanCorpseOffset);

		if (decal == null)
		{
			::$bvvar{namespace}.log("[DeathFix] spawnDetail returned null for " + _deathBrush + " actor=" + _actorName + (_label == "" ? "" : " label=" + _label));
			return false;
		}

		// Keep the final corpse independent from any actor-sprite alpha or tint that
		// another death wrapper may have changed while removing the live whole bust.
		try
		{
			decal.Alpha = 255;
			decal.Saturation = 1.0;
		}
		catch (e)
		{
		}

		decal.Scale = 0.9;
		decal.setBrightness(1.0);
		::$bvvar{namespace}.log("[DeathFix] Spawned final skin death decal " + _deathBrush + " for " + _actorName + (_label == "" ? "" : " label=" + _label));
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to spawn final valkyrie death decal " + _deathBrush + " actor=" + _actorName + ": " + e);
	}

	return false;
};

::$bvvar{namespace}.spawnValkyrieDeathDecal <- function( _actor, _tile, _label = "" )
{
	if (_actor == null || _tile == null || !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return false;
	}

	try
	{
		local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);
		local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
		local deathBrush = skin != null && "DeathBrush" in skin ? skin.DeathBrush : null;

		if (deathBrush == null || deathBrush == "")
		{
			return false;
		}

		local flip = false;

		try
		{
			flip = "m" in _actor && "IsCorpseFlipped" in _actor.m && _actor.m.IsCorpseFlipped;
		}
		catch (e)
		{
		}

		return ::$bvvar{namespace}.spawnValkyrieDeathBrushDecal(deathBrush, _tile, flip, ::$bvvar{namespace}.getActorNameForSkinDebug(_actor), _label);
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to spawn valkyrie death decal: " + e);
	}

	return false;
};

::$bvvar{namespace}.queueValkyrieDeathDecalAfterDeath <- function( _actor, _tile )
{
	if (_actor == null || _tile == null || !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return false;
	}

	try
	{
		local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);
		local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
		local deathBrush = skin != null && "DeathBrush" in skin ? skin.DeathBrush : null;

		if (deathBrush == null || deathBrush == "")
		{
			return false;
		}

		local pending = {
			Tile = _tile,
			Brush = deathBrush,
			Flip = false,
			ActorName = ::$bvvar{namespace}.getActorNameForSkinDebug(_actor)
		};

		if ("BattleValkyriesPendingDeathDecal" in _actor.m)
		{
			_actor.m.BattleValkyriesPendingDeathDecal = pending;
		}
		else
		{
			_actor.m.BattleValkyriesPendingDeathDecal <- pending;
		}

		::$bvvar{namespace}.log("[DeathFix] Queued final skin death decal " + deathBrush + " for " + pending.ActorName + " at player.onDeath");
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to queue final valkyrie death decal: " + e);
	}

	return false;
};

::$bvvar{namespace}.scheduleQueuedValkyrieDeathDecal <- function( _actor, _fallbackTile = null )
{
	if (_actor == null || !("m" in _actor) || !("BattleValkyriesPendingDeathDecal" in _actor.m))
	{
		return false;
	}

	local pending = _actor.m.BattleValkyriesPendingDeathDecal;
	_actor.m.rawdelete("BattleValkyriesPendingDeathDecal");

	if (pending == null)
	{
		return false;
	}

	if (pending.Tile == null)
	{
		pending.Tile = _fallbackTile;
	}

	try
	{
		pending.Flip = "IsCorpseFlipped" in _actor.m && _actor.m.IsCorpseFlipped;
	}
	catch (e)
	{
	}

	if (pending.Tile == null)
	{
		::$bvvar{namespace}.log("[DeathFix] Final death decal has no corpse tile for " + pending.ActorName + " brush=" + pending.Brush);
		return false;
	}

	try
	{
		::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _pending )
		{
			::$bvvar{namespace}.spawnValkyrieDeathBrushDecal(_pending.Brush, _pending.Tile, _pending.Flip, _pending.ActorName, "actor.onAfterDeath.deferred");
		}, pending);
		::$bvvar{namespace}.log("[DeathFix] Scheduled final skin death decal " + pending.Brush + " for " + pending.ActorName + " after actor.onAfterDeath");
		return true;
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to schedule final valkyrie death decal for " + pending.ActorName + ": " + e);
		return ::$bvvar{namespace}.spawnValkyrieDeathBrushDecal(pending.Brush, pending.Tile, pending.Flip, pending.ActorName, "actor.onAfterDeath.immediateFallback");
	}
};

::$bvvar{namespace}.getActorVisualSkinID <- function( _actor )
{
	::$bvvar{namespace}.syncActorValkyrieIdentity(_actor);
	local temporarySkinID = ::$bvvar{namespace}.getActorTemporaryValkyrieSkinID(_actor);
	local skinID = temporarySkinID != null && temporarySkinID != "" ? temporarySkinID : ::$bvvar{namespace}.getActorValkyrieSkinID(_actor);
	local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
	// Presentation-only fallback for gameplay releases whose battle art is pending.
	return skin != null && "UseVanillaAppearance" in skin && skin.UseVanillaAppearance ? null : skinID;
};

::$bvvar{namespace}.hasActorBattleValkyriesVisualSkin <- function( _actor )
{
	local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);
	return skinID != null && skinID != "" && ::$bvvar{namespace}.getSkin(skinID) != null;
};

::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	try
	{
		if ("m" in _actor && "BattleValkyriesDeathVisualSkin" in _actor.m && _actor.m.BattleValkyriesDeathVisualSkin)
		{
			return true;
		}
	}
	catch (e)
	{
	}

	try
	{
		return ::$bvvar{namespace}.hasActorBattleValkyriesVisualSkin(_actor);
	}
	catch (e)
	{
	}

	return false;
};

::$bvvar{namespace}.markActorBattleValkyriesDeathVisualSkin <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	if (!::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return false;
	}

	try
	{
		if ("m" in _actor)
		{
			if ("BattleValkyriesDeathVisualSkin" in _actor.m)
			{
				_actor.m.BattleValkyriesDeathVisualSkin = true;
			}
			else
			{
				_actor.m.BattleValkyriesDeathVisualSkin <- true;
			}
		}
	}
	catch (e)
	{
	}

	return true;
};

::$bvvar{namespace}.getActorFromItemContainer <- function( _container )
{
	if (_container == null || !("m" in _container) || !("Actor" in _container.m))
	{
		return null;
	}

	local actorRef = _container.m.Actor;

	if (actorRef == null || actorRef.isNull())
	{
		return null;
	}

	return actorRef.get();
};

::$bvvar{namespace}.shouldRefreshSkinAfterItemChange <- function( _container, _changedItem )
{
	local actor = ::$bvvar{namespace}.getActorFromItemContainer(_container);

	if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
	{
		return false;
	}

	return ::$bvvar{namespace}.getActorVisualSkinID(actor) != null;
};

::$bvvar{namespace}.applySkinToItemContainerAppearance <- function( _container )
{
	::$bvvar{namespace}.traceSkinContainer("containerAppearance.enter", _container);

	if (_container == null || !("m" in _container) || !("Actor" in _container.m) || !("Appearance" in _container.m))
	{
		return false;
	}

	local actorRef = _container.m.Actor;

	if (actorRef == null || actorRef.isNull())
	{
		return false;
	}

	local actor = actorRef.get();

	if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
	{
		return false;
	}

	::$bvvar{namespace}.syncActorValkyrieIdentity(actor);
	local skinID = ::$bvvar{namespace}.getActorVisualSkinID(actor);

	if (skinID == null || skinID == "")
	{
		::$bvvar{namespace}.traceSkinActor("containerAppearance.noSkinID", actor);
		return false;
	}

	local skin = ::$bvvar{namespace}.getSkin(skinID);

	if (skin == null)
	{
		::$bvvar{namespace}.traceSkinActor("containerAppearance.unknownSkin", actor, "skinID=" + skinID);
		return false;
	}

	local app = _container.m.Appearance;
	app.HideHead = true;
	app.HideCorpseHead = true;
	app.HideBody = true;
	app.HideHair = true;
	app.HideBeard = true;
	app.ShowQuiver = false;
	// HideBody controls rendering; keep a valid base brush because equipment
	// skill updates may still rebuild injury layers while a save is loading.
	app.Body = "bust_naked_body_01";
	app.Armor = "";
	app.ArmorUpgradeBack = "";
	app.ArmorUpgradeFront = "";
	app.Helmet = "";
	app.HelmetDamage = "";
	app.Quiver = "";
	app.Accessory = skin.Brush;

	if (::$bvvar{namespace}.getSettingValue("HideWeapons"))
	{
		app.Weapon = "";
		app.Shield = "";
		app.TwoHanded = false;
	}

	::$bvvar{namespace}.traceSkinContainer("containerAppearance.done", _container);
	return true;
};

::$bvvar{namespace}.reapplySkinFromItemContainer <- function( _container, _setDirty = true )
{
	if (_container == null || !("m" in _container) || !("Actor" in _container.m))
	{
		return;
	}

	local actorRef = _container.m.Actor;

	if (actorRef == null || actorRef.isNull())
	{
		return;
	}

	local actor = actorRef.get();

	if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor))
	{
		return;
	}

	::$bvvar{namespace}.applySkinToActor(actor, _setDirty);
};

::$bvvar{namespace}.prepareValkyrieDeathAppearance <- function( _actor, _fatalityType = null, _label = "" )
{
	if (_actor == null || !::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(_actor))
	{
		return;
	}

	try
	{
		local isDecapitated = _fatalityType != null && _fatalityType == ::Const.FatalityType.Decapitated;
		local skinID = ::$bvvar{namespace}.getActorVisualSkinID(_actor);
		local skin = skinID == null ? null : ::$bvvar{namespace}.getSkin(skinID);
		local deathBrush = skin != null && "DeathBrush" in skin ? skin.DeathBrush : null;
		// Original human death code resolves corpse art as body brush + "_dead".
		local useCustomDeathBrush = deathBrush != null && deathBrush != "" && deathBrush == skin.Brush + "_dead";
		local deathBodyBrush = useCustomDeathBrush ? skin.Brush : "bust_naked_body_01";
		local items = _actor.getItems();
		local suppressedCorpseLayerCount = 0;

		if (items != null)
		{
			// Mutate the authoritative appearance table. Some large packs rebuild a
			// temporary getAppearance() value while player.onDeath delegates to human,
			// whereas Legends reads m.Appearance when composing corpse layers.
			local appearance = "m" in items && "Appearance" in items.m ? items.m.Appearance : items.getAppearance();
			appearance.Body = deathBodyBrush;
			appearance.Corpse = useCustomDeathBrush ? deathBrush : "bust_naked_body_01_dead";

			// Legends builds a corpse from a stack of appearance fields instead of
			// only CorpseArmor. A whole-bust DeathBrush already contains the complete
			// outfit, so every corpse armor/helmet layer must be suppressed or it can
			// fully cover the custom death art (the SHS symptom was "only clothes").
			foreach (corpseLayerName in [
				"CorpseArmor",
				"CorpseArmorLayerChain",
				"CorpseArmorLayerPlate",
				"CorpseArmorLayerTabbard",
				"CorpseArmorLayerCloakBack",
				"CorpseArmorLayerCloakFront",
				"CorpseArmorUpgrade",
				"CorpseArmorUpgradeBack",
				"CorpseArmorUpgradeFront",
				"HelmetCorpse",
				"HelmetLayerHelmLowerCorpse",
				"HelmetLayerTopLowerCorpse",
				"HelmetLayerVanityLowerCorpse",
				"HelmetLayerVanity2LowerCorpse",
				"HelmetLayerHelmCorpse",
				"HelmetLayerTopCorpse",
				"HelmetLayerVanityCorpse",
				"HelmetLayerVanity2Corpse"
			])
			{
				if (corpseLayerName in appearance)
				{
					if (appearance[corpseLayerName] != "")
					{
						suppressedCorpseLayerCount = ++suppressedCorpseLayerCount;
					}

					appearance[corpseLayerName] = "";
				}
			}

			appearance.Accessory = "";
			appearance.ArmorUpgradeBack = "";
			appearance.ArmorUpgradeFront = "";
			appearance.Quiver = "";
			appearance.HideHead = true;
			appearance.HideCorpseHead = true;
			appearance.HideHair = true;
			appearance.HideBeard = true;
		}

		if ("m" in _actor && "Surcoat" in _actor.m)
		{
			_actor.m.Surcoat = null;
		}

		if (_actor.hasSprite("body"))
		{
			local body = _actor.getSprite("body");
			body.setBrush(deathBodyBrush);
			body.Visible = true;
			body.Alpha = 1.0;
		}

		if (_actor.hasSprite("head"))
		{
			local head = _actor.getSprite("head");

			if (isDecapitated || !head.HasBrush)
			{
				head.setBrush("bust_head_01");
			}

			head.Visible = false;
		}

		foreach( spriteName in [
			"accessory",
			"accessory_special",
			"hair",
			"beard",
			"beard_top",
			"helmet",
			"helmet_damage",
			"armor",
			"armor_upgrade_back",
			"armor_upgrade_front",
			"quiver",
			"injury",
			"injury_body",
			"surcoat",
			"tattoo_body",
			"tattoo_head"
		])
		{
			if (_actor.hasSprite(spriteName))
			{
				local sprite = _actor.getSprite(spriteName);
				sprite.setBrush("");
				sprite.Visible = false;
			}
		}

		// Preserve the body layer. The original death implementation turns this
		// into the corpse sprite, and hiding it here was the reason only a blood
		// decal remained on the ground in the SHS/Legends pack.
		::$bvvar{namespace}.hideWholeBustCompatibilitySprites(_actor, true);

		if (_actor.hasSprite("accessory"))
		{
			if (useCustomDeathBrush)
			{
				::$bvvar{namespace}.log("[DeathFix] Prepared custom skin death brush " + deathBrush + " for " + ::$bvvar{namespace}.getActorNameForSkinDebug(_actor) + " body=" + deathBodyBrush + " suppressedCorpseLayers=" + suppressedCorpseLayerCount + (_label == "" ? "" : " label=" + _label));
			}
			else
			{
				::$bvvar{namespace}.log("[DeathFix] Cleared valkyrie custom death appearance for " + ::$bvvar{namespace}.getActorNameForSkinDebug(_actor));
			}
		}
	}
	catch (e)
	{
		::$bvvar{namespace}.log("[DeathFix] Failed to prepare valkyrie death appearance: " + e);
	}
};

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onAppearanceChanged = @(__original) function( _appearance, _setDirty = true )
	{
		::$bvvar{namespace}.traceSkinActor("actor.onAppearanceChanged.before", this, ::$bvvar{namespace}.getAppearanceDebugText(_appearance));
		__original(_appearance, _setDirty);
		::$bvvar{namespace}.applySkinToActor(this, _setDirty);
		::$bvvar{namespace}.traceSkinActor("actor.onAppearanceChanged.after", this, ::$bvvar{namespace}.getAppearanceDebugText(_appearance));
	}
});

// Player-level death wrappers in large packs may rebuild equipment appearance
// before delegating to human.onDeath. Re-prepare at the final corpse-composition
// boundary so Legends reads the custom body and the cleared corpse layer stack.
// The real killing skill is always forwarded unchanged; skin death rendering must
// not alter combat input or depend on individual skills.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/human", function(q) {
	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		local hasCustomDeathVisual = ::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(this);

		if (hasCustomDeathVisual)
		{
			::$bvvar{namespace}.prepareValkyrieDeathAppearance(this, _fatalityType, "human.onDeath.beforeOriginal");
		}

		return __original(_killer, _skill, _tile, _fatalityType);
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onUpdateInjuryLayer = @(__original) function()
	{
		local ret = __original();
		// Vanilla and Legends may reactivate injury/blood/scar sprites after a
		// hitpoint or equipment-driven property refresh. Reapply the whole-bust
		// mask after their brush work has completed; brushes remain intact.
		::$bvvar{namespace}.applySkinToActor(this, false);
		return ret;
	}
});

::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.updateAppearance = @(__original) function()
	{
		::$bvvar{namespace}.traceSkinContainer("item_container.updateAppearance.before", this);
		__original();
		::$bvvar{namespace}.applySkinToItemContainerAppearance(this);
		::$bvvar{namespace}.reapplySkinFromItemContainer(this, true);
		::$bvvar{namespace}.traceSkinContainer("item_container.updateAppearance.after", this);
	}

	q.equip = @(__original) function( _item )
	{
		::$bvvar{namespace}.traceSkinContainer("item_container.equip.before", this);
		local ret = __original(_item);

		if (ret && ::$bvvar{namespace}.shouldRefreshSkinAfterItemChange(this, _item))
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(this);
			::$bvvar{namespace}.reapplySkinFromItemContainer(this, true);
		}

		::$bvvar{namespace}.traceSkinContainer("item_container.equip.after ret=" + ::$bvvar{namespace}.skinDebugValue(ret), this);
		return ret;
	}

	q.unequip = @(__original) function( _item )
	{
		::$bvvar{namespace}.traceSkinContainer("item_container.unequip.before", this);
		local ret = __original(_item);

		if (ret && ::$bvvar{namespace}.shouldRefreshSkinAfterItemChange(this, _item))
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(this);
			::$bvvar{namespace}.reapplySkinFromItemContainer(this, true);
		}

		::$bvvar{namespace}.traceSkinContainer("item_container.unequip.after ret=" + ::$bvvar{namespace}.skinDebugValue(ret), this);
		return ret;
	}

	q.swap = @(__original) function( _itemA, _itemB )
	{
		::$bvvar{namespace}.traceSkinContainer("item_container.swap.before", this);
		local ret = __original(_itemA, _itemB);

		if (ret && (::$bvvar{namespace}.shouldRefreshSkinAfterItemChange(this, _itemA) || ::$bvvar{namespace}.shouldRefreshSkinAfterItemChange(this, _itemB)))
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(this);
			::$bvvar{namespace}.reapplySkinFromItemContainer(this, true);
		}

		::$bvvar{namespace}.traceSkinContainer("item_container.swap.after ret=" + ::$bvvar{namespace}.skinDebugValue(ret), this);
		return ret;
	}
});

::$bvvar{namespace}.skinDebugValue <- function( _value )
{
	return _value == null ? "null" : "" + _value;
};

::$bvvar{namespace}.getActorNameForSkinDebug <- function( _actor )
{
	if (_actor == null)
	{
		return "null";
	}

	local actorName = null;

	try
	{
		actorName = _actor.getNameOnly();
	}
	catch (e)
	{
		actorName = null;
	}

	if (actorName == null || actorName == "")
	{
		try
		{
			actorName = _actor.getName();
		}
		catch (e)
		{
			actorName = null;
		}
	}

	return actorName == null || actorName == "" ? "unknown" : actorName;
};

::$bvvar{namespace}.getActorNameForDeathDebug <- function( _actor )
{
	try
	{
		return ::$bvvar{namespace}.getActorNameForSkinDebug(_actor);
	}
	catch (e)
	{
	}

	return "unknown";
};

::$bvvar{namespace}.getAppearanceDebugText <- function( _appearance )
{
	if (_appearance == null)
	{
		return "appearance=null";
	}

	return "Weapon=" + _appearance.Weapon
		+ " Shield=" + _appearance.Shield
		+ " Body=" + _appearance.Body
		+ " Armor=" + _appearance.Armor
		+ " Helmet=" + _appearance.Helmet
		+ " Accessory=" + _appearance.Accessory
		+ " HideHead=" + ::$bvvar{namespace}.skinDebugValue(_appearance.HideHead)
		+ " HideBody=" + ::$bvvar{namespace}.skinDebugValue(_appearance.HideBody);
};

::$bvvar{namespace}.traceSkinActor <- function( _label, _actor, _extra = "" )
{
	if (!::$bvvar{namespace}.getSettingValue("DebugSkin") || _actor == null)
	{
		return;
	}

	local flagID = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieIDFlag);
	local flagSkin = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
	local traitSkin = ::$bvvar{namespace}.getActorValkyrieSkinIDFromTrait(_actor);
	local resolvedID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
	local resolvedSkin = ::$bvvar{namespace}.getActorValkyrieSkinID(_actor);
	local visualSkin = ::$bvvar{namespace}.getActorVisualSkinID(_actor);

	if (flagID == null && flagSkin == null && traitSkin == null && resolvedID == null && resolvedSkin == null && visualSkin == null)
	{
		return;
	}

	local aliveText = "unknown";
	local playerText = "unknown";

	try
	{
		aliveText = ::$bvvar{namespace}.skinDebugValue(_actor.isAlive());
	}
	catch (e)
	{
		aliveText = "unknown";
	}

	try
	{
		playerText = ::$bvvar{namespace}.skinDebugValue(_actor.isPlayerControlled());
	}
	catch (e)
	{
		playerText = "unknown";
	}

	::$bvvar{namespace}.log("[SkinDebug] " + _label
		+ " actor=" + ::$bvvar{namespace}.getActorNameForSkinDebug(_actor)
		+ " alive=" + aliveText
		+ " player=" + playerText
		+ " flag=" + ::$bvvar{namespace}.skinDebugValue(flagID) + "/" + ::$bvvar{namespace}.skinDebugValue(flagSkin)
		+ " traitSkin=" + ::$bvvar{namespace}.skinDebugValue(traitSkin)
		+ " resolved=" + ::$bvvar{namespace}.skinDebugValue(resolvedID) + "/" + ::$bvvar{namespace}.skinDebugValue(resolvedSkin)
		+ " visualSkin=" + ::$bvvar{namespace}.skinDebugValue(visualSkin)
		+ (_extra == "" ? "" : " " + _extra));
};

::$bvvar{namespace}.traceSkinContainer <- function( _label, _container )
{
	if (!::$bvvar{namespace}.getSettingValue("DebugSkin") || _container == null || !("m" in _container) || !("Actor" in _container.m))
	{
		return;
	}

	local actorRef = _container.m.Actor;

	if (actorRef == null || actorRef.isNull())
	{
		return;
	}

	local extra = "";

	if ("Appearance" in _container.m)
	{
		extra = ::$bvvar{namespace}.getAppearanceDebugText(_container.m.Appearance);
	}

	::$bvvar{namespace}.traceSkinActor(_label, actorRef.get(), extra);
};

::$bvvar{namespace}.reapplyAllRosterSkins <- function( _label )
{
	local roster = null;

	try
	{
		if (::World != null)
		{
			roster = ::World.getPlayerRoster();
		}
	}
	catch (e)
	{
		roster = null;
	}

	if (roster == null)
	{
		::$bvvar{namespace}.log("[SkinDebug] " + _label + " roster=null");
		return 0;
	}

	local count = 0;

	foreach( bro in roster.getAll() )
	{
		if (bro == null)
		{
			continue;
		}

		if (::$bvvar{namespace}.isActorDeadOrDying(bro))
		{
			continue;
		}

		::$bvvar{namespace}.syncActorValkyrieIdentity(bro);
		local skinID = ::$bvvar{namespace}.getActorVisualSkinID(bro);

		if (skinID == null || skinID == "")
		{
			continue;
		}

		::$bvvar{namespace}.traceSkinActor(_label + ".before", bro);

		local items = null;

		try
		{
			items = bro.getItems();
		}
		catch (e)
		{
			items = null;
		}

		if (items != null)
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(items);
		}

		::$bvvar{namespace}.applySkinToActor(bro, true);
		::$bvvar{namespace}.traceSkinActor(_label + ".after", bro);
		count = ++count;
	}

	::$bvvar{namespace}.log("[SkinDebug] " + _label + " reapplyCount=" + count);
	return count;
};

::$bvvar{namespace}.withBattleValkyriesDeathFatalityCompat <- function( _actor, _fatalityType, _renderFatalityType )
{
	local state = {
		Applied = false,
		Original = null
	};

	if (_actor == null || _fatalityType == _renderFatalityType)
	{
		return state;
	}

	local flags = null;

	try
	{
		flags = _actor.getFlags();
	}
	catch (e)
	{
		flags = null;
	}

	if (flags == null || !flags.has("ftg_fatality_type"))
	{
		return state;
	}

	try
	{
		state.Original = flags.get("ftg_fatality_type");
		flags.set("ftg_fatality_type", _renderFatalityType);
		state.Applied = true;

		if ("m" in _actor)
		{
			_actor.m.BattleValkyriesOriginalFtgFatalityType <- state.Original;
		}
	}
	catch (e)
	{
		state.Applied = false;
	}

	return state;
};

::$bvvar{namespace}.restoreBattleValkyriesDeathFatalityCompat <- function( _actor, _state )
{
	if (_actor == null || _state == null || !("Applied" in _state) || !_state.Applied)
	{
		return;
	}

	try
	{
		local flags = _actor.getFlags();

		if (flags != null)
		{
			flags.set("ftg_fatality_type", _state.Original);
		}
	}
	catch (e)
	{
	}

	try
	{
		if ("m" in _actor && "BattleValkyriesOriginalFtgFatalityType" in _actor.m)
		{
			_actor.m.rawdelete("BattleValkyriesOriginalFtgFatalityType");
		}
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.traceSkinActor("player.onDeserialize.afterOriginal", this);

		if (!::$bvvar{namespace}.isActorDeadOrDying(this))
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(this.getItems());
			::$bvvar{namespace}.applySkinToActor(this, true);
		}

		::$bvvar{namespace}.traceSkinActor("player.onDeserialize.afterApply", this);
	}

	q.onDeath = @(__original) function( _killer, _skill, _tile, _fatalityType )
	{
		if (!::$bvvar{namespace}.markActorBattleValkyriesDeathVisualSkin(this))
		{
			return __original(_killer, _skill, _tile, _fatalityType);
		}

		::$bvvar{namespace}.logValkyrieDeathDropPreview(this, _killer, _tile, "player.onDeath.beforePrepare", true);
		local queuedDeathDecal = ::$bvvar{namespace}.queueValkyrieDeathDecalAfterDeath(this, _tile);
		local renderFatalityType = _fatalityType;

		if (_fatalityType == ::Const.FatalityType.Decapitated && ::$bvvar{namespace}.hasActorBattleValkyriesDeathVisualSkin(this))
		{
			renderFatalityType = ::Const.FatalityType.None;
			::$bvvar{namespace}.log("[DeathFix] Rendering decapitated valkyrie death as custom corpse for " + ::$bvvar{namespace}.getActorNameForDeathDebug(this));
		}

		local ftgFatalityCompat = ::$bvvar{namespace}.withBattleValkyriesDeathFatalityCompat(this, _fatalityType, renderFatalityType);

		try
		{
			local ret = __original(_killer, _skill, _tile, renderFatalityType);
			// actor.kill still runs die() and onAfterDeath() after this player callback.
			// The queued DeathBrush is placed only after those final cleanup steps.
			::$bvvar{namespace}.log("[DeathFix] Original corpse pipeline completed for " + ::$bvvar{namespace}.getActorNameForDeathDebug(this) + " queuedFinalDeathDecal=" + (queuedDeathDecal ? "true" : "false"));
			::$bvvar{namespace}.restoreBattleValkyriesDeathFatalityCompat(this, ftgFatalityCompat);
			return ret;
		}
		catch (e)
		{
			::$bvvar{namespace}.restoreBattleValkyriesDeathFatalityCompat(this, ftgFatalityCompat);
			::$bvvar{namespace}.log("[DeathFix] Suppressed valkyrie onDeath error for " + ::$bvvar{namespace}.getActorNameForDeathDebug(this) + ": " + e);
			// onDeath can run while the actor still reports its pre-hit HP. This is an
			// authoritative death boundary, so force the state but keep the victim on
			// its tile until actor.kill finishes onOtherActorDeath notifications. SHS
			// Sellswords reads _victim.getTile() during that broadcast and crashes in
			// native code if a compatibility fallback removed the actor too early.
			local recovered = ::$bvvar{namespace}.finishInvalidValkyrieDeathStateSafe(this, _killer, _skill, "player.onDeath.catch", false, true);
			::$bvvar{namespace}.log("[DeathFix] Deferred-removal death recovery " + (recovered ? "completed" : "failed") + " for " + ::$bvvar{namespace}.getActorNameForDeathDebug(this));
			return null;
		}
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.reapplyAllRosterSkins("world_state.onDeserialize.afterOriginal");
	}

	q.onShow = @(__original) function()
	{
		__original();
		::$bvvar{namespace}.reapplyAllRosterSkins("world_state.onShow.afterOriginal");
	}
});
::$bvvar{namespace}.TemporaryValkyrieSkinID <- "BattleValkyriesTemporarySkinID";

::$bvvar{namespace}.getActorTemporaryValkyrieSkinID <- function( _actor )
{
	if (_actor == null)
	{
		return null;
	}

	try
	{
		local flags = _actor.getFlags();

		if (flags == null || !flags.has(::$bvvar{namespace}.TemporaryValkyrieSkinID))
		{
			return null;
		}

		return flags.get(::$bvvar{namespace}.TemporaryValkyrieSkinID);
	}
	catch (e)
	{
	}

	return null;
};

::$bvvar{namespace}.setActorTemporaryValkyrieSkin <- function( _actor, _skinID )
{
	if (_actor == null || _skinID == null || _skinID == "" || ::$bvvar{namespace}.getSkin(_skinID) == null)
	{
		return false;
	}

	try
	{
		local flags = _actor.getFlags();

		if (flags == null)
		{
			return false;
		}

		flags.set(::$bvvar{namespace}.TemporaryValkyrieSkinID, _skinID);
	}
	catch (e)
	{
		return false;
	}

	::$bvvar{namespace}.refreshActorValkyrieVisual(_actor);
	return true;
};

::$bvvar{namespace}.refreshActorValkyrieVisual <- function( _actor )
{
	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
	{
		return false;
	}

	try
	{
		local items = _actor.getItems();

		if (items != null)
		{
			::$bvvar{namespace}.applySkinToItemContainerAppearance(items);
			// Route through the normal appearance pipeline so tactical sprites refresh during the same action.
			items.updateAppearance();
		}
	}
	catch (e)
	{
	}

	::$bvvar{namespace}.applySkinToActor(_actor, true);

	try
	{
		_actor.setDirty(true);
	}
	catch (e)
	{
	}

	return true;
};

::$bvvar{namespace}.refreshActorTemporaryValkyrieSkin <- function( _actor, _skinID )
{
	return ::$bvvar{namespace}.setActorTemporaryValkyrieSkin(_actor, _skinID);
};

::$bvvar{namespace}.clearActorTemporaryValkyrieSkin <- function( _actor )
{
	if (_actor == null)
	{
		return false;
	}

	local hadTemporarySkin = false;

	try
	{
		local flags = _actor.getFlags();

		if (flags != null && flags.has(::$bvvar{namespace}.TemporaryValkyrieSkinID))
		{
			flags.remove(::$bvvar{namespace}.TemporaryValkyrieSkinID);
			hadTemporarySkin = true;
		}
	}
	catch (e)
	{
	}

	if (hadTemporarySkin)
	{
		::$bvvar{namespace}.refreshActorValkyrieVisual(_actor);
	}

	return hadTemporarySkin;
};

::$bvvar{namespace}.clearAllTemporaryValkyrieSkins <- function( _label )
{
	local roster = null;

	try
	{
		roster = ::World == null ? null : ::World.getPlayerRoster();
	}
	catch (e)
	{
		roster = null;
	}

	if (roster == null)
	{
		return 0;
	}

	local count = 0;

	foreach( bro in roster.getAll() )
	{
		if (::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(bro))
		{
			count = ++count;
		}
	}

	if (_label != null && ::$bvvar{namespace}.getSettingValue("DebugSkin"))
	{
		::$bvvar{namespace}.log("[SkinDebug] " + _label + " clearedTemporarySkins=" + count);
	}

	return count;
};
