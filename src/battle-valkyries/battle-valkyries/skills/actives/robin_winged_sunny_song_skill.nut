this.robin_winged_sunny_song_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { CooldownRounds = 3, AvailableRound = 0, Heal = 15, FatigueRecovery = 20 },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=false; this.m.IsTargetingActor=false; this.m.IsAttack=false; this.m.IsWeaponSkill=false;
		this.m.IsUsingHitchance=false; this.m.IsIgnoredAsAOO=true; this.m.ActionPointCost=5; this.m.FatigueCost=20;
		this.m.MinRange=0; this.m.MaxRange=0; this.m.AvailableRound=0;
	}
	function onValkyrieSkillBound( _definition )
	{
		if(_definition==null||!("Spec" in _definition))return; local s=_definition.Spec;
		if("ActionPointCost" in s)this.m.ActionPointCost=s.ActionPointCost; if("FatigueCost" in s)this.m.FatigueCost=s.FatigueCost;
		if("CooldownRounds" in s)this.m.CooldownRounds=s.CooldownRounds; if("Heal" in s)this.m.Heal=s.Heal; if("FatigueRecovery" in s)this.m.FatigueRecovery=s.FatigueRecovery;
	}
	function round() { try{return this.Time.getRound();}catch(e){return 0;} }
	function isUsable() { return this.skill.isUsable() && this.round() >= this.m.AvailableRound; }
	function applyEffect( _target, bonusRecovery = 0 )
	{
		local effect=_target.getSkills().getSkillByID(::$bvvar{namespace}.RobinSunnySongID);
		if(effect==null){effect=::new("$bvvar{privateFolder}/skills/effects/robin_sunny_song_effect");_target.getSkills().add(effect);}else effect.onRefresh();
		_target.setHitpoints(this.Math.min(_target.getHitpointsMax(),_target.getHitpoints()+this.m.Heal));
		_target.setFatigue(this.Math.max(0,_target.getFatigue()-this.m.FatigueRecovery-bonusRecovery));
		::$bvvar{namespace}.improveRobinMoraleOneStep(_target); _target.getSkills().update(); _target.setDirty(true);
		try{if(_target.isPlacedOnMap())this.spawnIcon("status_effect_56",_target.getTile());}catch(e){}
	}
	function onUse( _user, _targetTile )
	{
		// Native use has already paid AP/fatigue before onUse; do not check affordability again.
		if(_user==null||::$bvvar{namespace}.isActorDeadOrDying(_user)||this.round()<this.m.AvailableRound)return false;
		local targets=::$bvvar{namespace}.getRobinCombatRoster(_user,true); if(targets.len()==0)return false;
		local bonus=("consumeEncoreMemory" in ::$bvvar{namespace} && ::$bvvar{namespace}.consumeEncoreMemory(_user,"silent_city_robin_breath"))?5:0;
		foreach(actor in targets)this.applyEffect(actor,bonus);
		this.m.AvailableRound=this.round()+this.m.CooldownRounds;
		return true;
	}
	function onCombatStarted(){this.m.AvailableRound=0;}
	function onCombatFinished(){this.m.AvailableRound=0;this.skill.onCombatFinished();}
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/health.png",text="$bv{skill.robin_winged_sunny_song.tooltip.heal}"},{id=5,type="text",icon="ui/icons/fatigue.png",text="$bv{skill.robin_winged_sunny_song.tooltip.recovery}"},{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.robin_winged_sunny_song.tooltip.buff}"},{id=7,type="text",icon="ui/icons/special.png",text="$bv{skill.robin_winged_sunny_song.tooltip.duration}"}];
		if(this.round()<this.m.AvailableRound)ret.push({id=8,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.robin_winged_sunny_song.tooltip.cooldown_prefix}"+(this.m.AvailableRound-this.round())+"$bv{skill.robin_winged_sunny_song.tooltip.cooldown_suffix}"}); return ret;
	}
});
