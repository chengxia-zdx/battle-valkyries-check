this.painted_harbor_memory_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function memoryState(identity)
	{
		local a = this.getContainer().getActor(), bv = ::$bvvar{namespace};
		return identity == "katsushika_hokusai" ? bv.getHokusaiState(a) : bv.getAbigailState(a);
	},
	function canUseMemory(identity)
	{
		local a = this.getContainer().getActor(), bv = ::$bvvar{namespace}, state = this.memoryState(identity);
		return state != null && state.Active && !("HarborMemoryUsed" in state) && a != null && !bv.isActorDeadOrDying(a) && a.isPlacedOnMap()
			&& a.isPlayerControlled() && bv.getActorValkyrieID(a) == identity;
	},
	function consumeMemory(identity)
	{
		if (!this.canUseMemory(identity)) return false;
		// The actor's existing epoch-scoped combat ledger survives managed skill reconstruction.
		this.memoryState(identity).HarborMemoryUsed <- true; return true;
	}
});
