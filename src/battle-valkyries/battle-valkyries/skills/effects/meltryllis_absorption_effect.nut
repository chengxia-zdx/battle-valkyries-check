this.meltryllis_absorption_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { EndsLeft = 2 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.meltryllis_absorption";
		this.m.Name = "$bv{effect.meltryllis_absorption.name}"; this.m.Description = "$bv{effect.meltryllis_absorption.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/meltryllis_melt_virus.png"; this.m.IconMini = "status_effect_34_mini";
		this.m.IsStacking = false;
	}
	function onRefresh() { this.m.EndsLeft = 2; }
	function onTurnEnd() { if (--this.m.EndsLeft <= 0) this.removeSelf(); }
});
