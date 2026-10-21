this.meltryllis_ballet_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Count = 2 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.meltryllis_ballet";
		this.m.Name = "$bv{effect.meltryllis_ballet.name}"; this.m.Description = "$bv{effect.meltryllis_ballet.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/meltryllis_crime_ballet.png"; this.m.IconMini = "status_effect_34_mini";
		this.m.IsStacking = false;
	}
	function getValkyrieAttackNullificationPolicy(_skill, _attacker)
	{
		if (this.m.Count <= 0 || _skill == null || !_skill.isAttack() || !_skill.m.IsTargetingActor
			|| ("IsAOE" in _skill.m && _skill.m.IsAOE)) return null;
		return { NullifyDirectAttack = true, ConsumeToken = "meltryllis_ballet" };
	}
	function consumeValkyrieAttackNullificationPolicy(_token, _context)
	{
		if (_token == "meltryllis_ballet") this.m.Count = this.Math.max(0, this.m.Count - 1);
	}
	function onTurnStart() { this.removeSelf(); }
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text="$bv{meltryllis.tooltip.evasions}"+this.m.Count}];
	}
});
