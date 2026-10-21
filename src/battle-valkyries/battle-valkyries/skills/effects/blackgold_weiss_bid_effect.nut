this.blackgold_weiss_bid_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.blackgold_weiss_bid";
		this.m.Name = "$bv{chapter.blackgold.bid.name}"; this.m.Description = "$bv{chapter.blackgold.bid.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/weiss_bid.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/weiss_bid_sw.png";
	},
	function isBidActive()
	{
		local bv = ::$bvvar{namespace}, owner = bv.readValkyrieCombatWeakRef(this.m.OwnerRef), target = this.getContainer().getActor();
		return !this.m.IsGarbage && !bv.isActorDeadOrDying(owner) && !bv.isActorDeadOrDying(target)
			&& owner.isPlacedOnMap() && target.isPlacedOnMap() && !owner.isAlliedWithPlayer() && !target.isAlliedWithPlayer() && owner.getFaction() == target.getFaction();
	},
	function onUpdate(properties) { if (!this.isBidActive()) this.removeSelf(); },
	function onAnySkillUsed(skill, target, properties)
	{
		if (this.isBidActive() && skill != null && skill.isAttack() && skill.m.IsWeaponSkill) properties.DamageTotalMult *= 1.2;
	},
	function onDeath(fatality) { this.removeSelf(); },
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
