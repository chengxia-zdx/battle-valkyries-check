::$bvvar{namespace}.getReturningOathWeapon <- function(actor, usable = true)
{
	if (actor == null || actor.getItems() == null) return null;
	local item = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	return item != null && item.getID() == "$bvvar{modId}.weapon.hysilens_returning_oath" && (!usable || item.getCondition() > 0) ? item : null;
};
::$bvvar{namespace}.hasReturningOath <- function(actor)
{
	return actor != null && !this.isActorDeadOrDying(actor) && this.getActorValkyrieID(actor) == "hysilens" && this.getReturningOathWeapon(actor) != null;
};
::$bvvar{namespace}.syncReturningOathSkills <- function(actor)
{
	if (actor == null) return;
	local key = "royal_tide_slash", owner = "$bvvar{modId}.owner.item.hysilens_returning_oath";
	if (this.getReturningOathWeapon(actor, false) != null) this.attachTransientSkill(actor, key, owner);
	else this.detachTransientSkill(actor, key, owner);
};
// Equipment callbacks run before the item has left its slot. Explicitly demote
// existing applications there; re-equipping may only strengthen a new application.
::$bvvar{namespace}.downgradeReturningOathErosion <- function(actor)
{
	// World-map inventory callbacks run with an incomplete Tactical namespace.
	if (actor == null || !("Tactical" in getroottable()) || ::Tactical == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null) return;
	foreach (group in ::Tactical.Entities.getAllInstances()) foreach (target in group)
	{
		if (target == null || target.getSkills() == null) continue;
		local effect = target.getSkills().getSkillByID("$bvvar{modId}.effects.hysilens_tidal_erosion");
		if (effect != null && effect.m.OwnerID == actor.getID()) { effect.downgradeReturningOath(); target.getSkills().update(); }
	}
};
// Reset only on actual combat entry, never skill creation, equipment or extra turns.
::$bvvar{namespace}.resetRoyalTideCombat <- function(actor)
{
	actor.getFlags().set("$bvvar{modId}.royal_tide.crystal_spent", false);
	foreach (id in ["cerydra", "hysilens"]) actor.getFlags().set("$bvvar{modId}.royal_tide.growth_used." + id, false);
};
::$bvvar{namespace}.isRoyalTideCrystalSpent <- function(actor)
{
	local flags = actor.getFlags(), key = "$bvvar{modId}.royal_tide.crystal_spent";
	return flags.has(key) && flags.get(key);
};
::$bvvar{namespace}.consumeRoyalTideGrowth <- function(actor, id)
{
	if (actor == null || this.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || !actor.isPlayerControlled()
		|| this.getActorValkyrieID(actor) != id || !this.hasValkyrieLearnedSkillEntitlement(actor, "royal_tide_" + id + "_growth")) return false;
	local flags = actor.getFlags(), key = "$bvvar{modId}.royal_tide.growth_used." + id;
	if (flags.has(key) && flags.get(key)) return false;
	flags.set(key, true); actor.setFatigue(::Math.max(0, actor.getFatigue() - 5)); actor.setDirty(true); return true;
};
local originalRewards = ::$bvvar{namespace}.Chapters.syncRewards;
::$bvvar{namespace}.Chapters.syncRewards = function(id)
{
	originalRewards.call(this, id);
	if (id != "royal_banner_returning_tide" || this.completed(id) < 7 || this.read(id, "weapon_delivered") == 1) return;
	local stash = ::World.Assets.getStash();
	if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return;
	try
	{
		local item = ::new("scripts/items/weapons/battle_valkyries/hysilens_returning_oath");
		if (stash.add(item) != null) this.write(id, "weapon_delivered", 1);
	}
	catch (e) { ::logError("[Battle Valkyries] Returning Oath delivery pending: " + e); }
};
local originalDTO = ::$bvvar{namespace}.Chapters.dto;
::$bvvar{namespace}.Chapters.dto = function(id)
{
	local result = originalDTO.call(this, id);
	if (result != null && id == "royal_banner_returning_tide") result.PendingWeapon = this.completed(id) >= 7 && this.read(id, "weapon_delivered") != 1;
	return result;
};
