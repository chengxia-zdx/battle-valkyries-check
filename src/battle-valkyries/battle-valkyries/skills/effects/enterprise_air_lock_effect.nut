this.enterprise_air_lock_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {OwnerRef=null},
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.IsStacking = true;
		this.m.ID = "$bvvar{modId}.effects.enterprise_air_lock";
		this.m.Name = "$bv{effect.enterprise_air_lock.name}"; this.m.Description = "$bv{effect.enterprise_air_lock.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/enterprise_air_lock.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/enterprise_air_lock_sw.png";
		this.m.IconMini = "status_effect_74_mini";
	}
	function getOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); }
	function getDescription() { return ::$bvvar{namespace}.hasEnterpriseSignatureBow(this.getOwner()) ? "$bv{effect.enterprise_air_lock.signature_description}" : this.m.Description; }
	function onUpdate(_properties)
	{
		local owner = this.getOwner(), state = ::$bvvar{namespace}.getEnterpriseState(owner);
		if (state == null || !state.Active || ::$bvvar{namespace}.isActorDeadOrDying(owner) || !owner.isPlacedOnMap()
			|| ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef) != this.getContainer().getActor()) this.removeSelf();
	}
	function onDeath(_fatalityType)
	{
		local state = ::$bvvar{namespace}.getEnterpriseState(this.getOwner());
		if (state != null && ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef) == this.getContainer().getActor()) state.MarkRef = null;
		this.removeSelf();
	}
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
