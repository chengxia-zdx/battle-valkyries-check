::$bvvar{namespace}.getLiuchunWeapon <- function(actor, usable = true)
{
	if (actor == null || actor.getItems() == null) return null;
	local item = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	return item != null && item.getID() == "$bvvar{modId}.weapon.castorice_liuchun" && (!usable || item.getCondition() > 0) ? item : null;
};
::$bvvar{namespace}.hasLiuchunFlow <- function(actor)
{
	return actor != null && !this.isActorDeadOrDying(actor) && this.getActorValkyrieID(actor) == "castorice" && this.getLiuchunWeapon(actor) != null;
};
::$bvvar{namespace}.syncLiuchunWeaponSkills <- function(actor)
{
	if (actor == null) return;
	local key = "spring_liuchun_strike", owner = "$bvvar{modId}.owner.item.castorice_liuchun";
	if (this.getLiuchunWeapon(actor, false) != null) this.attachTransientSkill(actor, key, owner);
	else this.detachTransientSkill(actor, key, owner);
};
// Only the actor's real combat-entry hook resets these persisted flags. Skill
// reconstruction, equipment, waiting and extra-action callbacks never reset them.
::$bvvar{namespace}.resetSpringGrowth <- function(actor)
{
	foreach (id in ["castorice", "fengjin"]) actor.getFlags().set("$bvvar{modId}.spring.used." + id, false);
};
::$bvvar{namespace}.consumeSpringGrowth <- function(actor, id)
{
	if (actor == null || this.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || !actor.isPlayerControlled()
		|| this.getActorValkyrieID(actor) != id || !this.hasValkyrieLearnedSkillEntitlement(actor, "spring_" + id + "_growth")) return false;
	local flag = "$bvvar{modId}.spring.used." + id, flags = actor.getFlags();
	if (flags.has(flag) && flags.get(flag)) return false;
	flags.set(flag, true);
	actor.setFatigue(::Math.max(0, actor.getFatigue() - (id == "castorice" ? 10 : 5)));
	actor.setDirty(true);
	return true;
};
::$bvvar{namespace}.springExtraTurn <- function(actor)
{
	local skills = actor.getSkills(), command = skills.getSkillByID("$bvvar{modId}.effects.cerydra_command_turn"), granted = skills.getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	return (command != null && command.m.IsCommandPhase) || (granted != null && granted.m.BVIsExtraTurn)
		|| ("BVCCExtraTurnFrame" in actor.m && actor.m.BVCCExtraTurnFrame);
};
// Extend the existing transaction's post-commit delivery and authoritative DTO.
local originalRewards = ::$bvvar{namespace}.Chapters.syncRewards;
::$bvvar{namespace}.Chapters.syncRewards = function(id)
{
	originalRewards.call(this, id);
	if (id != "spring_passes_here" || this.completed(id) < 7 || this.read(id, "weapon_delivered") == 1) return;
	local stash = ::World.Assets.getStash();
	if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return;
	try
	{
		local item = ::new("scripts/items/weapons/battle_valkyries/castorice_liuchun");
		if (stash.add(item) != null) this.write(id, "weapon_delivered", 1);
	}
	catch (e) { ::logError("[Battle Valkyries] Springkeeper delivery pending: " + e); }
};
local originalDTO = ::$bvvar{namespace}.Chapters.dto;
::$bvvar{namespace}.Chapters.dto = function(id)
{
	local result = originalDTO.call(this, id);
	if (result != null && id == "spring_passes_here") result.PendingWeapon = this.completed(id) >= 7 && this.read(id, "weapon_delivered") != 1;
	return result;
};
