this.sword_maiden_holy_binding_judgment_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { CooldownRounds=2, AvailableRound=0 },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=true; this.m.IsTargetingActor=true; this.m.IsAttack=false; this.m.IsWeaponSkill=false;
		this.m.IsRanged=true; this.m.IsUsingHitchance=false; this.m.IsVisibleTileNeeded=true;
		this.m.ActionPointCost=3; this.m.FatigueCost=15; this.m.MinRange=1; this.m.MaxRange=4; this.m.MaxLevelDifference=99;
	}
	function round() { try{return this.Time.getRound();}catch(e){return 0;} }
	function isUsable() { return this.skill.isUsable() && this.round()>=this.m.AvailableRound; }
	function onCombatStarted() { this.m.AvailableRound=0; }
	function onCombatFinished() { this.m.AvailableRound=0; this.skill.onCombatFinished(); }
	function onVerifyTarget( _originTile,_targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null||!_targetTile.IsOccupiedByActor)return false;
		local owner=this.getContainer()==null?null:this.getContainer().getActor(); local target=_targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner,target,this.m.MaxRange,true);
	}
	function onUse( _user,_targetTile )
	{
		if (_user==null||!this.isUsable()||!this.onVerifyTarget(_user.getTile(),_targetTile))return false;
		local target=_targetTile.getEntity(); local goblin=::$bvvar{namespace}.isSwordMaidenGoblin(target);
		local canRoot=true; try{canRoot=!target.getCurrentProperties().IsImmuneToRoot;}catch(e){}
		local effect=target.getSkills().getSkillByID("$bvvar{modId}.effects.sword_maiden_holy_binding");
		if(effect==null){effect=::new("$bvvar{privateFolder}/skills/effects/sword_maiden_holy_binding_effect");effect.setup(_user,goblin,canRoot);target.getSkills().add(effect);}
		else{effect.setup(_user,goblin,canRoot);effect.onRefresh();}
		target.getSkills().update(); target.setDirty(true); this.m.AvailableRound=this.round()+this.m.CooldownRounds;
		try{if(target.isPlacedOnMap())this.spawnIcon("status_effect_111",target.getTile());}catch(e){}
		return true;
	}
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.sword_maiden_holy_binding_judgment.tooltip.debuff}"},
			{id=5,type="text",icon="ui/icons/special.png",text="$bv{skill.sword_maiden_holy_binding_judgment.tooltip.goblin}"},
			{id=6,type="text",icon="ui/icons/asset_money.png",text="$bv{skill.sword_maiden_holy_binding_judgment.tooltip.credit}"}];
		if(this.round()<this.m.AvailableRound)ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.sword_maiden_holy_binding_judgment.tooltip.cooldown_prefix}"+(this.m.AvailableRound-this.round())});
		return ret;
	}
});
