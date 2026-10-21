this.meltryllis_sadistic_constitution_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Count = 0, GainTokens = null },
	function create() { this.valkyrie_passive_skill.create(); this.reset(); }
	function reset() { this.m.Count = 0; this.m.GainTokens = {}; }
	function getCount() { return this.m.Count; }
	function getDamageMultiplier() { return 1.0 + 0.10 * this.m.Count; }
	function onUpdate(_properties) { if (this.m.Count > 0) _properties.MeleeDefense -= 5; }
	function onValkyrieCombatEvent(_event)
	{
		if (_event == null || _event.Type != "TargetResolved" || !_event.Hit || _event.Nullified
			|| _event.HitpointDamage + _event.ArmorDamage <= 0 || _event.IsFree
			|| _event.Source != "managed_active" || _event.Attacker != this.getContainer().getActor()) return;
		local key = _event.Skill == null ? null : _event.Skill.getBattleValkyriesSkillKey();
		if (key != "meltryllis_blade_dance" && key != "meltryllis_sarasvati_meltout") return;
		local token = _event.ActionToken;
		if (token == null || token in this.m.GainTokens) return;
		this.m.GainTokens[token] <- true;
		this.m.Count = this.Math.min(3, this.m.Count + 1);
		this.getContainer().update();
	}
	function onTurnStart() { this.reset(); }
	function onCombatStarted() { this.reset(); }
	function onCombatFinished() { this.reset(); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [{ id=1, type="title", text=this.getName() }, { id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{meltryllis.tooltip.stacks}" + this.m.Count + " / 3" }];
	}
});
