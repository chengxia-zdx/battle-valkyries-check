this.thirteenth_bell_memory_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); },
	function owner() { return this.getContainer() == null ? null : this.getContainer().getActor(); },
	function onTurnStart() { ::$bvvar{namespace}.ThirteenthBell.tick(this.owner()); },
	function onValkyrieCombatEvent(e)
	{
		local key = this.m.BVSkillKey;
		::$bvvar{namespace}.ThirteenthBell.onEvent(this.owner(), key.slice("thirteenth_bell_".len()), e);
	},
	function onBeforeTargetHit(skill, target, hit)
	{
		if (this.m.BVSkillKey == "thirteenth_bell_promise") ::$bvvar{namespace}.ThirteenthBell.consume(this.owner(), skill, target, hit);
	},
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
});
