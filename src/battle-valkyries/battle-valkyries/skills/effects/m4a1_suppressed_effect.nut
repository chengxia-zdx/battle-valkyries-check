this.m4a1_suppressed_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { NormalRound = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = false;
		this.m.ID = "$bvvar{modId}.effects.m4a1_suppressed";
		this.m.Name = "$bv{effect.m4a1_suppressed.name}"; this.m.Description = "$bv{effect.m4a1_suppressed.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_suppressed.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/m4a1_suppressed_sw.png";
	}
	function onUpdate(_properties) { _properties.MeleeSkill -= 15; _properties.RangedSkill -= 15; _properties.Initiative -= 20; }
	function onRefresh() { this.m.NormalRound = -1; }
	function onTurnStart() { if (::$bvvar{namespace}.isM4A1NormalTurn(this.getContainer().getActor())) this.m.NormalRound = ::Time.getRound(); }
	function onTurnEnd() { if (this.m.NormalRound == ::Time.getRound() && ::$bvvar{namespace}.isM4A1NormalTurn(this.getContainer().getActor())) this.removeSelf(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
});
