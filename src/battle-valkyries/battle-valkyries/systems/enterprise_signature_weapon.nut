::$bvvar{namespace}.EnterpriseBowID <- "$bvvar{modId}.weapon.enterprise_dauntless_wings";
::$bvvar{namespace}.EnterpriseBowGrantFlag <- "BattleValkyriesEnterpriseDauntlessWingsGranted";
::$bvvar{namespace}.isEnterpriseSignatureBow <- function(_item)
{
	return _item != null && _item.getID() == this.EnterpriseBowID;
};
::$bvvar{namespace}.hasEnterpriseSignatureBow <- function(_actor)
{
	return _actor != null && this.getActorValkyrieID(_actor) == "enterprise" && _actor.isPlayerControlled()
		&& _actor.getItems() != null && this.isEnterpriseSignatureBow(_actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand));
};
::$bvvar{namespace}.recoverEnterpriseSortieFatigue <- function(_actor)
{
	local state = this.getEnterpriseState(_actor);
	if (state == null || !state.Active || this.isActorDeadOrDying(_actor) || !_actor.isPlacedOnMap()
		|| !this.hasEnterpriseSignatureBow(_actor) || state.RecoveryRound == ::Time.getRound()) return false;
	state.RecoveryRound = ::Time.getRound();
	_actor.setFatigue(::Math.max(0, _actor.getFatigue() - 4));
	return true;
};
// Old saves receive one copy in the stash. Never replace or destroy equipped items.
// Called only after the complete world has loaded or returned to the world screen.
::$bvvar{namespace}.grantMissingEnterpriseSignatureBow <- function()
{
	if (!("World" in getroottable()) || ::World == null || ::World.Assets == null) return false;
	local roster = ::World.getPlayerRoster(), stash = ::World.Assets.getStash();
	if (roster == null || stash == null) return false;
	local actors = roster.getAll(), owner = null, exists = false;
	foreach (actor in actors)
	{
		if (this.getActorValkyrieID(actor) == "enterprise" && actor.isPlayerControlled() && !this.isActorDeadOrDying(actor)) owner = actor;
		foreach (item in actor.getItems().getAllItems()) if (this.isEnterpriseSignatureBow(item)) exists = true;
	}
	if (owner == null) return false;
	local flags = owner.getFlags();
	if (flags.has(this.EnterpriseBowGrantFlag) && flags.get(this.EnterpriseBowGrantFlag)) return false;
	foreach (item in stash.getItems()) if (this.isEnterpriseSignatureBow(item)) exists = true;
	if (exists) { flags.set(this.EnterpriseBowGrantFlag, true); return false; }
	if (!stash.isResizable() && stash.getNumberOfEmptySlots() <= 0) return false;
	local slot = null;
	try
	{
		local item = ::new("scripts/items/weapons/battle_valkyries/enterprise_dauntless_wings");
		slot = stash.add(item);
	}
	catch (e)
	{
		this.log("Enterprise signature bow grant deferred: " + e);
		return false;
	}
	if (slot == null || slot == -1) return false;
	flags.set(this.EnterpriseBowGrantFlag, true);
	this.log("Enterprise signature bow granted to stash for existing roster.");
	return true;
};
