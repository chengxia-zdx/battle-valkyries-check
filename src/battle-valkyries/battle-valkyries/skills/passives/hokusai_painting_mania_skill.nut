this.hokusai_painting_mania_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill",{
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { return this.getContainer().getActor(); }
	function getName()
	{
		local s=::$bvvar{namespace}.getHokusaiState(this.owner());
		return this.m.Name+(s!=null && s.Active?" ("+s.Inspiration+"/6)":"");
	}
	function onCombatStarted() { ::$bvvar{namespace}.startHokusaiCombat(this.owner()); }
	function onDeath(fatality) { ::$bvvar{namespace}.stopHokusaiCombat(this.owner()); }
	function onCombatFinished() { ::$bvvar{namespace}.stopHokusaiCombat(this.owner());this.skill.onCombatFinished(); }
	function onUpdate(p)
	{
		local s=::$bvvar{namespace}.getHokusaiState(this.owner());
		if(s!=null && s.Active && s.NatureUntil>=0) { p.MeleeDefense+=25;p.RangedDefense+=25; }
	}
	function ignoresShieldFor(skill)
	{
		return ::$bvvar{namespace}.isHokusaiSpell(skill) && skill.getBattleValkyriesSkillKey()=="hokusai_thirty_six_views";
	}
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getHokusaiStateText(this.owner())}];
	}
});
