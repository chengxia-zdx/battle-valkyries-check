::$bvvar{namespace}.MH.hook("scripts/ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(q) {
	q.requestBattleValkyrieChapter <- function(request) { return ::$bvvar{namespace}.Chapters.request(request); }
	q.showBattleValkyrieChapter <- function(id) { this.m.JSHandle.asyncCall("showBattleValkyrieChapter", id); }
});
local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
	local result = originalSync(actor, reason);
	if (result != null && result.Success) ::$bvvar{namespace}.syncQingmingWeaponSkills(actor);
	return result;
};
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.equip = @(__original) function(item)
	{
		if (item != null && item.getID() == "$bvvar{modId}.weapon.qingming_casket" && ::$bvvar{namespace}.getActorValkyrieID(this.getActor()) != "ye_shunguang") return false;
		return __original(item);
	}
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		this.m.BVQingmingUnsheathed <- false;
		local weapon = ::$bvvar{namespace}.getQingmingWeapon(this); if (weapon != null) weapon.setSwordForm(false);
		__original();
		// Run after every effect's onCombatStarted, otherwise stance.reset erases the bonus.
		if (weapon != null && ::$bvvar{namespace}.getYunkiWeaponStage(this) >= 3)
		{
			local clarity = ::$bvvar{namespace}.getRuntimeSkillByKey(this, "ye_shunguang_enlightened_clarity");
			if (clarity != null) clarity.ensureStance().setCount(2);
		}
		local context = ::$bvvar{namespace}.Chapters.Battle, id = ::$bvvar{namespace}.getActorValkyrieID(this);
		if (context != null && id != null) context.Participants[id] <- this.getID();
	}
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onCombatFinished = @(__original) function()
	{
		local result = __original();
		::$bvvar{namespace}.Chapters.Battle = null;
		foreach (actor in ::World.getPlayerRoster().getAll())
		{
			actor.m.BVQingmingUnsheathed <- false;
			foreach (item in actor.getItems().getAllItems()) if (item != null && item.getID() == "$bvvar{modId}.weapon.qingming_casket") item.setSwordForm(false);
		}
		foreach (item in ::World.Assets.getStash().getItems()) if (item != null && item.getID() == "$bvvar{modId}.weapon.qingming_casket") item.setSwordForm(false);
		foreach (id, definition in ::$bvvar{namespace}.ChapterDefinitions) { ::$bvvar{namespace}.Chapters.syncRewards(id); ::$bvvar{namespace}.Chapters.ensureLocations(id); }
		return result;
	}
});
// Vanilla calculates final HP damage before notifying the skill container, then
// subtracts it immediately afterwards. Supply only the absorbed amount at that
// boundary (without setHitpoints' max-HP clamp); callbacks receive the unshielded
// remainder. This prevents lethal damage correctly and leaves armor untouched.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function(attacker, skill, hit)
	{
		local previous = "BVYunkiHit" in this.m ? this.m.BVYunkiHit : null;
		this.m.BVYunkiHit <- hit;
		local result = null;
		try { result = __original(attacker, skill, hit); }
		catch (e) { this.m.BVYunkiHit = previous; throw e; }
		this.m.BVYunkiHit = previous; return result;
	}
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function(q) {
	q.onDamageReceived = @(__original) function(attacker, hp, armor)
	{
		local actor = this.getActor(), ward = this.getSkillByID("$bvvar{modId}.effects.yixuan_sanctuary");
		if (ward != null && hp > 0 && actor.isAlive() && "BVYunkiHit" in actor.m && actor.m.BVYunkiHit != null)
		{
			local absorbed = ::Math.min(hp, ward.m.Remaining);
			ward.m.Remaining -= absorbed; actor.m.Hitpoints += absorbed; hp -= absorbed;
			actor.m.BVYunkiHit.DamageInflictedHitpoints = hp;
			if ("InjuryThresholdMult" in actor.m.BVYunkiHit)
				actor.m.BVYunkiHit.InjuryThresholdMult = hp <= 0 ? 0 : actor.m.BVYunkiHit.InjuryThresholdMult * (hp + absorbed) / hp.tofloat();
			if (ward.m.Remaining <= 0) this.remove(ward);
		}
		return __original(attacker, hp, armor);
	}
});
