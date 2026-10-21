this.blackgold_weiss_controller <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { LastRound = -1, Bid = null, Collecting = false },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.blackgold_weiss_controller";
		this.m.Name = "$bv{chapter.blackgold.bid.name}"; this.m.Description = "$bv{chapter.blackgold.bid.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/weiss_bid.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/weiss_bid_sw.png";
	},
	function clearBid() { if (this.m.Bid != null) this.m.Bid.removeSelf(); this.m.Bid = null; },
	function onTurnStart()
	{
		local bv = ::$bvvar{namespace}, owner = this.getContainer().getActor();
		if (bv.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || owner.isAlliedWithPlayer()) { this.clearBid(); return; }
		if (this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound(); this.clearBid();
		if (!this.m.Collecting && owner.getHitpoints() <= owner.getHitpointsMax() * 0.5)
		{
			this.m.Collecting = true; this.m.Name = "$bv{chapter.blackgold.collection.name}"; this.m.Description = "$bv{chapter.blackgold.collection.description}";
			this.m.Icon = "skills/$bvvar{iconPrefix}/weiss_collection.png"; owner.getSkills().update();
			this.m.IconDisabled = "skills/$bvvar{iconPrefix}/weiss_collection_sw.png";
		}
		if (this.m.Collecting || !owner.getCurrentProperties().IsAbleToUseSkills || owner.getMoraleState() == ::Const.MoraleState.Fleeing) return;
		local chosen = null;
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (target in group)
		{
			if (target == owner || bv.isActorDeadOrDying(target) || !target.isPlacedOnMap() || target.isAlliedWithPlayer() || target.getFaction() != owner.getFaction()) continue;
			if (chosen == null || target.getID() < chosen.getID()) chosen = target;
		}
		if (chosen == null) return;
		local bid = this.new("$bvvar{privateFolder}/skills/effects/blackgold_weiss_bid_effect");
		bid.m.OwnerRef = bv.makeValkyrieCombatWeakRef(owner); chosen.getSkills().add(bid); this.m.Bid = bid;
	},
	function onUpdate(properties) { if (this.m.Collecting) properties.MeleeDefense -= 10; },
	function onAnySkillUsed(skill, target, properties)
	{
		if (this.m.Collecting && skill != null && skill.isAttack() && skill.m.IsWeaponSkill) properties.DamageTotalMult *= 1.15;
	},
	function onDeath(fatality) { this.clearBid(); },
	function onCombatFinished() { this.clearBid(); },
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
