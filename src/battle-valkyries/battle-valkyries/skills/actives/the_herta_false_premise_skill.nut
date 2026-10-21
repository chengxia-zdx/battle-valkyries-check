this.the_herta_false_premise_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = false; this.m.IsRanged = true;
		this.m.ActionPointCost = 4; this.m.FatigueCost = 20; this.m.MinRange = 1; this.m.MaxRange = 6; this.m.MaxRangeBonus = 0;
	}
	function getPassive() { local c = this.getContainer(); return c == null ? null : c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("the_herta_optimal_solution")); }
	function state() { return ::$bvvar{namespace}.HertaCombat.state(this.getContainer() == null ? null : this.getContainer().getActor()); }
	function isUsable() { local s=this.state(); return this.skill.isUsable() && s!=null && s.Active && !s.PremiseSpent; }
	function getFatigueCost()
	{
		local a=this.getContainer()==null?null:this.getContainer().getActor(), old=this.m.FatigueCost;
		this.m.FatigueCost = ::$bvvar{namespace}.HertaCombat.staff(a) && ::$bvvar{namespace}.hasHertaBondUpgrade(a,40) ? 15 : 20;
		try { local result=this.skill.getFatigueCost();this.m.FatigueCost=old;return result; }
		catch(e) { this.m.FatigueCost=old;throw e; }
	}
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor, _targetTile.getEntity(), this.m.MaxRange, true);
	}
	function applyPremise( _target )
	{
		local skills = _target.getSkills();
		local effect = skills.getSkillByID("$bvvar{modId}.effects.the_herta_false_premise");
		if (effect == null) skills.add(this.new("$bvvar{privateFolder}/skills/effects/the_herta_false_premise_effect"));
		else effect.refresh();
	}
	function onUse( _user, _targetTile )
	{
		local s=this.state();
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || s==null || !s.Active || s.PremiseSpent || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local targets = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true));
		::$bvvar{namespace}.playValkyrieVisual(this,_user,"the_herta_cast");
		foreach (target in targets) { this.applyPremise(target); ::$bvvar{namespace}.playValkyrieVisual(this,target,"the_herta_query"); }
		local passive = this.getPassive(); if (passive != null) passive.addInspiration(2);
		s.PremiseSpent = true;
		return true;
	}
	function getTooltip()
	{
		return [ { id=1,type="title",text=this.getName() }, { id=2,type="description",text=this.getDescription() }, { id=3,type="text",text=this.getCostString() }, { id=4,type="text",icon="ui/icons/special.png",text="$bv{skill.the_herta_false_premise.tooltip.control}" }, { id=5,type="text",icon="ui/icons/action_points.png",text="$bv{skill.the_herta_false_premise.tooltip.inspiration}" } ];
	}
});
