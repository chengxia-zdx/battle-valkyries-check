this.meltryllis_virus_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft = 2, TurnStarted = false },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.meltryllis_virus";
		this.m.Name = "$bv{effect.meltryllis_virus.name}"; this.m.Description = "$bv{effect.meltryllis_virus.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/meltryllis_melt_virus.png"; this.m.IconMini = "status_effect_34_mini";
		this.m.IsStacking = false;
	}
	function onRefresh() { this.m.TurnsLeft = 2; this.m.TurnStarted = false; }
	function onUpdate(_properties) { _properties.Initiative -= 20; }
	function onAnySkillUsed(_skill, _target, _properties)
	{
		if (_skill != null && _skill.isAttack()) _properties.DamageTotalMult *= 0.80;
	}
	function onTurnStart() { this.m.TurnStarted = true; }
	function onTurnEnd()
	{
		// A global round-end callback or a turn already completed before application does not count.
		if (!this.m.TurnStarted) return;
		this.m.TurnStarted = false;
		if (--this.m.TurnsLeft <= 0) this.removeSelf();
	}
});
