this.saber_strike_air_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Spec = null },
	function create()
	{
		this.valkyrie_active_skill.create(); this.m.IsTargeted=true; this.m.IsTargetingActor=true; this.m.IsAttack=false; this.m.IsWeaponSkill=true;
		this.m.ActionPointCost=4; this.m.FatigueCost=20; this.m.MinRange=1; this.m.MaxRange=4;
	}
	function onValkyrieSkillBound( _definition ) { this.m.Spec=_definition.Spec; this.m.ActionPointCost=this.m.Spec.ActionPointCost; this.m.FatigueCost=this.m.Spec.FatigueCost; this.m.MinRange=this.m.Spec.MinRange; this.m.MaxRange=this.m.Spec.MaxRange; }
	function getManaEffect() { local c=this.getContainer(); return c==null?null:c.getSkillByID("$bvvar{modId}.effects.saber_mana"); }
	function hasMeleeWeapon() { local a=this.getContainer()==null?null:this.getContainer().getActor(); if(a==null||a.getItems()==null)return false; local w=a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); return w!=null&&w.isItemType(this.Const.Items.ItemType.MeleeWeapon); }
	function getManaCost() { return "hasSaberBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberBondUpgrade(this.getContainer().getActor(),80) ? 1 : 2; }
    function isUsable() { local e=this.getManaEffect(); return this.skill.isUsable()&&e!=null&&e.getCount()>=this.getManaCost()&&this.hasMeleeWeapon(); }
	function onVerifyTarget( _originTile, _targetTile )
	{
		if(!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null||!_targetTile.IsOccupiedByActor)return false;
		local a=this.getContainer()==null?null:this.getContainer().getActor(); local t=_targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(a,t,this.m.MaxRange,true)&&a.getTile().getDistanceTo(t.getTile())>=this.m.MinRange&&::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(a.getTile(),t.getTile()).len()>0;
	}
	function getTargets( _user, _targetTile ) { local tiles=::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(_user.getTile(),_targetTile); return ::$bvvar{namespace}.sortValkyrieTargetsByDistance(_user.getTile(),::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,tiles),true); }
	function isOwnWeaponAttack( _skill, _target ) { local a=this.getContainer()==null?null:this.getContainer().getActor(); local p=::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(a,_skill,_target); return p!=null&&"SourceSkillRef" in p&&::$bvvar{namespace}.readValkyrieCombatWeakRef(p.SourceSkillRef)==this; }
	function onAnySkillUsed( _skill,_target,_properties ) { if(_properties!=null&&this.isOwnWeaponAttack(_skill,_target))_properties.MeleeSkill+=this.m.Spec==null?25:this.m.Spec.HitChance; }
	function pushAndDaze( _user, _target )
	{
		if(_target==null||::$bvvar{namespace}.isActorDeadOrDying(_target))return;
		::$bvvar{namespace}.addOrRefreshStatus(_user,_target,{Type="dazed",Turns=1});
		if(_target.getCurrentProperties().IsImmuneToKnockBackAndGrab)return;
		local from=_target.getTile(); local dir=_user.getTile().getDirectionTo(from); local destination=null; local cursor=from;
		for(local i=0;i<2;i++){if(!cursor.hasNextTile(dir))break;local next=cursor.getNextTile(dir);if(!next.IsEmpty||next.Level-cursor.Level>1)break;destination=next;cursor=next;}
		if(destination!=null)this.Tactical.State.handleInvoluntaryMovement(_target,_user,from,destination,this,null,null);
	}
	function getTooltip(){local r=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.saber_strike_air.tooltip.hit}"},{id=5,type="text",icon="ui/icons/armor_damage.png",text="$bv{skill.saber_strike_air.tooltip.damage}"},{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.saber_strike_air.tooltip.control}"}];r.push({id=10,type="text",icon="ui/icons/fatigue.png",text="$bv{skill.saber_strike_air.mana_cost}"+this.getManaCost()});local e=this.getManaEffect();if(e==null||e.getCount()<this.getManaCost())r.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.saber_strike_air.tooltip.not_ready}"});return r;}
	function onUse( _user, _targetTile )
	{
		local e=this.getManaEffect(); if(_user==null||_targetTile==null||e==null||e.getCount()<this.getManaCost()||!this.hasMeleeWeapon())return false;
		local targets=this.getTargets(_user,_targetTile); if(targets.len()==0)return false; e.setCount(e.getCount()-this.getManaCost());
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "saber_strike_air_cast");
		if ("playSaberLineVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playSaberLineVisual(this,_user,_targetTile,false);
        foreach(t in targets){if(::$bvvar{namespace}.isActorDeadOrDying(_user))break;if(::$bvvar{namespace}.isActorDeadOrDying(t))continue;local result=::$bvvar{namespace}.applyValkyrieWeaponAttack(_user,this,t,{WeaponDamageMult=1.0,ArmorDamageMult=2.0,DirectDamageAdd=0.0,IgnoreDistance=true,IgnoreShield=true});if(result!=null&&result.Hit&&!::$bvvar{namespace}.isActorDeadOrDying(t))this.pushAndDaze(_user,t);}
		return true;
	}
	function onCombatFinished() { this.skill.onCombatFinished(); }
});
