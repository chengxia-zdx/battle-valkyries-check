this.spring_root_embrace_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { AppliedRound = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.spring_root_embrace";
		this.m.Name = "$bv{effect.spring.embrace.name}"; this.m.Description = "$bv{effect.spring.embrace.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/root_embrace.png"; this.m.IsStacking = false;
	}
	function onUpdate(p) { p.MeleeDefense += 25; p.RangedDefense += 25; }
	function onTurnStart() { if (::Time.getRound() > this.m.AppliedRound && !::$bvvar{namespace}.springExtraTurn(this.getContainer().getActor())) this.removeSelf(); }
	function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; }
});
