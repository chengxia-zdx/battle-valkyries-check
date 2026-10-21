// Keep usage on the combat ledger, not the rebuildable managed skill instance.
::$bvvar{namespace}.greyFalconMemoryAvailable <- function(actor, key)
{
	local identity = key == "grey_falcon_return_route" ? "enterprise" : key == "grey_falcon_cover_reload" ? "m4a1" : null;
	if (identity == null || actor == null || this.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || !actor.isPlayerControlled()
		|| this.getActorValkyrieID(actor) != identity || !this.hasValkyrieLearnedSkillEntitlement(actor, key)) return false;
	local state = identity == "enterprise" ? this.getEnterpriseState(actor) : this.getM4A1State(actor);
	return state != null && state.Active && state.Epoch == this.ValkyrieCombatEvents.Epoch
		&& (!("GreyFalconMemoryUsed" in state) || !state.GreyFalconMemoryUsed);
};
::$bvvar{namespace}.consumeGreyFalconMemory <- function(actor, key)
{
	if (!this.greyFalconMemoryAvailable(actor, key)) return false;
	local state = key == "grey_falcon_return_route" ? this.getEnterpriseState(actor) : this.getM4A1State(actor);
	state.GreyFalconMemoryUsed <- true;
	return true;
};
