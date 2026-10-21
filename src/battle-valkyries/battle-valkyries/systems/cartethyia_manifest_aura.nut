// Manifest is rendered only as a persistent ground ring. Do not attach whole
// VFX sprites to the actor: they leak into portrait render targets.
::$bvvar{namespace}.CartethyiaManifestAuraLegacySprites <- [
	"bv_cartethyia_orbit_arc_a",
	"bv_cartethyia_orbit_arc_b",
	"bv_cartethyia_orbit_mote"
];

::$bvvar{namespace}.CartethyiaManifestAuraActorRef <- null;

::$bvvar{namespace}.logCartethyiaManifestAura <- function( _stage, _actor = null, _details = "" )
{
	local actorID = "unknown";
	local actorName = "unknown";
	try { actorID = _actor == null ? "null" : _actor.getID(); } catch (e) {}
	try { actorName = _actor == null ? "null" : _actor.getName(); } catch (e) {}
	try
	{
		::logInfo("[Battle Valkyries] [CartethyiaAura] stage=" + _stage
			+ " actor=" + actorID + " name=" + actorName
			+ (_details == "" ? "" : " " + _details));
	}
	catch (e) {}
};

::$bvvar{namespace}.getCartethyiaManifestAuraTime <- function()
{
	try { return ::Time.getVirtualTimeF(); } catch (e) { return 0.0; }
};

::$bvvar{namespace}.getCartethyiaManifestAuraState <- function( _actor, _create = false )
{
	if (_actor == null) return null;
	local actorState = null;
	try { actorState = _actor.m; } catch (e) { return null; }
	if (actorState == null) return null;
	if (!("BattleValkyriesCartethyiaManifestAura" in actorState))
	{
		if (!_create) return null;
		actorState.BattleValkyriesCartethyiaManifestAura <- {
			Active = false,
			NextGroundRingAt = 0.0,
			NextDebugLogAt = 0.0,
			NextCompatibilityCleanupAt = 0.0,
			CompatibilityCleanupSamples = 0,
			NextSpriteAuditAt = 0.0,
			SpriteAuditSamples = 0,
			HasLoggedUpdate = false,
			LastUpdateFrame = null,
			GroundPulses = 0
		};
	}
	return actorState.BattleValkyriesCartethyiaManifestAura;
};

::$bvvar{namespace}.hideCartethyiaManifestAuraLegacySprites <- function( _actor )
{
	if (_actor == null) return;
	foreach (name in ::$bvvar{namespace}.CartethyiaManifestAuraLegacySprites)
	{
		try
		{
			if (!_actor.hasSprite(name)) continue;
			local sprite = _actor.getSprite(name);
			sprite.Visible = false;
			sprite.Alpha = 0;
		}
		catch (e) {}
	}
};

::$bvvar{namespace}.hasCartethyiaManifestEffect <- function( _actor )
{
	try
	{
		return _actor != null
			&& _actor.getSkills() != null
			&& _actor.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_fleurdelys_manifest") != null;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.startCartethyiaManifestAura <- function( _actor )
{
	if (_actor == null) return false;
	local state = ::$bvvar{namespace}.getCartethyiaManifestAuraState(_actor, true);
	if (state == null)
	{
		::$bvvar{namespace}.logCartethyiaManifestAura("start-failed", _actor, "reason=state-unavailable");
		return false;
	}

	local now = ::$bvvar{namespace}.getCartethyiaManifestAuraTime();
	state.Active = true;
	state.NextGroundRingAt = now;
	state.NextDebugLogAt = now;
	state.NextCompatibilityCleanupAt = now;
	state.CompatibilityCleanupSamples = 0;
	state.NextSpriteAuditAt = now;
	state.SpriteAuditSamples = 0;
	state.HasLoggedUpdate = false;
	state.LastUpdateFrame = null;
	state.GroundPulses = 0;
	::$bvvar{namespace}.hideCartethyiaManifestAuraLegacySprites(_actor);
	try { ::$bvvar{namespace}.CartethyiaManifestAuraActorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor); }
	catch (e) { ::$bvvar{namespace}.CartethyiaManifestAuraActorRef = _actor; }
	::$bvvar{namespace}.logCartethyiaManifestAura("started", _actor, "mode=staggered-lightning time=" + now);
	return true;
};

::$bvvar{namespace}.stopCartethyiaManifestAura <- function( _actor, _reason = "explicit" )
{
	local state = ::$bvvar{namespace}.getCartethyiaManifestAuraState(_actor, false);
	local wasActive = state != null && state.Active;
	if (state != null) state.Active = false;
	local registered = null;
	try { registered = ::$bvvar{namespace}.readValkyrieCombatWeakRef(::$bvvar{namespace}.CartethyiaManifestAuraActorRef); }
	catch (e) { registered = ::$bvvar{namespace}.CartethyiaManifestAuraActorRef; }
	if (registered == _actor) ::$bvvar{namespace}.CartethyiaManifestAuraActorRef = null;
	::$bvvar{namespace}.hideCartethyiaManifestAuraLegacySprites(_actor);
	if (wasActive) ::$bvvar{namespace}.logCartethyiaManifestAura("stopped", _actor, "reason=" + _reason);
};

::$bvvar{namespace}.updateCartethyiaManifestAura <- function( _actor )
{
	local state = ::$bvvar{namespace}.getCartethyiaManifestAuraState(_actor, false);
	if (state == null || !state.Active) return false;
	local updateFrame = null;
	try { updateFrame = ::Time.getFrame(); } catch (e) {}
	if (updateFrame != null && state.LastUpdateFrame == updateFrame) return true;
	state.LastUpdateFrame = updateFrame;
	if (!state.HasLoggedUpdate)
	{
		state.HasLoggedUpdate = true;
		::$bvvar{namespace}.logCartethyiaManifestAura("update-enter", _actor, "source=tactical_state.onUpdate frame=" + (updateFrame == null ? "none" : updateFrame));
	}

	try
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_actor)
			|| (("isPlacedOnMap" in _actor) && !_actor.isPlacedOnMap())
			|| !::$bvvar{namespace}.hasCartethyiaManifestEffect(_actor))
		{
			::$bvvar{namespace}.stopCartethyiaManifestAura(_actor, "invalid-state");
			return false;
		}
	}
	catch (e)
	{
		::$bvvar{namespace}.logCartethyiaManifestAura("validation-exception", _actor, "reason=" + e);
		::$bvvar{namespace}.stopCartethyiaManifestAura(_actor, "validation-exception");
		return false;
	}

	local now = ::$bvvar{namespace}.getCartethyiaManifestAuraTime();
	if (state.CompatibilityCleanupSamples < 3 && now >= state.NextCompatibilityCleanupAt)
	{
		// Legends can re-apply fresh/permanent injury brushes after the temporary
		// whole-bust skin has already been installed. Keep gameplay injuries, but
		// suppress their visual layers while the manifestation is active.
		try
		{
			if ("hideWholeBustCompatibilitySprites" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.hideWholeBustCompatibilitySprites(_actor);
			}
		}
		catch (e)
		{
			::$bvvar{namespace}.logCartethyiaManifestAura("compatibility-cleanup-exception", _actor, "reason=" + e);
		}
		state.CompatibilityCleanupSamples = state.CompatibilityCleanupSamples + 1;
		state.NextCompatibilityCleanupAt = now + (state.CompatibilityCleanupSamples == 1 ? 0.50 : 0.75);
	}
	if (state.SpriteAuditSamples < 3 && now >= state.NextSpriteAuditAt)
	{
		// Samples are intentionally bounded. A manifestation can be held for a
		// long time, but we only need the initial sprite state plus two delayed
		// checks to catch an external appearance hook that re-enables a layer.
		try
		{
			if ("logWholeBustSpriteAudit" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.logWholeBustSpriteAudit(_actor, "cartethyia-manifest-" + (state.SpriteAuditSamples + 1));
			}
		}
		catch (e)
		{
			::$bvvar{namespace}.logCartethyiaManifestAura("sprite-audit-exception", _actor, "reason=" + e);
		}
		state.SpriteAuditSamples = state.SpriteAuditSamples + 1;
		state.NextSpriteAuditAt = now + (state.SpriteAuditSamples == 1 ? 0.25 : 0.75);
	}
	if (now >= state.NextGroundRingAt)
	{
		::$bvvar{namespace}.playValkyrieVisual(_actor, _actor, "cartethyia_manifest_ground");
		// Keep the ring almost static and refresh it only after several seconds.
		// A short expanding pulse made the transformed actor look as though its
		// whole-bust skin were repeatedly refreshing.
		state.NextGroundRingAt = now + 3.90;
		state.GroundPulses = state.GroundPulses + 1;
	}
	if (now >= state.NextDebugLogAt)
	{
		::$bvvar{namespace}.logCartethyiaManifestAura("heartbeat", _actor,
			"frame=" + (updateFrame == null ? "none" : updateFrame)
			+ " ground=" + state.GroundPulses + " nextGround=" + state.NextGroundRingAt);
		state.NextDebugLogAt = now + 2.0;
	}
	return true;
};

::$bvvar{namespace}.updateActiveCartethyiaManifestAura <- function()
{
	local actor = null;
	try { actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(::$bvvar{namespace}.CartethyiaManifestAuraActorRef); }
	catch (e) { actor = ::$bvvar{namespace}.CartethyiaManifestAuraActorRef; }
	if (actor == null) return false;
	return ::$bvvar{namespace}.updateCartethyiaManifestAura(actor);
};
