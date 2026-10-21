::$bvvar{namespace}.ValkyrieSummonRosterMax <- 20;
::$bvvar{namespace}.getValkyrieChapterRecruitHint <- function(template)
{
	return template != null && "ChapterRecruitHint" in template ? template.ChapterRecruitHint : "$bv{chapter.black_city.recruit_only}";
};
::$bvvar{namespace}.ValkyrieSummonCost <- 1000;
::$bvvar{namespace}.ValkyrieSummonCostSteps <- [
	{ Max = 1, Cost = 1000 },
	{ Max = 2, Cost = 3000 },
	{ Max = 3, Cost = 6000 },
	{ Max = 6, Cost = 10000 },
	{ Max = 10, Cost = 18000 },
	{ Max = 15, Cost = 28000 },
	{ Max = 20, Cost = 44800 }
];
::$bvvar{namespace}.ValkyrieGachaProgressMax <- 4;
::$bvvar{namespace}.ValkyrieGachaCostSteps <- [
	{ MaxGuarantees = 0, Cost = 100 },
	{ MaxGuarantees = 1, Cost = 1200 },
	{ MaxGuarantees = 2, Cost = 3000 },
	{ MaxGuarantees = 3, Cost = 6000 },
	{ MaxGuarantees = 4, Cost = 8000 },
	{ MaxGuarantees = 999, Cost = 15000 }
];
::$bvvar{namespace}.ValkyrieGachaProgressFlag <- "BattleValkyries.GachaProgress";
::$bvvar{namespace}.ValkyrieGachaGuaranteeCountFlag <- "BattleValkyries.GachaGuaranteeCount";
::$bvvar{namespace}.ValkyrieGachaSelectedValkyrieIDFlag <- "BattleValkyries.GachaSelectedValkyrieID";
::$bvvar{namespace}.ValkyrieGachaSelectedSkinIDFlag <- "BattleValkyries.GachaSelectedSkinID";
::$bvvar{namespace}.ValkyrieSummonFormationSlots <- 27;
::$bvvar{namespace}.ValkyrieSummonCombatSlots <- 18;
::$bvvar{namespace}.ValkyrieSummonReserveSlotStart <- 18;
::$bvvar{namespace}.ValkyrieSummonNotInFormation <- 255;

::$bvvar{namespace}.findValkyrieInRoster <- function( _valkyrieID )
{
	local roster = ::World.getPlayerRoster().getAll();

	foreach( bro in roster )
	{
		if (::$bvvar{namespace}.getActorValkyrieID(bro) == _valkyrieID)
		{
			return bro;
		}
	}

	return null;
};

::$bvvar{namespace}.isPartialValkyrieSummon <- function( _bro )
{
	if (_bro == null || ::$bvvar{namespace}.getActorValkyrieID(_bro) == null)
	{
		return false;
	}

	local background = null;

	try
	{
		background = _bro.getBackground();
	}
	catch (e)
	{
		background = null;
	}

	return background == null
		|| _bro.m.Attributes.len() < ::Const.Attributes.COUNT
		|| _bro.m.Talents.len() < ::Const.Attributes.COUNT;
};

::$bvvar{namespace}.removePartialValkyrieSummons <- function()
{
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return 0;
	}

	local removed = 0;
	local roster = ::World.getPlayerRoster();
	local bros = clone roster.getAll();

	foreach( bro in bros )
	{
		if (::$bvvar{namespace}.isPartialValkyrieSummon(bro))
		{
			roster.remove(bro);
			removed = ++removed;
		}
	}

	if (removed > 0 && ::World.State != null && ::World.State.getPlayer() != null)
	{
		::World.State.getPlayer().updateStrength();
	}

	return removed;
};

::$bvvar{namespace}.getValkyrieSummonRosterMax <- function()
{
	return ::$bvvar{namespace}.getValkyrieEffectiveRosterMax();
};

::$bvvar{namespace}.isValidValkyrieRosterMax <- function( _value )
{
	local valueType = typeof _value;
	return (valueType == "integer" || valueType == "float") && _value > 0;
};

::$bvvar{namespace}.getValkyrieRosterMaxFromConst <- function()
{
	try
	{
		if (!("Roster" in ::Const) || !("Size" in ::Const.Roster) || ::Const.Roster.Size == null || ::Const.Roster.Size.len() == 0)
		{
			return null;
		}

		local ret = ::Const.Roster.Size[::Const.Roster.Size.len() - 1];
		return ::$bvvar{namespace}.isValidValkyrieRosterMax(ret) ? ret : null;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieDirect36RosterMax <- function()
{
	local rosterMod = null;

	try
	{
		rosterMod = ::Mod_36Brothers;
	}
	catch (e)
	{
		return null;
	}

	if (rosterMod == null || !("getRosterMode" in rosterMod) || !("ModeDirect36" in rosterMod))
	{
		return null;
	}

	try
	{
		return rosterMod.getRosterMode() == rosterMod.ModeDirect36 ? ::$bvvar{namespace}.getValkyrieRosterMaxFromConst() : null;
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieLegacyExpandedRosterMax <- function()
{
	local rosterMod = null;

	try
	{
		rosterMod = ::ER;
	}
	catch (e)
	{
		return null;
	}

	if (rosterMod == null || !("ID" in rosterMod) || rosterMod.ID != "mod_ER_Legends")
	{
		return null;
	}

	local ret = ::$bvvar{namespace}.getValkyrieRosterMaxFromConst();

	if (::World != null && ::World.Assets != null)
	{
		try
		{
			if ("m" in ::World.Assets && ::World.Assets.m != null && "BrothersMax" in ::World.Assets.m
				&& ::$bvvar{namespace}.isValidValkyrieRosterMax(::World.Assets.m.BrothersMax)
				&& (ret == null || ::World.Assets.m.BrothersMax > ret))
			{
				ret = ::World.Assets.m.BrothersMax;
			}
		}
		catch (e)
		{
		}

		try
		{
			if ("getFormation" in ::World.Assets)
			{
				local formation = ::World.Assets.getFormation();

				if (formation != null && formation.len() > 0 && (ret == null || formation.len() > ret))
				{
					ret = formation.len();
				}
			}
		}
		catch (e)
		{
		}
	}

	return ret;
};

::$bvvar{namespace}.getValkyrieEffectiveRosterMax <- function()
{
	// The built-in roster service owns capacity in both supported environments.
	// Retain legacy resolution below for isolated consumers without the service.
	if ("Roster" in ::$bvvar{namespace} && ::$bvvar{namespace}.Roster.available())
		return ::World.Assets.getBrothersMax();
	local ret = null;

	if (::World != null && ::World.Assets != null && "getBrothersMax" in ::World.Assets)
	{
		try
		{
			local candidate = ::World.Assets.getBrothersMax();
			ret = ::$bvvar{namespace}.isValidValkyrieRosterMax(candidate) ? candidate : null;
		}
		catch (e)
		{
		}
	}

	// The current 36-brother patch normally exposes 36 through getBrothersMax().
	// Resolve its direct mode independently as well, so a later conflicting hook
	// cannot silently restore the vanilla/Legends value of 20.
	local direct36Max = ::$bvvar{namespace}.getValkyrieDirect36RosterMax();

	if (direct36Max != null && (ret == null || direct36Max > ret))
	{
		ret = direct36Max;
	}

	// Older Expanded Roster builds only enlarged m.BrothersMax, Const.Roster or
	// the formation array. Their getBrothersMax() can therefore still report 20.
	local legacyExpandedMax = ::$bvvar{namespace}.getValkyrieLegacyExpandedRosterMax();

	if (legacyExpandedMax != null && (ret == null || legacyExpandedMax > ret))
	{
		ret = legacyExpandedMax;
	}

	if (ret != null)
	{
		return ret;
	}

	// Generic/vanilla fallback for capacity mods which replace the stored limit
	// but do not provide getBrothersMax(). Do not mix this value into a valid
	// dynamic Legends result, because that would bypass reputation/origin caps.
	if (::World != null && ::World.Assets != null)
	{
		try
		{
			if ("m" in ::World.Assets && ::World.Assets.m != null && "BrothersMax" in ::World.Assets.m
				&& ::$bvvar{namespace}.isValidValkyrieRosterMax(::World.Assets.m.BrothersMax))
			{
				return ::World.Assets.m.BrothersMax;
			}
		}
		catch (e)
		{
		}

		try
		{
			if ("getFormation" in ::World.Assets)
			{
				local formation = ::World.Assets.getFormation();

				if (formation != null && formation.len() > 0)
				{
					return formation.len();
				}
			}
		}
		catch (e)
		{
		}
	}

	return ::$bvvar{namespace}.ValkyrieSummonRosterMax;
};

::$bvvar{namespace}.getSummonedValkyrieCount <- function()
{
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return 0;
	}

	local count = 0;
	foreach( bro in ::World.getPlayerRoster().getAll() )
	{
		if (::$bvvar{namespace}.isActorValkyrie(bro))
		{
			count = ++count;
		}
	}

	return count;
};

::$bvvar{namespace}.getValkyrieSummonCost <- function()
{
	local nextSummonIndex = ::$bvvar{namespace}.getSummonedValkyrieCount() + 1;

	foreach( step in ::$bvvar{namespace}.ValkyrieSummonCostSteps )
	{
		if (nextSummonIndex <= step.Max)
		{
			return step.Cost;
		}
	}

	return ::$bvvar{namespace}.ValkyrieSummonCostSteps[::$bvvar{namespace}.ValkyrieSummonCostSteps.len() - 1].Cost;
};

::$bvvar{namespace}.getGachaWorldFlag <- function( _flag, _defaultValue )
{
	if (::World == null || ::World.Flags == null || !::World.Flags.has(_flag))
	{
		return _defaultValue;
	}

	local value = ::World.Flags.get(_flag);
	return value;
};

::$bvvar{namespace}.setGachaWorldFlag <- function( _flag, _value )
{
	if (::World == null || ::World.Flags == null)
	{
		return false;
	}

	::World.Flags.set(_flag, _value);
	return true;
};

::$bvvar{namespace}.getValkyrieGachaProgress <- function()
{
	local progress = ::$bvvar{namespace}.getGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaProgressFlag, ::$bvvar{namespace}.ValkyrieGachaProgressMax);
	return ::Math.max(0, ::Math.min(::$bvvar{namespace}.ValkyrieGachaProgressMax, progress));
};

::$bvvar{namespace}.setValkyrieGachaProgress <- function( _progress )
{
	local progress = ::Math.max(0, ::Math.min(::$bvvar{namespace}.ValkyrieGachaProgressMax, _progress));
	return ::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaProgressFlag, progress);
};

::$bvvar{namespace}.getValkyrieGachaGuaranteeCount <- function()
{
	local count = ::$bvvar{namespace}.getGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaGuaranteeCountFlag, 0);
	return ::Math.max(0, count);
};

::$bvvar{namespace}.setValkyrieGachaGuaranteeCount <- function( _count )
{
	return ::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaGuaranteeCountFlag, ::Math.max(0, _count));
};

::$bvvar{namespace}.getSelectedGachaValkyrieID <- function()
{
	local selected = ::$bvvar{namespace}.getGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedValkyrieIDFlag, "");
	local template = ::$bvvar{namespace}.getValkyrieByID(selected);
	if (template != null && "ChapterRecruitOnly" in template && template.ChapterRecruitOnly) return "";
	return selected == false || selected == null ? "" : selected;
};

::$bvvar{namespace}.getSelectedGachaSkinID <- function()
{
	local selected = ::$bvvar{namespace}.getGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedSkinIDFlag, "");
	return selected == false || selected == null ? "" : selected;
};

::$bvvar{namespace}.clearSelectedGachaValkyrie <- function()
{
	local clearedValkyrie = ::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedValkyrieIDFlag, "");
	local clearedSkin = ::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedSkinIDFlag, "");
	return clearedValkyrie && clearedSkin;
};

::$bvvar{namespace}.getSelectedGachaValkyrieName <- function()
{
	local selected = ::$bvvar{namespace}.getSelectedGachaValkyrieID();
	local template = ::$bvvar{namespace}.getValkyrieByID(selected);

	if (template == null || ::$bvvar{namespace}.findValkyrieInRoster(selected) != null)
	{
		return "";
	}

	local skinID = ::$bvvar{namespace}.getSelectedGachaSkinID();
	local defaultSkinID = ::$bvvar{namespace}.getValkyrieDefaultSkinID(template);
	return skinID != "" && skinID != defaultSkinID && ::$bvvar{namespace}.isValkyrieSkinAllowed(template, skinID)
		? template.Name + " - " + ::$bvvar{namespace}.getValkyrieSkinTabName(template, skinID)
		: template.Name;
};

::$bvvar{namespace}.selectGachaValkyrie <- function( _valkyrieID, _skinID = null )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);
	if (template != null && "ChapterRecruitOnly" in template && template.ChapterRecruitOnly)
		return ::$bvvar{namespace}.createValkyrieResult(false, ::$bvvar{namespace}.getValkyrieChapterRecruitHint(template), "chapter_only");

	if (template == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.invalid_selection}", "invalid_selection");
	}

	if (::$bvvar{namespace}.findValkyrieInRoster(_valkyrieID) != null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.already_owned}", "already_owned");
	}

	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);
	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(template, skinID)) return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{chapter.skin.locked}", "locked_skin");
	if (skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.invalid_selection}", "invalid_skin");
	}

	::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedValkyrieIDFlag, template.ID);
	::$bvvar{namespace}.setGachaWorldFlag(::$bvvar{namespace}.ValkyrieGachaSelectedSkinIDFlag, skinID);
	return ::$bvvar{namespace}.createValkyrieResult(true, "$bv{ui.hub.gacha.select.success_prefix}" + template.Name + "$bv{ui.hub.gacha.select.success_suffix}", "success");
};

::$bvvar{namespace}.getValkyrieGachaCost <- function()
{
	local guarantees = ::$bvvar{namespace}.getValkyrieGachaGuaranteeCount();

	foreach( step in ::$bvvar{namespace}.ValkyrieGachaCostSteps )
	{
		if (guarantees <= step.MaxGuarantees)
		{
			return step.Cost;
		}
	}

	return ::$bvvar{namespace}.ValkyrieGachaCostSteps[::$bvvar{namespace}.ValkyrieGachaCostSteps.len() - 1].Cost;
};

::$bvvar{namespace}.getAvailableGachaValkyrieIDs <- function()
{
	local ret = [];

	foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieOrder )
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
		if (template != null && !("ChapterRecruitOnly" in template && template.ChapterRecruitOnly) && ::$bvvar{namespace}.findValkyrieInRoster(valkyrieID) == null)
		{
			ret.push(valkyrieID);
		}
	}

	return ret;
};
::$bvvar{namespace}.pickRandomGachaValkyrieID <- function()
{
	local available = ::$bvvar{namespace}.getAvailableGachaValkyrieIDs();

	if (available.len() == 0)
	{
		return null;
	}

	return available[::Math.rand(0, available.len() - 1)];
};

::$bvvar{namespace}.ValkyrieDetailSkillOverrides <- {
	silver_wolf = {
		Passive = {
			Icon = "silver_wolf_weakness_implant",
			Name = "$bv{skill.silver_wolf_aether_editing.name}",
			Description = "$bv{skill.silver_wolf_aether_editing.description}",
			Tooltip = [{ SkillKey = "silver_wolf_aether_editing", Text = "$bv{skill.silver_wolf_aether_editing.tooltip.shared}" }]
		},
		Active = {
			Icon = "skills/active_01.png",
			Name = "$bv{skill.silver_wolf_attack_vulnerability.name}",
			Description = "$bv{skill.silver_wolf_attack_vulnerability.description}\n\n$bv{skill.silver_wolf_defense_vulnerability.description}\n\n$bv{skill.silver_wolf_speed_vulnerability.description}",
			Tooltip = [
				{ SkillKey = "silver_wolf_attack_vulnerability", Text = "$bv{skill.silver_wolf_attack_vulnerability.tooltip.skill}" },
				{ SkillKey = "silver_wolf_attack_vulnerability", Text = "$bv{skill.silver_wolf_attack_vulnerability.tooltip.duration}" },
				{ SkillKey = "silver_wolf_defense_vulnerability", Text = "$bv{skill.silver_wolf_defense_vulnerability.tooltip.defense}" },
				{ SkillKey = "silver_wolf_defense_vulnerability", Text = "$bv{skill.silver_wolf_defense_vulnerability.tooltip.duration}" },
				{ SkillKey = "silver_wolf_speed_vulnerability", Text = "$bv{skill.silver_wolf_speed_vulnerability.tooltip.stun}" },
				{ SkillKey = "silver_wolf_speed_vulnerability", Text = "$bv{skill.silver_wolf_speed_vulnerability.tooltip.immune}" },
				{ SkillKey = "silver_wolf_attack_vulnerability", Text = "$bv{skill.silver_wolf_attack_vulnerability.tooltip.used}" }
			]
		}
	},
	jeanne_alter = {
		Passive = {
			Icon = "jeanne_alter_dragon_witch",
			Name = "$bv{skill.jeanne_alter_dragon_witch.name}",
			Description = "$bv{skill.jeanne_alter_dragon_witch.description}",
			Tooltip = [{ SkillKey = "jeanne_alter_dragon_witch", Text = "$bv{skill.jeanne_alter_dragon_witch.tooltip.hunt}" }, { SkillKey = "jeanne_alter_dragon_witch", Text = "$bv{skill.jeanne_alter_dragon_witch.tooltip.damage}" }]
		},
		Active = {
			Icon = "jeanne_alter_la_grondement_du_haine",
			Name = "$bv{skill.jeanne_alter_la_grondement_du_haine.name}",
			Description = "$bv{skill.jeanne_alter_la_grondement_du_haine.description}",
			Tooltip = [{ SkillKey = "jeanne_alter_la_grondement_du_haine", Text = "$bv{skill.jeanne_alter_la_grondement_du_haine.tooltip.attack}" }, { SkillKey = "jeanne_alter_la_grondement_du_haine", Text = "$bv{skill.jeanne_alter_la_grondement_du_haine.tooltip.curse}" }]
		}
	},
	jingliu = {
		Passive = {
			Icon = "jingliu_cold_moon_sword_heart",
			Name = "$bv{skill.jingliu_cold_moon_sword_heart.name}",
			Description = "$bv{skill.jingliu_cold_moon_sword_heart.description}",
			Tooltip = [
				{ SkillKey = "jingliu_cold_moon_sword_heart", Text = "$bv{skill.jingliu_cold_moon_sword_heart.tooltip.stack}" },
				{ SkillKey = "jingliu_cold_moon_sword_heart", Text = "$bv{skill.jingliu_cold_moon_sword_heart.tooltip.full}" }
			]
		},
		Active = {
			Icon = "jingliu_moonflower_birth_and_death",
			Name = "$bv{skill.jingliu_moonflower_birth_and_death.name}",
			Description = "$bv{skill.jingliu_moonflower_birth_and_death.description}",
			Tooltip = [
				{ SkillKey = "jingliu_moonflower_birth_and_death", Text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.cost}" },
				{ SkillKey = "jingliu_moonflower_birth_and_death", Text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.hit}" },
				{ SkillKey = "jingliu_moonflower_birth_and_death", Text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.damage}" },
				{ SkillKey = "jingliu_moonflower_birth_and_death", Text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.direct}" },
				{ SkillKey = "jingliu_moonflower_birth_and_death", Text = "$bv{skill.jingliu_moonflower_birth_and_death.tooltip.ap}" }
			]
		}
	},
	skirk = {
		Passive = {
			Icon = "skirk_abyss_swordsmanship",
			Name = "$bv{skill.skirk_serpents_subtlety.name}",
			Description = "$bv{skill.skirk_serpents_subtlety.description}",
			Tooltip = [
				{ SkillKey = "skirk_serpents_subtlety", Text = "$bv{skill.skirk_serpents_subtlety.tooltip.start}" },
				{ SkillKey = "skirk_serpents_subtlety", Text = "$bv{skill.skirk_serpents_subtlety.tooltip.gain}" },
				{ SkillKey = "skirk_serpents_subtlety", Text = "$bv{skill.skirk_serpents_subtlety.tooltip.shield}" }
			]
		},
		Active = {
			Icon = "skirk_abyssal_flash",
			Name = "$bv{skill.skirk_havoc_warp.name}",
			Description = "$bv{skill.skirk_havoc_warp.description}",
			Tooltip = [
				{ SkillKey = "skirk_havoc_warp", Text = "$bv{skill.skirk_havoc_warp.tooltip.phase}" },
				{ SkillKey = "skirk_havoc_ruin", Text = "$bv{skill.skirk_havoc_ruin.tooltip.damage}" },
				{ SkillKey = "skirk_havoc_ruin", Text = "$bv{skill.skirk_havoc_ruin.tooltip.resource}" }
			]
		}
	},
	tilixibiesi = {
		Passive = {
			Icon = "tilixibiesi_underworld_coordinates",
			Name = "$bv{skill.tilixibiesi_underworld_coordinates.name}",
			Description = "$bv{skill.tilixibiesi_underworld_coordinates.description}",
			Tooltip = [
				{ SkillKey = "tilixibiesi_underworld_coordinates", Text = "$bv{skill.tilixibiesi_underworld_coordinates.tooltip.initiative}" }
			]
		},
		Active = {
			Icon = "tilixibiesi_beyond_warp",
			Name = "$bv{skill.tilixibiesi_beyond_warp.name}",
			Description = "$bv{skill.tilixibiesi_beyond_warp.description}",
			Tooltip = [
				{ SkillKey = "tilixibiesi_beyond_warp", Text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_prefix}" + 4 + "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_middle}" + 5 + "$bv{skill.tilixibiesi_beyond_warp.tooltip.cost_suffix}" },
				{ SkillKey = "tilixibiesi_beyond_warp", Text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.hp}" },
				{ SkillKey = "tilixibiesi_beyond_warp", Text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.target}" },
				{ SkillKey = "tilixibiesi_beyond_warp", Text = "$bv{skill.tilixibiesi_beyond_warp.tooltip.destination}" }
			]
		}
	},
	fengjin = {
		Passive = {
			Icon = "fengjin_healing_breeze",
			Name = "$bv{skill.fengjin_tailwind_rhythm.name}",
			Description = "$bv{skill.fengjin_tailwind_rhythm.description}",
			Tooltip = [
				{ SkillKey = "fengjin_tailwind_rhythm", Text = "$bv{skill.fengjin_tailwind_rhythm.tooltip.initiative}" }
			]
		},
		Active = {
			Icon = "fengjin_healing_breeze",
			Name = "$bv{skill.fengjin_feather_rescue.name}" + " / " + "$bv{skill.fengjin_icarus_impact.name}",
			Description = "$bv{skill.fengjin_feather_rescue.description}" + "\n" + "$bv{skill.fengjin_icarus_impact.description}",
			Tooltip = [
				{ SkillKey = "fengjin_feather_rescue", Text = "$bv{skill.fengjin_feather_rescue.name}" + ": " + "$bv{skill.fengjin_feather_rescue.tooltip.cost}" },
				{ SkillKey = "fengjin_feather_rescue", Text = "$bv{skill.fengjin_feather_rescue.tooltip.heal}" },
				{ SkillKey = "fengjin_feather_rescue", Text = "$bv{skill.fengjin_feather_rescue.tooltip.cleanse}" },
				{ SkillKey = "fengjin_icarus_impact", Text = "$bv{skill.fengjin_icarus_impact.name}" + ": " + "$bv{skill.fengjin_icarus_impact.tooltip.cost}" },
				{ SkillKey = "fengjin_icarus_impact", Text = "$bv{skill.fengjin_icarus_impact.tooltip.armor}" }
			]
		}
	},
	castorice = {
		Passive = {
			Icon = "castorice_newbud",
			Name = "$bv{skill.castorice_newbud.name}",
			Description = "$bv{skill.castorice_newbud.description}",
			Tooltip = [
				{ SkillKey = "castorice_newbud", Text = "$bv{skill.castorice_newbud.tooltip.health}" },
				{ SkillKey = "castorice_newbud", Text = "$bv{skill.castorice_newbud.tooltip.full}" }
			]
		},
		Active = {
			Icon = "castorice_cocoon_drain",
			Name = "$bv{skill.castorice_cocoon_drain.name}" + " / " + "$bv{skill.castorice_netherwing_descent.name}",
			Description = "$bv{skill.castorice_cocoon_drain.description}" + "\n" + "$bv{skill.castorice_netherwing_descent.description}",
			Tooltip = [
				{ SkillKey = "castorice_cocoon_drain", Text = "$bv{skill.castorice_cocoon_drain.name}" + ": " + "$bv{skill.castorice_cocoon_drain.tooltip.cost}" },
				{ SkillKey = "castorice_cocoon_drain", Text = "$bv{skill.castorice_cocoon_drain.tooltip.armor}" },
				{ SkillKey = "castorice_cocoon_drain", Text = "$bv{skill.castorice_cocoon_drain.tooltip.hp}" },
				{ SkillKey = "castorice_cocoon_drain", Text = "$bv{skill.castorice_cocoon_drain.tooltip.newbud}" },
				{ SkillKey = "castorice_netherwing_descent", Text = "$bv{skill.castorice_netherwing_descent.name}" + ": " + "$bv{skill.castorice_netherwing_descent.tooltip.cost}" },
				{ SkillKey = "castorice_netherwing_descent", Text = "$bv{skill.castorice_netherwing_descent.tooltip.main}" },
				{ SkillKey = "castorice_netherwing_descent", Text = "$bv{skill.castorice_netherwing_descent.tooltip.secondary}" },
				{ SkillKey = "castorice_netherwing_descent", Text = "$bv{skill.castorice_netherwing_descent.tooltip.heal}" }
			]
		}
	},
	changyeyue = {
		Passive = {
			Icon = "changyeyue_moonbound_crystal_thread",
			Name = "$bv{skill.changyeyue_long_night.name}",
			Description = "$bv{skill.changyeyue_long_night.description}",
			Tooltip = [
				{ SkillKey = "changyeyue_long_night", Text = "$bv{skill.changyeyue_long_night.tooltip.gain}" },
				{ SkillKey = "changyeyue_long_night", Text = "$bv{skill.changyeyue_long_night.tooltip.oblivion}" }
			]
		},
		Active = {
			Icon = "changyeyue_darkest_riddle",
			Name = "$bv{skill.changyeyue_darkest_riddle.name}",
			Description = "$bv{skill.changyeyue_darkest_riddle.description}",
			Tooltip = [
				{ SkillKey = "changyeyue_darkest_riddle", Text = "$bv{skill.changyeyue_darkest_riddle.tooltip.cost}" },
				{ SkillKey = "changyeyue_darkest_riddle", Text = "$bv{skill.changyeyue_darkest_riddle.tooltip.main}" },
				{ SkillKey = "changyeyue_darkest_riddle", Text = "$bv{skill.changyeyue_darkest_riddle.tooltip.secondary}" },
				{ SkillKey = "changyeyue_darkest_riddle", Text = "$bv{skill.changyeyue_darkest_riddle.tooltip.effects}" },
				{ SkillKey = "changyeyue_darkest_riddle", Text = "$bv{skill.changyeyue_darkest_riddle.tooltip.not_ready}" }
			]
		}
	},
	hysilens = {
		Passive = {
			Icon = "hysilens_crystal_tide",
			Name = "$bv{skill.hysilens_tidal_erosion.name}",
			Description = "$bv{skill.hysilens_tidal_erosion.description}",
			Tooltip = [
				{ SkillKey = "hysilens_tidal_erosion", Text = "$bv{skill.hysilens_tidal_erosion.tooltip.apply}" },
				{ SkillKey = "hysilens_tidal_erosion", Text = "$bv{skill.hysilens_tidal_erosion.tooltip.damage}" }
			]
		},
		Active = {
			Icon = "hysilens_crystal_tide",
			Name = "$bv{skill.hysilens_crystal_tide.name}",
			Description = "$bv{skill.hysilens_crystal_tide.description}",
			Tooltip = [
				{ SkillKey = "hysilens_crystal_tide", Text = "$bv{skill.hysilens_crystal_tide.tooltip.cost}" },
				{ SkillKey = "hysilens_crystal_tide", Text = "$bv{skill.hysilens_crystal_tide.tooltip.area}" },
				{ SkillKey = "hysilens_crystal_tide", Text = "$bv{skill.hysilens_crystal_tide.tooltip.spent}" }
			]
		}
	},
	cipher = {
		Passive = {
			Icon = "cipher_lucky_paw",
			Name = "$bv{skill.cipher_old_patron.name}",
			Description = "$bv{skill.cipher_old_patron.description}",
			Tooltip = [
				{ SkillKey = "cipher_old_patron", Text = "$bv{skill.cipher_old_patron.tooltip.mark}" },
				{ SkillKey = "cipher_old_patron", Text = "$bv{skill.cipher_old_patron.tooltip.kickback}" },
				{ SkillKey = "cipher_old_patron", Text = "$bv{skill.cipher_old_patron.tooltip.damage}" },
				{ SkillKey = "cipher_old_patron", Text = "$bv{skill.cipher_old_patron.tooltip.kill}" }
			]
		},
		Active = {
			Icon = "cipher_lucky_paw",
			Name = "$bv{skill.cipher_name_your_price.name}" + " / " + "$bv{skill.cipher_moonlit_heist.name}",
			Description = "$bv{skill.cipher_name_your_price.description}" + "\n" + "$bv{skill.cipher_moonlit_heist.description}",
			Tooltip = [
				{ SkillKey = "cipher_name_your_price", Text = "$bv{skill.cipher_name_your_price.name}" + ": " + "$bv{skill.cipher_name_your_price.tooltip.cost}" },
				{ SkillKey = "cipher_name_your_price", Text = "$bv{skill.cipher_name_your_price.tooltip.target}" },
				{ SkillKey = "cipher_moonlit_heist", Text = "$bv{skill.cipher_moonlit_heist.name}" + ": " + "$bv{skill.cipher_moonlit_heist.tooltip.cost}" },
				{ SkillKey = "cipher_moonlit_heist", Text = "$bv{skill.cipher_moonlit_heist.tooltip.target}" },
				{ SkillKey = "cipher_moonlit_heist", Text = "$bv{skill.cipher_moonlit_heist.tooltip.spent}" }
			]
		}
	},
	cerydra = {
		Passive = {
			Icon = "cerydra_royal_edict",
			Name = "$bv{skill.cerydra_war_banner.name}",
			Description = "$bv{skill.cerydra_war_banner.description}",
			Tooltip = [
				{ SkillKey = "cerydra_war_banner", Text = "$bv{skill.cerydra_war_banner.tooltip.aura_prefix}" + "4" + "$bv{skill.cerydra_war_banner.tooltip.aura_suffix}" },
				{ SkillKey = "cerydra_war_banner", Text = "$bv{skill.cerydra_war_banner.tooltip.merit}" }
			]
		},
		Active = {
			Icon = "cerydra_royal_edict",
			Name = "$bv{skill.cerydra_promote_pawn.name}" + " / " + "$bv{skill.cerydra_checkmate_command.name}",
			Description = "$bv{skill.cerydra_promote_pawn.description}" + "\n" + "$bv{skill.cerydra_checkmate_command.description}",
			Tooltip = [
				{ SkillKey = "cerydra_promote_pawn", Text = "$bv{skill.cerydra_promote_pawn.name}" + ": " + "$bv{skill.cerydra_promote_pawn.tooltip.target}" },
				{ SkillKey = "cerydra_promote_pawn", Text = "$bv{skill.cerydra_promote_pawn.tooltip.merit}" },
				{ SkillKey = "cerydra_checkmate_command", Text = "$bv{skill.cerydra_checkmate_command.name}" + ": " + "$bv{skill.cerydra_checkmate_command.tooltip.turn}" },
				{ SkillKey = "cerydra_checkmate_command", Text = "$bv{skill.cerydra_checkmate_command.tooltip.bonus}" },
				{ SkillKey = "cerydra_checkmate_command", Text = "$bv{skill.cerydra_checkmate_command.tooltip.no_edict}" }
			]
		}
	},
	aglaea = {
		Passive = {
			Icon = "aglaea_seam_stitch",
			Name = "$bv{skill.aglaea_seam_stitch.name}",
			Description = "$bv{skill.aglaea_seam_stitch.description}",
			Tooltip = [
				{ SkillKey = "aglaea_seam_stitch", Text = "$bv{skill.aglaea_seam_stitch.tooltip.mark}" },
				{ SkillKey = "aglaea_seam_stitch", Text = "$bv{skill.aglaea_seam_stitch.tooltip.damage}" },
				{ SkillKey = "aglaea_seam_stitch", Text = "$bv{skill.aglaea_seam_stitch.tooltip.ap}" },
				{ SkillKey = "aglaea_seam_stitch", Text = "$bv{skill.aglaea_seam_stitch.tooltip.kill}" },
				{ SkillKey = "aglaea_seam_stitch", Text = "$bv{skill.aglaea_seam_stitch.tooltip.supreme}" }
			]
		},
		Active = {
			Icon = "aglaea_destined_weaving_dance",
			Name = "$bv{skill.aglaea_destined_weaving_dance.name}",
			Description = "$bv{skill.aglaea_destined_weaving_dance.description}",
			Tooltip = [
				{ SkillKey = "aglaea_destined_weaving_dance", Text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.cost}" },
				{ SkillKey = "aglaea_destined_weaving_dance", Text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.target}" },
				{ SkillKey = "aglaea_destined_weaving_dance", Text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.area}" },
				{ SkillKey = "aglaea_destined_weaving_dance", Text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.no_friendly_fire}" },
				{ SkillKey = "aglaea_destined_weaving_dance", Text = "$bv{skill.aglaea_destined_weaving_dance.tooltip.stance}" }
			]
		}
	},
	scarlet_shadow = {
		Passive = {
			Icon = "scarlet_shadow_flower_shadow_trinity",
			Name = "$bv{skill.scarlet_shadow_flyflower.name}",
			Description = "$bv{skill.scarlet_shadow_flyflower.description}",
			Tooltip = [
				{ SkillKey = "scarlet_shadow_flyflower", Text = "$bv{skill.scarlet_shadow_flyflower.tooltip.layers}" },
				{ SkillKey = "scarlet_shadow_flyflower", Text = "$bv{skill.scarlet_shadow_flyflower.tooltip.stages}" }
			]
		},
		Active = {
			Icon = "scarlet_shadow_flower_shadow_trinity",
			Name = "$bv{skill.scarlet_shadow_flower_shadow_trinity.name}",
			Description = "$bv{skill.scarlet_shadow_flower_shadow_trinity.description}",
			Tooltip = [
				{ SkillKey = "scarlet_shadow_flower_shadow_trinity", Text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.free}" },
				{ SkillKey = "scarlet_shadow_flower_shadow_trinity", Text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage2}" },
				{ SkillKey = "scarlet_shadow_flower_shadow_trinity", Text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage4}" },
				{ SkillKey = "scarlet_shadow_flower_shadow_trinity", Text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage6}" },
				{ SkillKey = "scarlet_shadow_fading_blossom", Text = "$bv{skill.scarlet_shadow_fading_blossom.name}" + ": " + "$bv{skill.scarlet_shadow_fading_blossom.tooltip.ready}" }
			]
		}
	}
};

::$bvvar{namespace}.makeValkyrieDetailSkillEntry <- function( _label, _skillSpec )
{
	if (_skillSpec == null)
	{
		return null;
	}

	local description = _skillSpec.Description;

	local tooltip = "Tooltip" in _skillSpec ? _skillSpec.Tooltip : (("Spec" in _skillSpec && "Tooltip" in _skillSpec.Spec) ? _skillSpec.Spec.Tooltip : null);

	if (tooltip != null)
	{
		foreach( row in tooltip )
		{
			if ("Text" in row)
			{
				description = description + "\n" + row.Text;
			}
		}
	}

	return {
		Label = _label,
		Icon = ::$bvvar{namespace}.getValkyrieSkillIconPath(_skillSpec, false),
		Name = _skillSpec.Name,
		Description = description
	};
};

::$bvvar{namespace}.getValkyrieDetailSkills <- function( _template )
{
	if ("HubDetails" in _template)
	{
		return {
			Passive = "Passive" in _template.HubDetails ? _template.HubDetails.Passive : null,
			Active = "Active" in _template.HubDetails ? _template.HubDetails.Active : null
		};
	}

	if (_template.ID in ::$bvvar{namespace}.ValkyrieDetailSkillOverrides)
	{
		local override = ::$bvvar{namespace}.ValkyrieDetailSkillOverrides[_template.ID];

		return {
			Passive = ("Passive" in override) ? override.Passive : null,
			Active = ("Active" in override) ? override.Active : null
		};
	}

	if (!("SkillLoadout" in _template))
	{
		return null;
	}

	local passive = null;
	local active = null;

	foreach( key in _template.SkillLoadout )
	{
		local definition = ::$bvvar{namespace}.getSkillDefinition(key);

		if (definition == null)
		{
			continue;
		}

		if (passive == null && definition.Kind == "passive")
		{
			passive = definition;
		}
		else if (active == null && definition.Kind == "active")
		{
			active = definition;
		}
	}

	return {
		Passive = passive,
		Active = active
	};
};

// Each loadout skill owns a separate entry. Legacy summaries remain available
// to older consumers; only explicitly keyed supplemental rows are reused here.
::$bvvar{namespace}.getValkyrieDetailSkillEntries <- function( _template, _summaries = null )
{
	local entries = [];
	local seen = {};
	if (!("SkillLoadout" in _template)) return entries;
	foreach( key in _template.SkillLoadout )
	{
		if (key in seen) continue;
		local definition = ::$bvvar{namespace}.getSkillDefinition(key);
		if (definition == null || (definition.Kind != "passive" && definition.Kind != "active")) continue;
		seen[key] <- true;
		local label = definition.Kind == "passive" ? "$bv{ui.hub.detail.passive_skill}" : "$bv{ui.hub.detail.active_skill}";
		local entry = ::$bvvar{namespace}.makeValkyrieDetailSkillEntry(label, definition);
		entry.Key <- key;
		entry.Kind <- definition.Kind;
		if (_summaries != null)
		{
			foreach( summary in [_summaries.Passive, _summaries.Active] )
			{
				if (summary == null || !("Tooltip" in summary)) continue;
				foreach( row in summary.Tooltip )
				{
					if ("SkillKey" in row && row.SkillKey == key && "Text" in row && entry.Description.find(row.Text) == null)
						entry.Description += "\n" + row.Text;
				}
			}
		}
		entries.push(entry);
	}
	return entries;
};

::$bvvar{namespace}.getValkyrieDetailImagePath <- function( _path )
{
	if (_path == null || typeof _path != "string")
	{
		return "";
	}

	return _path.len() > 4 && _path.slice(0, 4) == "gfx/" ? _path.slice(4) : _path;
};

::$bvvar{namespace}.ValkyrieNarrativeDetails <- {
	rachel_alucard = { StagesKey="RachelBondStages",TraitKey="RachelBondTraitID",Description="$bv{valkyrie.rachel_alucard.bond.description}" },
	jeanne = { StagesKey = "JeanneBondStages", TraitKey = "JeanneBondTraitID", Description = "$bv{valkyrie.jeanne.bond.trait.description}" },
	xilian = { StagesKey = "XilianBondStages", TraitKey = "XilianBondTraitID", Description = "$bv{valkyrie.xilian.bond.trait.description}" },
	liuying = { StagesKey = "LiuyingBondStages", TraitKey = "LiuyingBondTraitID", Description = "$bv{valkyrie.liuying.bond.trait.description}" },
	himeko = { StagesKey = "HimekoBondStages", TraitKey = "HimekoBondTraitID", Description = "$bv{valkyrie.himeko.bond.trait.description}" },
	hu_tao = { StagesKey="HuTaoBondStages",TraitKey="HuTaoBondTraitID",Description="$bv{valkyrie.hu_tao.bond.description}" },
	es = { StagesKey="EsBondStages",TraitKey="EsBondTraitID",Description="$bv{valkyrie.es.bond.description}" },
	kanade_tachibana = { StagesKey = "KanadeBondStages", TraitKey = "KanadeBondTraitID", Description = "$bv{valkyrie.kanade_tachibana.bond.description}" },
	the_herta = { StagesKey = "HertaBondStages", TraitKey = "HertaBondTraitID", Description = "$bv{valkyrie.the_herta.bond.description}" },
	saber = { StagesKey = "SaberBondStages", TraitKey = "SaberBondTraitID", Description = "$bv{valkyrie.saber.bond.description}" },
	ye_shunguang = { StagesKey = "YeShunguangBondStages", TraitKey = "YeShunguangBondTraitID", Description = "$bv{valkyrie.ye_shunguang.bond.description}" },
	olga = { Type = "corruption", StagesKey = "OlgaCorruptionStages", TraitKey = "OlgaCorruptionTraitID", Description = "$bv{olga.corruption.description}" }
};

::$bvvar{namespace}.getValkyrieNarrativeDetail <- function( _template, _actor = null )
{
	local result = {
		Bond = null,
		Stories = []
	};

	// Identity comes from the selected template; progress stays on its persistent trait.
	local bv = ::$bvvar{namespace};
	if (_template == null || !(_template.ID in bv.ValkyrieNarrativeDetails))
	{
		return result;
	}
	local definition = bv.ValkyrieNarrativeDetails[_template.ID];
	local narrativeType = "Type" in definition ? definition.Type : "bond";
	if (!(definition.StagesKey in bv) || bv[definition.StagesKey].len() == 0) return result;

	local trait = null;
	if (_actor != null && definition.TraitKey in bv)
	{
		try
		{
			trait = _actor.getSkills().getSkillByID(bv[definition.TraitKey]);
		}
		catch (e)
		{
			trait = null;
		}
	}

	local bond = trait == null ? 0 : trait.getBond();
	local currentStageValue = 0;
	local activeStageValue = 0;
	local completedCount = 0;
	local unlockedStoryCount = 0;
	local stages = [];

	foreach( stage in bv[definition.StagesKey] )
	{
		local state = "locked";
		if (trait != null)
		{
			if (trait.hasTriggeredStage(stage.Value))
			{
				state = "completed";
				currentStageValue = stage.Value;
				completedCount = completedCount + 1;
			}
			else if (trait.hasChallengeSpawnedStage(stage.Value))
			{
				state = "challenge";
				activeStageValue = stage.Value;
			}
			else if (trait.hasPendingStageValue(stage.Value))
			{
				state = "story_pending";
				activeStageValue = stage.Value;
			}
		}

		local storyUnlocked = state == "challenge" || state == "completed";
		if (storyUnlocked)
		{
			unlockedStoryCount = unlockedStoryCount + 1;
		}

		local stageDTO = {
			Value = stage.Value,
			Name = stage.Name,
			Title = stage.Title,
			State = state,
			Reward = "ChallengeText" in stage ? stage.ChallengeText : ("RewardText" in stage ? stage.RewardText : ""),
			IntroImage = narrativeType == "corruption" && !storyUnlocked ? "" : ::$bvvar{namespace}.getValkyrieDetailImagePath(stage.Image),
			CGImage = narrativeType == "corruption" && !storyUnlocked ? "" : ::$bvvar{namespace}.getValkyrieDetailImagePath(stage.CGImage)
		};
		stages.push(stageDTO);
		result.Stories.push({
			ID = _template.ID + "_" + narrativeType + "_" + stage.Value,
			Type = narrativeType,
			Stage = stage.Value,
			Chapter = stage.Name,
			Title = stage.Title,
			IntroImage = stageDTO.IntroImage,
			CGImage = stageDTO.CGImage,
			IntroText = narrativeType == "corruption" && !storyUnlocked ? "" : stage.Text,
			RevealText = narrativeType == "corruption" && !storyUnlocked ? "" : stage.RevealText,
			Unlocked = storyUnlocked
		});
	}

	if (activeStageValue == 0)
	{
		activeStageValue = currentStageValue;
	}
	if (activeStageValue == 0 && stages.len() != 0)
	{
		activeStageValue = stages[0].Value;
	}

	result.Bond = {
		Type = narrativeType,
		Available = trait != null,
		Value = bond,
		Max = 100,
		CurrentStageValue = currentStageValue,
		ActiveStageValue = activeStageValue,
		CompletedCount = completedCount,
		UnlockedStoryCount = unlockedStoryCount,
		Description = definition.Description,
		Stages = stages
	};
	return result;
};

::$bvvar{namespace}.getValkyrieSummonDetail <- function( _template, _actor = null )
{
	if (_template == null)
	{
		return null;
	}

	local skills = ::$bvvar{namespace}.getValkyrieDetailSkills(_template);
	local skins = [];
	local defaultSkinID = ::$bvvar{namespace}.getValkyrieDefaultSkinID(_template);
	local activeSkinID = _actor == null ? defaultSkinID : ::$bvvar{namespace}.getActorValkyrieSkinID(_actor);
	local worldLeaderID = ::$bvvar{namespace}.getWorldPartyLeaderValkyrieID();
	local worldLeaderSkinID = ::$bvvar{namespace}.getWorldPartyLeaderSkinID();
	local narrative = ::$bvvar{namespace}.getValkyrieNarrativeDetail(_template, _actor);

	foreach( skinID in ::$bvvar{namespace}.getValkyrieSkinIDs(_template) )
	{
		local skin = ::$bvvar{namespace}.getSkin(skinID);
		if (skin == null)
		{
			continue;
		}

		local locked = !::$bvvar{namespace}.isValkyrieSkinUnlocked(_template, skin.ID, _actor);
		local hideStageArt = locked && ("UnlockOlgaStage" in skin || "UnlockBlackBeastStage" in skin);
		skins.push({
			ID = skin.ID,
			Locked = locked,
			UnlockHint = "UnlockHertaBond" in skin ? "$bv{skin.the_herta_starlit_vows_skin.locked}" : "UnlockKanadeBond" in skin ? "$bv{kanade.skin.locked}" : "UnlockSaberBond" in skin ? "$bv{skin.saber_royal_bunny_skin.locked}" : "UnlockBlackBeastStage" in skin ? "$bv{black_beast.stage.locked}" : ("UnlockOlgaStage" in skin ? "$bv{olga.skin.locked}" : ("UnlockChapter" in skin ? "$bv{chapter.skin.locked}" : "")),
			Name = ::$bvvar{namespace}.getValkyrieSkinTabName(_template, skin.ID),
			Description = "Description" in skin && skin.Description != "" ? skin.Description : "$bv{ui.hub.skin_description.original}",
			SummonPortrait = hideStageArt ? "" : ::$bvvar{namespace}.getValkyrieSkinPortraitPath(_template, skin.ID),
			SkinPortrait = hideStageArt ? "" : ::$bvvar{namespace}.getValkyrieSkinPreviewPath(_template, skin.ID),
			DetailMedia = !hideStageArt && "DetailMedia" in skin && typeof skin.DetailMedia == "table" ? clone skin.DetailMedia : null,
			IsOriginal = skin.ID == defaultSkinID,
			IsActive = skin.ID == activeSkinID,
			CanSetWorldLeader = ::$bvvar{namespace}.getValkyrieWorldLeaderBrush(_template, skin.ID) != null,
			IsWorldLeader = worldLeaderID == _template.ID && worldLeaderSkinID == skin.ID
		});
	}

	if (skins.len() == 0)
	{
		return null;
	}

	if (!::$bvvar{namespace}.isValkyrieSkinAllowed(_template, activeSkinID))
	{
		activeSkinID = skins[0].ID;
	}

	return {
		Title = _template.Name,
		Subtitle = _template.BackgroundName,
		ActiveSkinID = activeSkinID,
		StagePresentation = _template.ID == "olga" && "Olga" in ::$bvvar{namespace} ? ::$bvvar{namespace}.Olga.presentation(_actor) : ("BlackBeastDefinitions" in ::$bvvar{namespace} && _template.ID in ::$bvvar{namespace}.BlackBeastDefinitions ? ::$bvvar{namespace}.BlackBeast.presentation(_actor, _template.ID) : null),
		Skins = skins,
		SummonPortrait = skins[0].SummonPortrait,
		SkinPortrait = skins[0].SkinPortrait,
		Labels = {
			SummonPortrait = "$bv{ui.hub.detail.summon_art}",
			SkinPortrait = "$bv{ui.hub.detail.skin_art}"
		},
		Background = {
			Label = "$bv{ui.hub.detail.background}",
			Icon = "ui/backgrounds/$bvvar{iconPrefix}/valkyrie_background_icon.png",
			Name = _template.BackgroundName,
			Description = _template.BackgroundDescription
		},
		Trait = {
			Label = "$bv{ui.hub.detail.trait}",
			Icon = _template.TraitIcon,
			Name = _template.TraitName,
			Description = _template.TraitDescription
		},
		Skills = ::$bvvar{namespace}.getValkyrieDetailSkillEntries(_template, skills),
		Passive = skills == null ? null : ::$bvvar{namespace}.makeValkyrieDetailSkillEntry("$bv{ui.hub.detail.passive_skill}", skills.Passive),
		Active = skills == null ? null : ::$bvvar{namespace}.makeValkyrieDetailSkillEntry("$bv{ui.hub.detail.active_skill}", skills.Active),
		GoblinHunt = _template.ID != "sword_maiden" ? null : (
			"makeSwordMaidenHuntDTO" in ::$bvvar{namespace}
				? ::$bvvar{namespace}.makeSwordMaidenHuntDTO(_actor)
				: { Points = 0, PendingPoints = 0, DirectKills = 0, AssistConvictions = 0, Rank = 0, RankMax = 12, NextPoints = 25, RankDescription = "$bv{hunt.sword_maiden.rank_bonus}", Breakdown = [], Milestones = [] }
		),
		Bond = narrative.Bond,
		Stories = narrative.Stories,
		Research = _template.ID == "the_herta" && "getTheHertaResearchDTO" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getTheHertaResearchDTO() : null,
		Workshop = "FiveValkyries" in ::$bvvar{namespace} ? ::$bvvar{namespace}.FiveValkyries.dto(_actor, _template.ID) : null,
		Alchemy = _template.ID == "ryza" && "RyzaAlchemy" in ::$bvvar{namespace} ? ::$bvvar{namespace}.RyzaAlchemy.dto() : null,
		LilySpirits = _template.ID == "lily" && "makeLilySpiritDTO" in ::$bvvar{namespace} ? ::$bvvar{namespace}.makeLilySpiritDTO(_actor) : null
	};
};

::$bvvar{namespace}.getValkyrieSummonCombatMax <- function()
{
	if (::World != null && ::World.Assets != null && "getBrothersMaxInCombat" in ::World.Assets)
	{
		try
		{
			local ret = ::World.Assets.getBrothersMaxInCombat();

			if (ret != null && ret > 0)
			{
				return ret;
			}
		}
		catch (e)
		{
		}
	}

	return 12;
};

::$bvvar{namespace}.getValkyrieSummonFormationSlots <- function()
{
	if (::World != null && ::World.Assets != null && "getFormation" in ::World.Assets)
	{
		try
		{
			local formation = ::World.Assets.getFormation();

			if (formation != null && formation.len() > 0)
			{
				return formation.len();
			}
		}
		catch (e)
		{
		}
	}

	return ::$bvvar{namespace}.ValkyrieSummonFormationSlots;
};

::$bvvar{namespace}.getValkyrieSummonCombatSlots <- function()
{
	local formationSlots = ::$bvvar{namespace}.getValkyrieSummonFormationSlots();
	local combatSlots = ::Math.max(::$bvvar{namespace}.ValkyrieSummonCombatSlots, ::$bvvar{namespace}.getValkyrieSummonCombatMax());
	return ::Math.min(formationSlots, combatSlots);
};

::$bvvar{namespace}.getValkyrieSummonReserveSlotStart <- function()
{
	return ::Math.min(::$bvvar{namespace}.getValkyrieSummonFormationSlots(), ::$bvvar{namespace}.getValkyrieSummonCombatSlots());
};

::$bvvar{namespace}.isActorInValkyrieSummonReserve <- function( _actor )
{
	if (_actor == null || !("isInReserves" in _actor))
	{
		return false;
	}

	try
	{
		return _actor.isInReserves();
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.isValkyrieSummonRosterFull <- function()
{
	if (::World == null || ::World.getPlayerRoster() == null)
	{
		return true;
	}

	local max = ::$bvvar{namespace}.getValkyrieEffectiveRosterMax();
	return max <= 0 || ::World.getPlayerRoster().getSize() >= max;
};

::$bvvar{namespace}.findOpenSummonFormationSlot <- function()
{
	if ("Roster" in ::$bvvar{namespace} && ::$bvvar{namespace}.Roster.enabled()) return 255;
	local used = {};
	local active = 0;
	local roster = ::World.getPlayerRoster().getAll();
	local formationSlots = ::$bvvar{namespace}.getValkyrieSummonFormationSlots();
	local combatSlots = ::$bvvar{namespace}.getValkyrieSummonCombatSlots();
	local reserveSlotStart = ::$bvvar{namespace}.getValkyrieSummonReserveSlotStart();

	foreach( bro in roster )
	{
		if (::$bvvar{namespace}.isActorInValkyrieSummonReserve(bro))
		{
			continue;
		}

		local place = bro.getPlaceInFormation();

		if (place >= 0 && place < formationSlots)
		{
			used[place] <- true;

			if (place < combatSlots)
			{
				active = ++active;
			}
		}
	}

	if (active < ::$bvvar{namespace}.getValkyrieSummonCombatMax())
	{
		for( local i = 0; i < combatSlots; i = ++i )
		{
			if (!(i in used))
			{
				return i;
			}
		}
	}

	for( local i = reserveSlotStart; i < formationSlots; i = ++i )
	{
		if (!(i in used))
		{
			return i;
		}
	}

	return ::$bvvar{namespace}.ValkyrieSummonNotInFormation;
};

::$bvvar{namespace}.createValkyrieResult <- function( _success, _message, _code = "" )
{
	return {
		Success = _success,
		Code = _code,
		Message = _message
	};
};

::$bvvar{namespace}.createValkyrieScriptObject <- function( _context, _actor, _script )
{
	if (_actor != null && "new" in _actor)
	{
		return _actor.new(_script);
	}

	if (_context != null && "new" in _context)
	{
		return _context.new(_script);
	}

	if (::World.State != null && "new" in ::World.State)
	{
		return ::World.State.new(_script);
	}

	return ::new(_script);
};

::$bvvar{namespace}.createValkyrieSkinItem <- function( _template, _context = null, _skinID = null )
{
	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(_template, _skinID);
	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(_template, skinID)) return null;

	if (_template == null || skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return null;
	}

	local item = ::$bvvar{namespace}.createValkyrieScriptObject(_context, null, ::$bvvar{namespace}.ValkyrieSkinItemCarrierScript);

	if (item != null && !::$bvvar{namespace}.markValkyrieSkinItem(item, _template.ID, skinID))
	{
		return null;
	}

	return item;
};

::$bvvar{namespace}.addValkyrieAdditionalTraits <- function( _actor, _template, _context = null )
{
	if (_actor == null || _template == null || !("AdditionalTraitScripts" in _template))
	{
		return 0;
	}

	local added = 0;

	foreach( script in _template.AdditionalTraitScripts )
	{
		local trait = ::$bvvar{namespace}.createValkyrieScriptObject(_context, _actor, script);

		if (trait == null)
		{
			throw "Failed to create Valkyrie additional trait: " + script;
		}

		_actor.getSkills().add(trait);
		added = ++added;
	}

	return added;
};

::$bvvar{namespace}.addValkyrieSkinTraitIfMissing <- function( _actor, _template, _context = null, _skinID = null )
{
	if (_actor == null || _template == null || !("ID" in _template))
	{
		return 0;
	}

	if (::$bvvar{namespace}.getActorValkyrieSkinTrait(_actor) != null)
	{
		return 0;
	}

	local skinID = _skinID;
	if (skinID == null || skinID == "")
	{
		skinID = ::$bvvar{namespace}.getActorFlagString(_actor, ::$bvvar{namespace}.ValkyrieSkinIDFlag);
	}
	local resolvedSkinID = ::$bvvar{namespace}.resolveValkyrieSkinID(_template, skinID);
	local trait = ::$bvvar{namespace}.createValkyrieSkinTrait(_context, _actor, _template, resolvedSkinID);

	if (trait == null)
	{
		return 0;
	}

	if (_actor.getSkills().hasSkill(trait.getID()))
	{
		return 0;
	}

	_actor.getSkills().add(trait);
	return 1;
};

::$bvvar{namespace}.createValkyrieRosterActor <- function( _valkyrieID, _context, _options = null )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null || ::World == null || ::World.getPlayerRoster() == null)
	{
		return { Success = false, Code = "recruit_create_failed" };
	}

	local startingLevel = _options != null && "StartingLevel" in _options && _options.StartingLevel != null ? _options.StartingLevel : template.Level;
	local startingXP = _options != null && "StartingXP" in _options && _options.StartingXP != null ? _options.StartingXP : template.XP;
	local chargeCrowns = _options != null && "ChargeCrowns" in _options ? _options.ChargeCrowns : false;
	local summonCost = _options != null && "SummonCost" in _options && _options.SummonCost != null ? _options.SummonCost : 0;
	local hireReason = _options != null && "HireReason" in _options && _options.HireReason != null ? _options.HireReason : "summon";
	local formationPolicy = _options != null && "FormationPolicy" in _options && _options.FormationPolicy != null ? _options.FormationPolicy : "summon";
	local selectedSkinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _options != null && "SkinID" in _options ? _options.SkinID : null);
	local roster = ::World.getPlayerRoster();
	local bro = null;
	local step = "create player";

	try
	{
		// Use the real native background so both vanilla ID checks and Legends
		// background-type checks see the same faith as the four starting cultists.
		// This is a recruitment choice, never a load-time conversion or rank reset.
		local isKanadeCultist = false;
		if (template.ID == "kanade_tachibana" && ::World.Assets != null)
		{
			local origin = ::World.Assets.getOrigin();
			isKanadeCultist = origin != null && origin.getID() == "scenario.cultists";
		}

		bro = roster.create("scripts/entity/tactical/player");

		if (bro == null)
		{
			return { Success = false, Code = "recruit_create_failed" };
		}

		step = "set character";
		bro.setName(template.Name);
		bro.setTitle("");
		bro.m.HireTime = ::Time.getVirtualTimeF();

		step = "create background";
		local backgroundScript = isKanadeCultist ? "scripts/skills/backgrounds/cultist_background" : template.BackgroundScript;
		local background = ::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, backgroundScript);
		if (isKanadeCultist)
		{
			// The perk adapter reads this creation-time hint; actor flags remain
			// the persistent identity. Do not replace the native background ID.
			background.m.ValkyrieID <- template.ID;
			background.m.Titles = [];
			background.m.LastNames = [];
		}
		step = "configure background perk tree";
		::$bvvar{namespace}.configureValkyrieLegendsPerkTree(background);
		step = "add background";
		bro.getSkills().add(background);
		bro.m.Background = background;
		bro.m.Ethnicity = background.getEthnicity();
		step = "apply identity metadata";
		::$bvvar{namespace}.applyValkyrieIdentityMetadata(bro, template, background);
		step = "initialize background";
		::$bvvar{namespace}.initializeValkyrieBackground(bro, background);
		background.buildDescription(true);
		background.setAppearance();

		step = "apply base attributes";
		::$bvvar{namespace}.applyValkyrieBaseAttributes(bro, template);
		step = "apply talents";
		::$bvvar{namespace}.applyValkyrieTalents(bro, template);

		step = "set level";
		bro.m.Level = startingLevel;
		bro.m.LevelUps = startingLevel - 1;
		bro.m.PerkPoints = startingLevel - 1;
		bro.m.XP = startingXP;
		bro.m.Attributes = [];
		bro.fillAttributeLevelUpValues(::Const.XP.MaxLevelWithPerkpoints - 1);

		step = "create trait";
		local trait = ::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, template.TraitScript);
		step = "add trait";
		bro.getSkills().add(trait);
		step = "add additional traits";
		::$bvvar{namespace}.addValkyrieAdditionalTraits(bro, template, _context);
		if (isKanadeCultist)
		{
			step = "add initial Davkul candle";
			bro.getSkills().add(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, "scripts/skills/traits/cultist_fanatic_trait"));
		}

		step = "add skin trait";
		::$bvvar{namespace}.addValkyrieSkinTraitIfMissing(bro, template, _context, selectedSkinID);

		step = "set identity";
		::$bvvar{namespace}.setActorValkyrieIdentity(bro, template.ID, selectedSkinID);

		if (template.ID == "es") { step="equip Es Murakumo";::$bvvar{namespace}.EsEquipment.equipStarter(bro); }
		if (template.ID == "the_herta") { step="equip Herta starting set";::$bvvar{namespace}.HertaEquipment.equipStarter(bro); }
		if (template.ID == "rachel_alucard") { step="equip Rachel starting set";::$bvvar{namespace}.RachelEquipment.equipStarter(bro); }
		if (template.ID == "kanade_tachibana")
		{
			step = "equip Kanade starting arm blades";
			::$bvvar{namespace}.Kanade.equipStarter(bro);
		}

		if (template.ID == "m4a1")
		{
			step = "equip M4A1 signature rifle";
			local rifle = ::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, "scripts/items/weapons/battle_valkyries/m4a1_homecoming_rifle");
			if (!bro.getItems().equip(rifle)) throw "Failed to equip M4A1 signature rifle";
		}

		if (template.ID == "enterprise")
		{
			step = "equip Enterprise bow and arrows";
			foreach (path in ["scripts/items/weapons/battle_valkyries/enterprise_dauntless_wings", "scripts/items/ammo/quiver_of_arrows"])
				if (!bro.getItems().equip(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, path)))
					throw "Failed to equip Enterprise starting equipment";
			bro.getFlags().set(::$bvvar{namespace}.EnterpriseBowGrantFlag, true);
		}

		if (template.ID == "misono_mika" || template.ID == "sorasaki_hina")
		{
			step = "equip signature firearm";
			local path = template.ID == "misono_mika" ? "scripts/items/weapons/battle_valkyries/mika_quis_ut_deus" : "scripts/items/weapons/battle_valkyries/hina_the_end_destroyer";
			if (!bro.getItems().equip(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, path)))
				throw "Failed to equip Valkyrie signature firearm";
		}
		if ("TenkaGokenWeapons" in ::$bvvar{namespace} && template.ID in ::$bvvar{namespace}.TenkaGokenWeapons)
		{
			step = "equip Supreme Five ordinary starting sword";
			local sword = ::$bvvar{namespace}.TenkaGokenWeapons[template.ID];
			if (!bro.getItems().equip(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, sword.Starter)))
				throw "Failed to equip Supreme Five starting sword";
		}
		if (template.ID == "shu")
		{
			step = "equip Shu starter shield and spear";
			foreach (path in ["scripts/items/shields/wooden_shield", "scripts/items/weapons/militia_spear"])
				if (!bro.getItems().equip(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, path)))
					throw "Failed to equip Shu starting equipment";
		}
		if ("TrailsStarterConfigs" in ::$bvvar{namespace} && template.ID in ::$bvvar{namespace}.TrailsStarterConfigs)
		{
			step = "equip Trails starter equipment";
			local starter = ::$bvvar{namespace}.TrailsStarterConfigs[template.ID];
			foreach (path in ["scripts/items/weapons/battle_valkyries/" + starter.Weapon, "scripts/items/armor/padded_surcoat"])
				if (!bro.getItems().equip(::$bvvar{namespace}.createValkyrieScriptObject(_context, bro, path)))
					throw "Failed to equip Trails starting equipment";
			::$bvvar{namespace}.Orbments.prepareTrailsRecruit(bro);
		}
		if (template.ID == "hu_tao") ::$bvvar{namespace}.HuTaoEquipment.equipStarter(bro);
		step = "sync managed skills";
		local skillSync = ::$bvvar{namespace}.syncActorSkills(bro, hireReason);

		if (!skillSync.Success)
		{
			throw "Failed to synchronize Valkyrie skills: " + skillSync.Code;
		}

		step = "refresh character";
		bro.getSkills().update();
		if (template.ID == "kanade_tachibana"||template.ID=="es"||template.ID=="hu_tao"||template.ID=="rachel_alucard") bro.setHitpoints(bro.getHitpointsMax());
		step = "set formation";

		if (typeof formationPolicy == "integer")
		{
			bro.setPlaceInFormation(formationPolicy);
		}
		else if (formationPolicy == "none")
		{
			bro.setPlaceInFormation(::$bvvar{namespace}.ValkyrieSummonNotInFormation);
		}
		else
		{
			bro.setPlaceInFormation(::$bvvar{namespace}.findOpenSummonFormationSlot());
		}

		step = "hire character";
		bro.onHired();
		if ("Roster" in ::$bvvar{namespace} && ::$bvvar{namespace}.Roster.enabled())
		{
			// Explicit positions are used by authored starting/test line-ups.
			::$bvvar{namespace}.Roster.setPosition(bro, typeof formationPolicy == "integer" ? formationPolicy : 255);
			::$bvvar{namespace}.Roster.normalize();
		}
		step = "apply appearance";
		::$bvvar{namespace}.applySkinToActor(bro, true);

		step = "refresh strength";
		if (::World.State != null && ::World.State.getPlayer() != null)
		{
			::World.State.getPlayer().updateStrength();
		}

		step = "pay summon cost";
		if (chargeCrowns && summonCost > 0)
		{
			::World.Assets.addMoney(-summonCost);
		}

		return { Success = true, Code = "success", Actor = bro };
	}
	catch (e)
	{
		if (bro != null)
		{
			roster.remove(bro);

			try
			{
				if (::World.State != null && ::World.State.getPlayer() != null)
				{
					::World.State.getPlayer().updateStrength();
				}
			}
			catch (rollbackError)
			{
			}
		}

		return {
			Success = false,
			Code = "recruit_create_failed",
			Detail = "[" + step + ": " + e + "]"
		};
	}
};

::$bvvar{namespace}.summonValkyrieInternal <- function( _valkyrieID, _context, _summonCost = null, _skinID = null )
{
	::$bvvar{namespace}.removePartialValkyrieSummons();

	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);
	if (template != null && "ChapterRecruitOnly" in template && template.ChapterRecruitOnly)
		return ::$bvvar{namespace}.createValkyrieResult(false, ::$bvvar{namespace}.getValkyrieChapterRecruitHint(template), "chapter_only");

	if (template == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.invalid}", "invalid");
	}

	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);
	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(template, skinID)) return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{chapter.skin.locked}", "locked_skin");
	if (skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.no_skin}", "invalid_skin");
	}

	if (::$bvvar{namespace}.findValkyrieInRoster(_valkyrieID) != null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.exists}", "exists");
	}

	if (::$bvvar{namespace}.isValkyrieSummonRosterFull())
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.full}", "full");
	}

	local summonCost = _summonCost == null ? ::$bvvar{namespace}.getValkyrieSummonCost() : _summonCost;

	if (::World.Assets == null || ::World.Assets.getMoney() < summonCost)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.not_enough_money}" + summonCost + "$bv{ui.hub.summon.error.not_enough_money_suffix}", "not_enough_money");
	}

	local construction = ::$bvvar{namespace}.createValkyrieRosterActor(_valkyrieID, _context, {
		StartingLevel = template.Level,
		StartingXP = template.XP,
		ChargeCrowns = true,
		SummonCost = summonCost,
		HireReason = "summon",
		FormationPolicy = "summon",
		SkinID = skinID
	});

	if (!construction.Success)
	{
		local detail = "Detail" in construction ? " " + construction.Detail : "";
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.create_failed}" + detail, "create_failed");
	}

	return ::$bvvar{namespace}.createValkyrieResult(true, "$bv{ui.hub.summon.success_prefix}" + template.Name + "$bv{ui.hub.summon.success_suffix}", "success");
};

::$bvvar{namespace}.summonValkyrie <- function( _valkyrieID, _context, _skinID = null )
{
	if (::$bvvar{namespace}.getSettingValue("GachaMode"))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.direct_summon_disabled}", "gacha_mode");
	}

	return ::$bvvar{namespace}.summonValkyrieInternal(_valkyrieID, _context, null, _skinID);
};

::$bvvar{namespace}.pullGachaValkyrie <- function( _context )
{
	if (!::$bvvar{namespace}.getSettingValue("GachaMode"))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.mode_disabled}", "mode_disabled");
	}

	::$bvvar{namespace}.removePartialValkyrieSummons();

	if (::$bvvar{namespace}.isValkyrieSummonRosterFull())
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.summon.error.full}", "full");
	}

	local available = ::$bvvar{namespace}.getAvailableGachaValkyrieIDs();
	if (available.len() == 0)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.all_owned}", "all_owned");
	}

	local progress = ::$bvvar{namespace}.getValkyrieGachaProgress();
	local isGuarantee = progress >= ::$bvvar{namespace}.ValkyrieGachaProgressMax;
	local targetID = null;

	if (isGuarantee)
	{
		targetID = ::$bvvar{namespace}.getSelectedGachaValkyrieID();

		if (targetID == "" || targetID == null)
		{
			return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.need_selection}", "need_selection");
		}

		if (::$bvvar{namespace}.getValkyrieByID(targetID) == null)
		{
			::$bvvar{namespace}.clearSelectedGachaValkyrie();
			return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.invalid_selection}", "invalid_selection");
		}

		if (::$bvvar{namespace}.findValkyrieInRoster(targetID) != null)
		{
			::$bvvar{namespace}.clearSelectedGachaValkyrie();
			return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.already_owned}", "already_owned");
		}
	}
	else
	{
		targetID = ::$bvvar{namespace}.pickRandomGachaValkyrieID();
	}

	if (targetID == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.gacha.error.all_owned}", "all_owned");
	}

	local selectedSkinID = isGuarantee ? ::$bvvar{namespace}.getSelectedGachaSkinID() : null;
	local result = ::$bvvar{namespace}.summonValkyrieInternal(targetID, _context, ::$bvvar{namespace}.getValkyrieGachaCost(), selectedSkinID);

	if (result.Success)
	{
		if (isGuarantee)
		{
			::$bvvar{namespace}.setValkyrieGachaGuaranteeCount(::$bvvar{namespace}.getValkyrieGachaGuaranteeCount() + 1);
			::$bvvar{namespace}.setValkyrieGachaProgress(0);
			::$bvvar{namespace}.clearSelectedGachaValkyrie();
		}
		else
		{
			::$bvvar{namespace}.setValkyrieGachaProgress(progress + 1);

			if (::$bvvar{namespace}.getSelectedGachaValkyrieID() == targetID)
			{
				::$bvvar{namespace}.clearSelectedGachaValkyrie();
			}
		}
	}

	return result;
};

::$bvvar{namespace}.grantValkyrieSkinItem <- function( _valkyrieID, _context, _skinID = null )
{
	local template = ::$bvvar{namespace}.getValkyrieByID(_valkyrieID);

	if (template == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.invalid}", "invalid");
	}

	local skinID = ::$bvvar{namespace}.resolveValkyrieSkinID(template, _skinID);
	if (!::$bvvar{namespace}.isValkyrieSkinUnlocked(template, skinID)) return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{chapter.skin.locked}", "locked_skin");
	if (skinID == null || (_skinID != null && _skinID != "" && skinID != _skinID))
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.no_skin}", "no_skin");
	}

	local item = null;

	try
	{
		item = ::$bvvar{namespace}.createValkyrieSkinItem(template, _context, skinID);
	}
	catch (e)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.create_failed}" + " [" + e + "]", "create_failed");
	}

	if (item == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.create_failed}", "create_failed");
	}

	if (::World == null || ::World.Assets == null || ::World.Assets.getStash() == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.stash_full}", "stash_unavailable");
	}

	local slot = ::World.Assets.getStash().add(item);

	if (slot == null)
	{
		return ::$bvvar{namespace}.createValkyrieResult(false, "$bv{ui.hub.skin_item.error.stash_full}", "stash_full");
	}

	return ::$bvvar{namespace}.createValkyrieResult(true, "$bv{ui.hub.skin_item.success_prefix}" + ::$bvvar{namespace}.getValkyrieSkinItemBaseName(template, skinID) + "$bv{ui.hub.skin_item.success_suffix}", "success");
};

::$bvvar{namespace}.getValkyrieSummonSlots <- function()
{
	::$bvvar{namespace}.removePartialValkyrieSummons();

	local ret = [];
	local isRosterFull = ::$bvvar{namespace}.isValkyrieSummonRosterFull();
	local selectedGachaID = ::$bvvar{namespace}.getSelectedGachaValkyrieID();
	local selectedGachaSkinID = ::$bvvar{namespace}.getSelectedGachaSkinID();
	local worldLeaderID = ::$bvvar{namespace}.getWorldPartyLeaderValkyrieID();
	local worldLeaderSkinID = ::$bvvar{namespace}.getWorldPartyLeaderSkinID();

	foreach( valkyrieID in ::$bvvar{namespace}.ValkyrieOrder )
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);
		local existing = ::$bvvar{namespace}.findValkyrieInRoster(valkyrieID);
		local isSummoned = existing != null;
		local chapterOnly = "ChapterRecruitOnly" in template && template.ChapterRecruitOnly;
		local canSummon = !chapterOnly && !isSummoned && !isRosterFull;
		local worldLeaderBrush = ::$bvvar{namespace}.getValkyrieWorldLeaderBrush(template);
		local displaySkinID = isSummoned ? ::$bvvar{namespace}.getActorValkyrieSkinID(existing) : ::$bvvar{namespace}.getValkyrieDefaultSkinID(template);

		ret.push({
			ID = template.ID,
			Name = template.Name,
			Portrait = ::$bvvar{namespace}.getValkyrieSkinPortraitPath(template, displaySkinID),
			Background = template.BackgroundName,
			RecruitGuide = "getValkyrieRecruitGuide" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getValkyrieRecruitGuide(template) : null,
			ChapterRecruitOnly = chapterOnly,
			IsPlaceholder = false,
			Detail = ::$bvvar{namespace}.getValkyrieSummonDetail(template, existing),
			Status = isSummoned ? "$bv{ui.hub.summon.status.summoned}" : (chapterOnly ? ::$bvvar{namespace}.getValkyrieChapterRecruitHint(template) : (isRosterFull ? "$bv{ui.hub.summon.error.full}" : "$bv{ui.hub.summon.status.available}")),
			State = isSummoned ? "summoned" : (chapterOnly ? "locked" : (isRosterFull ? "full" : "available")),
			CanSummon = canSummon,
			CanGachaSelect = canSummon,
			IsGachaSelected = selectedGachaID == template.ID && canSummon,
			GachaSelectedSkinID = selectedGachaID == template.ID && canSummon ? selectedGachaSkinID : "",
			CanSetWorldLeader = worldLeaderBrush != null,
			IsWorldLeader = worldLeaderID == template.ID,
			WorldLeaderSkinID = worldLeaderID == template.ID ? worldLeaderSkinID : ""
		});
	}

	while (ret.len() < 20)
	{
		ret.push({
			ID = "empty_" + ret.len(),
			Name = "$bv{ui.hub.summon.empty.name}",
			Portrait = "",
			Background = "$bv{ui.hub.summon.empty.description}",
			RecruitGuide = null,
			ChapterRecruitOnly = false,
			IsPlaceholder = true,
			Detail = null,
			Status = "$bv{ui.hub.summon.status.locked}",
			State = "locked",
			CanSummon = false,
			CanGachaSelect = false,
			IsGachaSelected = false,
			GachaSelectedSkinID = "",
			CanSetWorldLeader = false,
			IsWorldLeader = false,
			WorldLeaderSkinID = ""
		});
	}

	return ret;
};
