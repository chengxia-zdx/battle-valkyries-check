this.robin_encore_for_you_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { HarmonyCost=3, APRecovery=6, HealPercent=0.20, LastUsedRound=-1 },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=true; this.m.IsTargetingActor=true; this.m.IsAttack=false; this.m.IsRanged=true; this.m.IsWeaponSkill=false;
		this.m.IsUsingHitchance=false; this.m.IsIgnoredAsAOO=true; this.m.IsVisibleTileNeeded=false;
		this.m.ActionPointCost=4; this.m.FatigueCost=15; this.m.MinRange=1; this.m.MaxRange=7; this.m.MaxLevelDifference=99;
	}
	function onValkyrieSkillBound( _definition )
	{
		if(_definition==null||!("Spec" in _definition))return; local s=_definition.Spec;
		if("ActionPointCost" in s)this.m.ActionPointCost=s.ActionPointCost;if("FatigueCost" in s)this.m.FatigueCost=s.FatigueCost;
		if("HarmonyCost" in s)this.m.HarmonyCost=s.HarmonyCost;if("MinRange" in s)this.m.MinRange=s.MinRange;if("MaxRange" in s)this.m.MaxRange=s.MaxRange;
		if("APRecovery" in s)this.m.APRecovery=s.APRecovery;if("HealPercent" in s)this.m.HealPercent=s.HealPercent;
	}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function passive(){return ::$bvvar{namespace}.getRobinPassive(this.owner());}
	function round(){try{return this.Time.getRound();}catch(e){return 0;}}
	function isUsable(){local p=this.passive();return this.skill.isUsable()&&p!=null&&p.getHarmony()>=this.m.HarmonyCost&&this.m.LastUsedRound!=this.round();}
	function onVerifyTarget( _originTile, _targetTile )
	{
		if(!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null||!_targetTile.IsOccupiedByActor)return false;
		local user=this.owner();local target=_targetTile.getEntity();
		return user!=null&&target!=null&&target!=user&&::$bvvar{namespace}.isEligibleRosterAlly(user,target)&&!::$bvvar{namespace}.isActorDeadOrDying(target);
	}
	function addEncoreBuff( _target )
	{
		local effect=_target.getSkills().getSkillByID(::$bvvar{namespace}.RobinEncoreID);
		if(effect==null){effect=::new("$bvvar{privateFolder}/skills/effects/robin_encore_protagonist_effect");_target.getSkills().add(effect);}else effect.onRefresh();
	}
	function onUse( _user, _targetTile )
	{
		if(_user==null||!this.isUsable()||!this.onVerifyTarget(_user.getTile(),_targetTile))return false;
		local target=_targetTile.getEntity();local p=this.passive();if(p==null||!p.consumeHarmony(this.m.HarmonyCost))return false;
		local acted=::$bvvar{namespace}.hasRobinFinishedTurn(target);
		target.setFatigue(this.Math.floor(target.getFatigue()*0.5));
		target.setHitpoints(this.Math.min(target.getHitpointsMax(),target.getHitpoints()+this.Math.floor(target.getHitpointsMax()*this.m.HealPercent)));
		::$bvvar{namespace}.cleanseRobinEncoreEffects(target); ::$bvvar{namespace}.improveRobinMoraleOneStep(target); this.addEncoreBuff(target);
		if(acted) ::$bvvar{namespace}.addRobinGrantedAction(target,this.m.APRecovery,false,true);
		else target.setActionPoints(this.Math.min(target.getActionPointsMax(),target.getActionPoints()+this.m.APRecovery));
		target.getSkills().update();target.setDirty(true);this.m.LastUsedRound=this.round();
		try{if(target.isPlacedOnMap())this.spawnIcon("status_effect_34",target.getTile());}catch(e){}
		return true;
	}
	function onCombatStarted(){this.m.LastUsedRound=-1;}
	function onCombatFinished(){this.m.LastUsedRound=-1;this.skill.onCombatFinished();}
	function getTooltip()
	{
		local p=this.passive();local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/action_points.png",text="$bv{skill.robin_encore_for_you.tooltip.restore}"},{id=5,type="text",icon="ui/icons/health.png",text="$bv{skill.robin_encore_for_you.tooltip.heal}"},{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.robin_encore_for_you.tooltip.cleanse}"},{id=7,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.robin_encore_for_you.tooltip.protagonist}"},{id=8,type="text",icon="ui/icons/special.png",text="$bv{skill.robin_encore_for_you.tooltip.harmony_prefix}"+(p==null?0:p.getHarmony())+"/12$bv{skill.robin_encore_for_you.tooltip.harmony_suffix}"}];
		if(this.m.LastUsedRound==this.round())ret.push({id=9,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.robin_encore_for_you.tooltip.round_limit}"});return ret;
	}
});
