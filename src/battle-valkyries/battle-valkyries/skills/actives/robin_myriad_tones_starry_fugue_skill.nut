this.robin_myriad_tones_starry_fugue_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { HarmonyCost=12, APRecovery=4, FatigueRecovery=20, HealPercent=0.20, Used=false },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=false;this.m.IsTargetingActor=false;this.m.IsAttack=false;this.m.IsWeaponSkill=false;this.m.IsUsingHitchance=false;this.m.IsIgnoredAsAOO=true;
		this.m.ActionPointCost=9;this.m.FatigueCost=35;this.m.MinRange=0;this.m.MaxRange=0;this.m.Used=false;
	}
	function onValkyrieSkillBound( _definition )
	{
		if(_definition==null||!("Spec" in _definition))return;local s=_definition.Spec;
		if("ActionPointCost" in s)this.m.ActionPointCost=s.ActionPointCost;if("FatigueCost" in s)this.m.FatigueCost=s.FatigueCost;if("HarmonyCost" in s)this.m.HarmonyCost=s.HarmonyCost;
		if("APRecovery" in s)this.m.APRecovery=s.APRecovery;if("FatigueRecovery" in s)this.m.FatigueRecovery=s.FatigueRecovery;if("HealPercent" in s)this.m.HealPercent=s.HealPercent;
	}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function passive(){return ::$bvvar{namespace}.getRobinPassive(this.owner());}
	function isUsable(){local p=this.passive();return this.skill.isUsable()&&!this.m.Used&&p!=null&&p.getHarmony()>=this.m.HarmonyCost;}
	function addConcerto( _user, _target )
	{
		local existing=_target.getSkills().getSkillByID(::$bvvar{namespace}.RobinConcertoID);if(existing!=null)_target.getSkills().remove(existing);
		local effect=::new("$bvvar{privateFolder}/skills/effects/robin_starry_concerto_effect");effect.setupOwner(_user);_target.getSkills().add(effect);
	}
	function onUse( _user, _targetTile )
	{
		if(_user==null||!this.isUsable())return false;local p=this.passive();local targets=::$bvvar{namespace}.getRobinCombatRoster(_user,false);
		if(p==null||!p.consumeHarmony(this.m.HarmonyCost))return false;this.m.Used=true;p.beginConcerto(targets.len());
		foreach(target in targets)
		{
			local acted=::$bvvar{namespace}.hasRobinFinishedTurn(target);
			target.setFatigue(this.Math.max(0,target.getFatigue()-this.m.FatigueRecovery));
			target.setHitpoints(this.Math.min(target.getHitpointsMax(),target.getHitpoints()+this.Math.floor(target.getHitpointsMax()*this.m.HealPercent)));
			this.addConcerto(_user,target);::$bvvar{namespace}.addRobinGrantedAction(target,this.m.APRecovery,true,acted);
			target.getSkills().update();target.setDirty(true);
			try{if(target.isPlacedOnMap())this.spawnIcon("status_effect_56",target.getTile());}catch(e){}
		}
		if(targets.len()==0)p.beginConcerto(0);
		_user.setActionPoints(0);_user.setDirty(true);return true;
	}
	function onCombatStarted(){this.m.Used=false;}
	function onCombatFinished(){this.m.Used=false;this.skill.onCombatFinished();}
	function getTooltip()
	{
		local p=this.passive();local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/action_points.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.ap}"},{id=5,type="text",icon="ui/icons/health.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.recovery}"},{id=6,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.concerto}"},{id=7,type="text",icon="ui/icons/direct_damage.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.echo}"},{id=8,type="text",icon="ui/icons/special.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.harmony_prefix}"+(p==null?0:p.getHarmony())+"/12$bv{skill.robin_myriad_tones_starry_fugue.tooltip.harmony_suffix}"}];
		if(this.m.Used)ret.push({id=9,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.robin_myriad_tones_starry_fugue.tooltip.spent}"});return ret;
	}
});
