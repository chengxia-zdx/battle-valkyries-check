this.sword_maiden_unseeing_mind_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { FirstAttackSpent = false },

	function create() { this.valkyrie_passive_skill.create(); }

	function isMeleeAttack( _skill )
	{
		if (!::$bvvar{namespace}.isDirectAttack(_skill)) return false;
		try { return !_skill.isRanged(); } catch (e) { return false; }
	}

	function ignoresShieldFor( _usedSkill ) { return this.isMeleeAttack(_usedSkill); }

	function onAnySkillUsed( _skill, _target, _properties )
	{
		if (this.m.FirstAttackSpent || _properties == null || !this.isMeleeAttack(_skill)) return;
		this.m.FirstAttackSpent = true;
		_properties.MeleeSkill += 20;
		_properties.DamageRegularMult *= 1.20;
		_properties.DamageDirectAdd += 0.15;
	}

	function onTurnStart() { this.m.FirstAttackSpent = false; }
	function onCombatStarted() { this.m.FirstAttackSpent = false; }
	function onCombatFinished() { this.m.FirstAttackSpent = false; this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.sword_maiden_unseeing_mind.tooltip.first}" },
			{ id=4, type="text", icon="ui/icons/shield.png", text="$bv{skill.sword_maiden_unseeing_mind.tooltip.shield}" }
		];
	}
});
