::$bvvar{namespace}.SwordMaidenHuntTraitID <- "$bvvar{modId}.trait.sword_maiden_hunt_record";

::$bvvar{namespace}.SwordMaidenHuntMilestones <- [
	{ Points = 0, Key = "sword_maiden_goblin_codex", Kind = "passive", Name = "$bv{skill.sword_maiden_goblin_codex.name}", Description = "$bv{skill.sword_maiden_goblin_codex.description}", Tooltip = [
		{ Text = "$bv{hunt.sword_maiden.rank_bonus}" }
	] },
	{ Points = 25, Key = "sword_maiden_cave_survivor", Kind = "passive", Name = "$bv{skill.sword_maiden_cave_survivor.name}", Description = "$bv{skill.sword_maiden_cave_survivor.description}", Tooltip = [
		{ Text = "$bv{skill.sword_maiden_cave_survivor.tooltip.escape}" },
		{ Text = "$bv{skill.sword_maiden_cave_survivor.tooltip.damage}" }
	] },
	{ Points = 75, Key = "sword_maiden_holy_binding_judgment", Kind = "active", Name = "$bv{skill.sword_maiden_holy_binding_judgment.name}", Description = "$bv{skill.sword_maiden_holy_binding_judgment.description}", Tooltip = [
		{ Text = "$bv{skill.sword_maiden_holy_binding_judgment.tooltip.debuff}" },
		{ Text = "$bv{skill.sword_maiden_holy_binding_judgment.tooltip.goblin}" },
		{ Text = "$bv{skill.sword_maiden_holy_binding_judgment.tooltip.credit}" }
	] },
	{ Points = 150, Key = "sword_maiden_root_extermination", Kind = "passive", Name = "$bv{skill.sword_maiden_root_extermination.name}", Description = "$bv{skill.sword_maiden_root_extermination.description}", Tooltip = [
		{ Text = "$bv{skill.sword_maiden_root_extermination.tooltip.refund}" },
		{ Text = "$bv{skill.sword_maiden_root_extermination.tooltip.goblin}" }
	] },
	{ Points = 250, Key = "sword_maiden_balance_final_judgment", Kind = "active", Name = "$bv{skill.sword_maiden_balance_final_judgment.name}", Description = "$bv{skill.sword_maiden_balance_final_judgment.description}", Tooltip = [
		{ Text = "$bv{skill.sword_maiden_balance_final_judgment.tooltip.primary}" },
		{ Text = "$bv{skill.sword_maiden_balance_final_judgment.tooltip.area}" },
		{ Text = "$bv{skill.sword_maiden_balance_final_judgment.tooltip.kill}" }
	] },
	{ Points = 300, Key = "sword_maiden_light_in_darkness", Kind = "passive", Name = "$bv{skill.sword_maiden_light_in_darkness.name}", Description = "$bv{skill.sword_maiden_light_in_darkness.description}", Tooltip = [
		{ Text = "$bv{skill.sword_maiden_light_in_darkness.tooltip.free}" },
		{ Text = "$bv{skill.sword_maiden_light_in_darkness.tooltip.followup}" },
		{ Text = "$bv{skill.sword_maiden_light_in_darkness.tooltip.goblin}" }
	] }
];

::$bvvar{namespace}.SwordMaidenGoblinTypes <- [
	{ Types = ["GoblinFighterLOW", "GoblinSkirmisherLOW"], Key = "fighter_low", Points = 1, Name = "$bv{hunt.sword_maiden.goblin.fighter_low}" },
	{ Types = ["GoblinAmbusherLOW"], Key = "ambusher_low", Points = 1, Name = "$bv{hunt.sword_maiden.goblin.ambusher_low}" },
	{ Types = ["GoblinFighter", "GoblinSkirmisher"], Key = "fighter", Points = 2, Name = "$bv{hunt.sword_maiden.goblin.fighter}" },
	{ Type = "GoblinAmbusher", Key = "ambusher", Points = 2, Name = "$bv{hunt.sword_maiden.goblin.ambusher}" },
	{ Type = "GoblinWolfrider", Key = "wolfrider", Points = 3, Name = "$bv{hunt.sword_maiden.goblin.wolfrider}" },
	{ Type = "GoblinShaman", Key = "shaman", Points = 4, Name = "$bv{hunt.sword_maiden.goblin.shaman}" },
	{ Types = ["GoblinLeader", "GoblinOverseer"], Key = "leader", Points = 5, Name = "$bv{hunt.sword_maiden.goblin.leader}" },
	{ Type = "LegendGoblinHarrier", Key = "legend_harrier", Points = 3, Name = "$bv{hunt.sword_maiden.goblin.legend_harrier}" },
	{ Type = "LegendGoblinTribeDefender", Key = "legend_defender", Points = 3, Name = "$bv{hunt.sword_maiden.goblin.legend_defender}" },
	{ Type = "LegendGoblinDirewolfRider", Key = "legend_direwolf_rider", Points = 4, Name = "$bv{hunt.sword_maiden.goblin.legend_direwolf_rider}" },
	{ Type = "LegendGoblinBerserker", Key = "legend_berserker", Points = 5, Name = "$bv{hunt.sword_maiden.goblin.legend_berserker}" },
	{ Type = "LegendGoblinWitchDoctor", Key = "legend_witch_doctor", Points = 6, Name = "$bv{hunt.sword_maiden.goblin.legend_witch_doctor}" },
	{ Type = "LegendGoblinWhiteDirewolfRider", Key = "legend_white_rider", Points = 7, Name = "$bv{hunt.sword_maiden.goblin.legend_white_rider}" }
];

::$bvvar{namespace}.getSwordMaidenHuntTrait <- function( _actor )
{
	if (_actor == null) return null;
	try { return _actor.getSkills().getSkillByID(::$bvvar{namespace}.SwordMaidenHuntTraitID); } catch (e) { return null; }
};

::$bvvar{namespace}.getSwordMaidenHuntRank <- function( _points )
{
	return ::Math.max(0, ::Math.min(12, ::Math.floor(_points / 25)));
};

::$bvvar{namespace}.getSwordMaidenGoblinInfo <- function( _target )
{
	if (_target == null) return null;
	try { if (_target.getXPValue() <= 0) return null; } catch (e) {}
	try { if ("isSummoned" in _target && _target.isSummoned()) return null; } catch (e) {}
	try
	{
		local flags = _target.getFlags();
		foreach (flag in ["IsSummoned", "IsIllusion", "BattleValkyriesDebugSpawn"])
		{
			if (flags != null && flags.has(flag)) return null;
		}
	}
	catch (e) {}

	local entityType = null;
	try { entityType = _target.getType(); } catch (e) { return null; }
	foreach (entry in ::$bvvar{namespace}.SwordMaidenGoblinTypes)
	{
		local typeNames = "Types" in entry ? entry.Types : [entry.Type];
		local matched = false;
		foreach (typeName in typeNames)
		{
			if (typeName in ::Const.EntityType && ::Const.EntityType[typeName] == entityType)
			{
				matched = true;
				break;
			}
		}
		if (matched)
		{
			local points = entry.Points;
			local champion = false;
			try { champion = "IsMiniboss" in _target.m && _target.m.IsMiniboss; } catch (e) {}
			if (champion) points += 3;
			return { Key = entry.Key, Name = entry.Name, Points = points, IsChampion = champion, IsGoblin = true };
		}
	}

	local className = "";
	try { className = _target.getClassName().tolower(); } catch (e) {}
	local goblinFaction = false;
	try { goblinFaction = ::Const.EntityType.getDefaultFaction(entityType) == ::Const.FactionType.Goblins; } catch (e) {}
	if (className.find("goblin") == null && !goblinFaction) return null;
	local fallbackPoints = 2;
	local fallbackChampion = false;
	try { fallbackChampion = "IsMiniboss" in _target.m && _target.m.IsMiniboss; } catch (e) {}
	if (fallbackChampion) fallbackPoints += 3;
	return { Key = "other", Name = "$bv{hunt.sword_maiden.goblin.other}", Points = fallbackPoints, IsChampion = fallbackChampion, IsGoblin = true };
};

::$bvvar{namespace}.isSwordMaidenGoblin <- function( _target )
{
	return ::$bvvar{namespace}.getSwordMaidenGoblinInfo(_target) != null;
};

::$bvvar{namespace}.getSwordMaidenHuntPoints <- function( _actor )
{
	local trait = ::$bvvar{namespace}.getSwordMaidenHuntTrait(_actor);
	return trait == null ? 0 : trait.getTotalPoints();
};

::$bvvar{namespace}.isSwordMaidenMilestoneUnlocked <- function( _actor, _points )
{
	return _points <= 0 || ::$bvvar{namespace}.getSwordMaidenHuntPoints(_actor) >= _points;
};

::$bvvar{namespace}.finalizeSwordMaidenHuntProgress <- function()
{
	local actor = ::$bvvar{namespace}.findValkyrieInRoster("sword_maiden");
	local trait = ::$bvvar{namespace}.getSwordMaidenHuntTrait(actor);
	if (actor == null || trait == null) return 0;
	local added = trait.commitPendingProgress();
	if (added > 0)
	{
		local sync = ::$bvvar{namespace}.syncActorSkills(actor, "sword-maiden-hunt-finalize");
		if (!sync.Success) ::logError("[Battle Valkyries] [SwordMaidenHunt] skill sync deferred after progression update");
		actor.getSkills().update();
		actor.setDirty(true);
	}
	return added;
};

::$bvvar{namespace}.makeSwordMaidenHuntDTO <- function( _actor = null )
{
	local trait = ::$bvvar{namespace}.getSwordMaidenHuntTrait(_actor);
	local points = trait == null ? 0 : trait.getTotalPoints();
	local rank = ::$bvvar{namespace}.getSwordMaidenHuntRank(points);
	local nextPoints = rank >= 12 ? 300 : (rank + 1) * 25;
	local breakdown = [];
	foreach (entry in ::$bvvar{namespace}.SwordMaidenGoblinTypes)
	{
		local kills = trait == null ? 0 : trait.getKillCount(entry.Key);
		breakdown.push({ Key = entry.Key, Name = entry.Name, Points = entry.Points, Kills = kills });
	}
	breakdown.push({ Key = "other", Name = "$bv{hunt.sword_maiden.goblin.other}", Points = 2, Kills = trait == null ? 0 : trait.getKillCount("other") });
	breakdown.push({ Key = "champion_bonus", Name = "$bv{hunt.sword_maiden.goblin.champion_bonus}", Points = 3, Kills = trait == null ? 0 : trait.getKillCount("champion_bonus") });
	local milestones = [];
	foreach (stage in ::$bvvar{namespace}.SwordMaidenHuntMilestones)
	{
		local tooltip = [];
		foreach (row in stage.Tooltip) tooltip.push({ Text = row.Text });
		milestones.push({
			Points = stage.Points,
			Key = stage.Key,
			Kind = stage.Kind,
			Name = stage.Name,
			Description = stage.Description,
			Tooltip = tooltip,
			Icon = "skills/$bvvar{iconPrefix}/" + stage.Key + ".png",
			Unlocked = points >= stage.Points
		});
	}
	return {
		Points = points,
		PendingPoints = trait == null ? 0 : trait.getPendingPoints(),
		DirectKills = trait == null ? 0 : trait.getDirectKills(),
		AssistConvictions = trait == null ? 0 : trait.getAssistConvictions(),
		Rank = rank,
		RankMax = 12,
		NextPoints = nextPoints,
		RankDescription = "$bv{hunt.sword_maiden.rank_bonus}",
		Breakdown = breakdown,
		Milestones = milestones
	};
};
