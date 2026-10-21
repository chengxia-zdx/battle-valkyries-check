this.c_c_shock_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={NormalTurnStarted=false},
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID=::$bvvar{namespace}.CCShockID;
		this.m.Name="$bv{effect.c_c_shock.name}";this.m.Description="$bv{effect.c_c_shock.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/c_c_shock_image.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/c_c_shock_image_sw.png";this.m.IconMini="status_effect_54_mini";
	}
	function onUpdate(p) { p.MeleeSkill-=20;p.RangedSkill-=20;p.Bravery-=15;p.Initiative-=30; }
	function onTurnStart() { if (::$bvvar{namespace}.isCCNormalTurn(this.getContainer().getActor())) this.m.NormalTurnStarted=true; }
	function onTurnEnd() { if (this.m.NormalTurnStarted && ::$bvvar{namespace}.isCCNormalTurn(this.getContainer().getActor())) this.removeSelf(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; }
});
