::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function() { ++::$bvvar{namespace}.Grail.BattleSerial; return __original(); };
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function() {
		this.getFlags().set("$bvvar{modId}.grail.growth_used", false);
		::$bvvar{namespace}.syncGrailGear(this);
		local ret = __original();
		::$bvvar{namespace}.grailActorState(this).StartedWithSet = ::$bvvar{namespace}.grailPieces(this).len() == 4;
		local battle = ::$bvvar{namespace}.Chapters.Battle;
		if (battle != null && battle.ID == ::$bvvar{namespace}.Grail.ID) {
			if (!("GrailParticipants" in battle)) battle.GrailParticipants <- [];
			battle.GrailParticipants.push(this.getID());
		}
		return ret;
	};
});
local sync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown") {
	local result = sync.call(this, actor, reason); this.syncGrailGear(actor); return result;
};
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(item) {
		if (item != null && item.getID() == "$bvvar{modId}.item.four_oaths_grail") return false;
		local ret = __original(item); if (ret) ::$bvvar{namespace}.syncGrailGear(this.getActor()); return ret;
	};
	q.unequip = @(__original) function(item) {
		local ret = __original(item); if (ret) ::$bvvar{namespace}.syncGrailGear(this.getActor()); return ret;
	};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/character/character_screen", function(q) {
	// A native usable's false return means equip failure; this item opens a choice
	// instead of being consumed. Return the unchanged inventory DTO explicitly.
	foreach (name in ["general_onEquipStashItem", "general_onDropStashItemIntoBag"]) {
		q[name] = @(__original) function(data) {
			local found = this.helper_queryStashItemData(data);
			if (!("error" in found) && found.sourceItem.getID() == "$bvvar{modId}.item.four_oaths_grail" && ::$bvvar{namespace}.Grail.safeWorld()) {
				found.sourceItem.onUse(found.inventory.getActor());
				return this.UIDataHelper.convertStashAndEntityToUIData(found.entity, null, false, this.m.InventoryFilter);
			}
			return __original(data);
		};
	}
	q.general_onDestroyStashItem = @(__original) function(data) {
		local found = this.helper_queryStashItemData(data);
		if (!("error" in found) && found.sourceItem.getID() == "$bvvar{modId}.item.four_oaths_grail") return null;
		return __original(data);
	};
});
::$bvvar{namespace}.MH.hook("scripts/ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(q) {
	q.showBattleValkyrieGrail <- function() {
		this.m.JSHandle.asyncCall("showBattleValkyrieChapter", { ID = ::$bvvar{namespace}.Grail.ID, OpenWish = true });
	};
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onTurnStart = @(__original) function() {
		if (::$bvvar{namespace}.isMorganNormalTurn(this)) ::$bvvar{namespace}.grailActorState(this).Protected = false;
		return __original();
	};
	q.onDamageReceived = @(__original) function(attacker, skill, hit) {
		local previous = "BVGrailHit" in this.m ? this.m.BVGrailHit : null;
		this.m.BVGrailHit <- { Skill = skill, Hit = hit };
		local result = null;
		try { result = __original(attacker, skill, hit); }
		catch (e) { this.m.BVGrailHit = previous; throw e; }
		this.m.BVGrailHit = previous; return result;
	};
});
local won = ::$bvvar{namespace}.Chapters.battleWon;
::$bvvar{namespace}.Chapters.battleWon = function(id, node) {
	if (id != ::$bvvar{namespace}.Grail.ID) return won.call(this, id, node);
	local battle = this.Battle, stage = this.stage(id);
	if (stage == null || battle == null || battle.ID != id || battle.Node != node || !("GrailParticipants" in battle)) return;
	foreach (identity in ::$bvvar{namespace}.Grail.Actors) {
		local alive = false;
		foreach (actorID in battle.GrailParticipants) if (::$bvvar{namespace}.Grail.findActor(actorID, identity) != null) alive = true;
		if (!alive) return;
	}
	foreach (goal in stage.Goals) if (goal.Node == node && goal.Battle) this.write(id, "goal." + goal.Key, 1);
};
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	q.onDamageReceived = @(__original) function(attacker, hp, armor) {
		local result = __original(attacker, hp, armor);
		::$bvvar{namespace}.grailTrySurvive(this.getActor(), attacker, hp);
		return result;
	};
});
// The normal action implementation decides success; missed/invalid actions do not
// get silently promoted to hits. Growth cannot re-enter through a rebuilt skill.
foreach (entry in [["saber", "saber_strike_air"], ["morgan", "morgan_lake_grace"], ["jeanne", "jeanne_luminosite_eternelle"], ["jeanne_alter", "jeanne_alter_la_grondement_du_haine"]]) {
	local identity = entry[0];
	::$bvvar{namespace}.MH.hook("$bvvar{privateFolder}/skills/actives/" + entry[1] + "_skill", function(q) {
		q.onUse = @(__original) function(user, tile) {
			local result = __original(user, tile);
			if (result) ::$bvvar{namespace}.consumeGrailGrowth(user, identity);
			return result;
		};
	});
}

// Replace changed numeric rows instead of leaving contradictory base tooltips.
foreach (entry in [
 ["passives/saber_invisible_air_skill", { [5] = "$bv{chapter.grail.combat.saber.mana}" }],
 ["actives/saber_excalibur_skill", { [2] = "$bv{chapter.grail.combat.saber.excalibur}" }],
 ["passives/morgan_from_worlds_end_skill", { [3] = "$bv{chapter.grail.combat.morgan.mana}" }],
 ["actives/morgan_roadless_camelot_skill", { [2] = "$bv{chapter.grail.combat.morgan.camelot}" }],
 ["passives/jeanne_revelation_holy_banner_skill", { [3] = "$bv{chapter.grail.combat.jeanne.aura}" }],
 ["effects/jeanne_holy_banner_aura_effect", { [4] = "$bv{chapter.grail.combat.jeanne.aura}" }],
 ["passives/jeanne_alter_dragon_witch_skill", { [4] = "$bv{chapter.grail.combat.alter.hunt}" }],
 ["actives/jeanne_alter_la_grondement_du_haine_skill", { [4] = "$bv{chapter.grail.combat.alter.attack}", [5] = "$bv{chapter.grail.combat.alter.curse}" }]
]) {
 local rows = entry[1], aura = entry[0] == "effects/jeanne_holy_banner_aura_effect";
 ::$bvvar{namespace}.MH.hook("$bvvar{privateFolder}/skills/" + entry[0], function(q) {
  q.getTooltip = @(__original) function() {
   local ret = __original(), owner = aura ? this.getOwner() : this.getContainer().getActor();
   if (::$bvvar{namespace}.hasGrailBlessing(owner)) foreach (row in ret) if (row.id in rows) row.text = rows[row.id];
   return ret;
  };
 });
}
