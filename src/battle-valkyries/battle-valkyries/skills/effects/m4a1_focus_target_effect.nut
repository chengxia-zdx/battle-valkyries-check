this.m4a1_focus_target_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = false;
		this.m.ID = "$bvvar{modId}.effects.m4a1_focus_target";
		this.m.Name = "$bv{effect.m4a1_focus_target.name}"; this.m.Description = "$bv{effect.m4a1_focus_target.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_focus_target.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/m4a1_focus_target_sw.png";
	}
	function getOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); }
	function onUpdate(_properties)
	{
		local owner = this.getOwner();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()) this.removeSelf();
	}
	function isEligible(_attacker, _skill)
	{
		local owner = this.getOwner();
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()
			|| (_attacker != owner && !::$bvvar{namespace}.isEligibleRosterAlly(owner, _attacker)) || !::$bvvar{namespace}.isDirectAttack(_skill)) return false;
		local state = ::$bvvar{namespace}.getM4A1State(owner);
		if (state == null || !state.Active || ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef) != this.getContainer().getActor()) return false;
		local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_attacker, _skill);
		if (frame == null || frame.Source == null) return true;
		return frame.Source != "dot" && frame.Source != "damage_over_time" && frame.Source != "terrain"
			&& frame.Source != "reflection" && frame.Source.find("fixed") == null;
	}
	function getValkyrieAttackDefensePolicy(_skill)
	{
		local attacker = _skill == null || _skill.getContainer() == null ? null : _skill.getContainer().getActor();
		return this.isEligible(attacker, _skill) ? { HitChanceBonus = 10 } : null;
	}
	function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties)
	{
		if (!this.isEligible(_attacker, _skill)) return;
		_properties.DamageReceivedRegularMult *= 1.15; _properties.DamageReceivedArmorMult *= 1.15;
	}
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}]; }
	function onDeath(_fatalityType) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
});
