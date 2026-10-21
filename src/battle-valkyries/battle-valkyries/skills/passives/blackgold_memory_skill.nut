this.blackgold_memory_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { MemoryActor = "", MemoryTriggers = null },
	function onValkyrieSkillBound(def)
	{
		this.m.MemoryActor = def.Spec.Actor; this.m.MemoryTriggers = clone def.Spec.Triggers;
	},
	function onValkyrieCombatEvent(event)
	{
		if (event.Type != "ActionResolved" || event.UseResult != true) return;
		local bv = ::$bvvar{namespace}, owner = this.getContainer().getActor();
		if (event.Actor != owner || bv.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || !owner.isPlayerControlled()
			|| bv.getActorValkyrieID(owner) != this.m.MemoryActor || !bv.hasValkyrieLearnedSkillEntitlement(owner, this.m.BVSkillKey)) return;
		local matches = false; foreach (trigger in this.m.MemoryTriggers) if (event.SkillID == bv.getValkyrieSkillRuntimeID(trigger)) matches = true;
		if (!matches) return;
		// Actor-local combat epoch survives passive reconstruction; one refund for the entire action.
		local epoch = bv.ValkyrieCombatEvents.Epoch;
		if (!("BVBlackgoldMemory" in owner.m) || owner.m.BVBlackgoldMemory.Epoch != epoch) owner.m.BVBlackgoldMemory <- { Epoch = epoch, Used = {} };
		local key = this.m.BVSkillKey;
		if (key in owner.m.BVBlackgoldMemory.Used) return;
		owner.m.BVBlackgoldMemory.Used[key] <- true;
		owner.setFatigue(::Math.max(0, owner.getFatigue() - 10));
	},
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
});
