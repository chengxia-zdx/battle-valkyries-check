this.lily_spirit_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m={Spec=null,UsesSpent=0,UsesThisTurn=0,CurrentDamageMult=1.0,IsCurrentAttack=false,SlotIndex=0,FirstKillSpent=false,CurrentPrimary=null,CurrentStationaryBonus=false,KillStepGranted=false},
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsAttack=true;this.m.IsWeaponSkill=false;this.m.IsShieldRelevant=true;this.m.IsIgnoredAsAOO=true;}
	function onValkyrieSkillBound(_definition)
	{
		this.m.Spec=_definition.Spec;local s=this.m.Spec;this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.MinRange;this.m.MaxRange=s.MaxRange;this.m.MaxRangeBonus=0;
		this.m.IsRanged=s.Key=="dark_witch_eleine"||s.Key=="hoenir"||s.Key=="faden"||s.Type=="sub"&&s.MinRange>=2;
		this.m.IsTargeted=s.Shape!="self"&&s.Shape!="adjacent";this.m.IsTargetingActor=this.m.IsTargeted&&!this.hasTag("dash")&&!this.hasTag("leap");this.m.HitChanceBonus=s.Hit;this.m.DirectDamageMult=s.Direct;
		if(this.hasTag("ignore_shield"))this.m.IsShieldRelevant=false;
	}
	function setLilySlotIndex(_index){this.m.SlotIndex=_index;this.m.Order=::$bvvar{namespace}.getValkyrieActiveSkillOrder()+10+_index;}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function controller(){local c=this.getContainer();return c==null?null:c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));}
	function hasTag(_tag){foreach(tag in this.m.Spec.Tags)if(tag==_tag)return true;return false;}
	function getMaxUses(){return "Uses" in this.m.Spec?this.m.Spec.Uses:999;}
	function isUsable(){local limit=this.hasTag("twice_per_turn")?2:(this.hasTag("once_per_turn")?1:999);return this.skill.isUsable()&&this.m.UsesSpent<this.getMaxUses()&&this.m.UsesThisTurn<limit;}
	function onVerifyTarget(_originTile,_targetTile)
	{
		if(!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null)return false;if(!this.m.IsTargeted)return true;
		if(this.hasTag("dash")||this.hasTag("leap"))
		{
			if(!_targetTile.IsEmpty)return false;local distance=_originTile.getDistanceTo(_targetTile);if(distance<this.m.MinRange||distance>this.m.MaxRange||this.Math.abs(_targetTile.Level-_originTile.Level)>1)return false;
			if(this.hasTag("dash")){local line=::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(_originTile,_targetTile);if(line.len()!=distance)return false;local cursor=_originTile;foreach(tile in line){if(this.Math.abs(tile.Level-cursor.Level)>1)return false;cursor=tile;}}
			return true;
		}
		if(!_targetTile.IsOccupiedByActor)return false;
		local owner=this.owner(),target=_targetTile.getEntity(),distance=_originTile.getDistanceTo(_targetTile);
		if(this.hasTag("teleport_behind")&&this.getExecutionDestination(owner,target)==null)return false;
		return distance>=this.m.MinRange&&distance<=this.m.MaxRange&&::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner,target,this.m.MaxRange,true);
	}
	function getExecutionDestination(_user,_target)
	{
		if(_user==null||_target==null)return null;local origin=_user.getTile(),targetTile=_target.getTile(),direction=origin.getDirectionTo(targetTile);
		if(!targetTile.hasNextTile(direction))return null;local tile=targetTile.getNextTile(direction);
		return tile.IsEmpty&&this.Math.abs(tile.Level-targetTile.Level)<=1?tile:null;
	}
	function onAnySkillUsed(_skill,_target,_properties)
	{
		if(_skill!=this||!this.m.IsCurrentAttack)return;local c=this.controller();if(c==null)return;local p=c.getSpiritPower();
		_properties.DamageRegularMin=p.Min;_properties.DamageRegularMax=p.Max;_properties.DamageRegularMult=this.m.CurrentDamageMult;_properties.DamageArmorMult=this.m.Spec.Armor;
		_properties.DamageDirectAdd=this.m.Spec.Direct+(c.isBlighted()?0.20:0.00);_properties.DamageDirectMeleeAdd=0;_properties.DamageDirectRangedAdd=0;_properties.DamageDirectMult=1.0;
		_properties.MeleeSkill+=this.m.Spec.Hit;_properties.RangedSkill+=this.m.Spec.Hit;if(this.hasTag("ignore_distance")){_properties.DamageAdditionalWithEachTile=0;_properties.HitChanceAdditionalWithEachTile=0;}
	}
	function getTargets(_user,_tile)
	{
		local shape=this.m.Spec.Shape,tiles=[];
		if(shape=="adjacent")tiles=::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(),1,false);
		else if(shape=="line")tiles=::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(_user.getTile(),_tile);
		else if(shape=="radius1")tiles=::$bvvar{namespace}.getValkyrieRadiusTiles(_tile,1,true);
		else if(shape=="radius2")tiles=::$bvvar{namespace}.getValkyrieRadiusTiles(_tile,2,true);
		else if(shape=="single")tiles=[_tile];
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,tiles);
	}
	function applySupport(_user)
	{
		if(this.hasTag("front_guard")||this.hasTag("all_guard")){local old=_user.getSkills().getSkillByID("$bvvar{modId}.effects.lily_guard");if(old!=null)_user.getSkills().remove(old);local e=this.new("$bvvar{privateFolder}/skills/effects/lily_guard_effect");e.configure(this.hasTag("front_guard")?"front":"all",this.hasTag("front_guard")?1.40:1.00);_user.getSkills().add(e);return true;}
		if(this.hasTag("crow")||this.hasTag("maiden_followup")){local mode=this.hasTag("crow")?"crow":"maiden",id="$bvvar{modId}.effects.lily_attendant_"+mode,old=_user.getSkills().getSkillByID(id);if(old!=null)_user.getSkills().remove(old);local e=this.new("$bvvar{privateFolder}/skills/effects/lily_attendant_effect");e.configure(mode);_user.getSkills().add(e);return true;}
		return false;
	}
	function knockBack(_user,_target)
	{
		if(_user==null||_target==null||_target.getCurrentProperties().IsImmuneToKnockBackAndGrab)return;
		local from=_target.getTile(),direction=_user.getTile().getDirectionTo(from);if(!from.hasNextTile(direction))return;local destination=from.getNextTile(direction);
		if(!destination.IsEmpty||this.Math.abs(destination.Level-from.Level)>1)return;
		_target.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);this.Tactical.State.handleInvoluntaryMovement(_target,_user,from,destination,this,null,null);
	}
	function applyOnHit(_user,_target,_primary,_armorBroken)
	{
		if(this.hasTag("root_or_ap"))
		{
			local p=_target.getCurrentProperties();if(!p.IsImmuneToRoot&&!p.IsRooted)::$bvvar{namespace}.addOrRefreshStatus(_user,_target,{Type="web",Turns=1});
			else{_target.setActionPoints(this.Math.max(0,_target.getActionPoints()-3));if(!p.IsImmuneToStun)::$bvvar{namespace}.addOrRefreshStatus(_user,_target,{Type="stunned",Turns=1});}
		}
		else if(this.hasTag("stun")||this.hasTag("main_stun")&&_primary||this.hasTag("stationary_bonus")&&this.m.CurrentStationaryBonus||this.hasTag("armor_break_stun")&&_armorBroken)::$bvvar{namespace}.addOrRefreshStatus(_user,_target,{Type="stunned",Turns=1});
		else if(this.hasTag("stagger")||this.hasTag("main_stun")&&!_primary)::$bvvar{namespace}.addOrRefreshStatus(_user,_target,{Type="staggered",Turns=1});
		if(this.hasTag("fungal_poison")||this.hasTag("fellwyrm_poison")){local kind=this.hasTag("fungal_poison")?"fungal":"fellwyrm",id="$bvvar{modId}.effects.lily_"+kind+"_poison",e=_target.getSkills().getSkillByID(id);if(e==null){e=this.new("$bvvar{privateFolder}/skills/effects/lily_spirit_poison_effect");e.configure(kind,kind=="fungal"?20:30,_user);_target.getSkills().add(e);}else e.onRefresh();}
		if(this.hasTag("bleed")){local e=this.new("scripts/skills/effects/bleeding_effect");_target.getSkills().add(e);}
		if(this.hasTag("knockback"))this.knockBack(_user,_target);
	}
	function attackTarget(_user,_target,_mult,_primary=false)
	{
		if(_target==null||::$bvvar{namespace}.isActorDeadOrDying(_target))return false;local head=0,body=0;try{head=_target.getArmor(this.Const.BodyPart.Head);body=_target.getArmor(this.Const.BodyPart.Body);}catch(e){}
		this.m.CurrentDamageMult=_mult;this.m.IsCurrentAttack=true;local hit=false;try{hit=this.attackEntity(_user,_target,false);}catch(e){this.m.IsCurrentAttack=false;throw e;}this.m.IsCurrentAttack=false;
		local armorBroken=false;try{armorBroken=head>0&&_target.getArmor(this.Const.BodyPart.Head)<=0||body>0&&_target.getArmor(this.Const.BodyPart.Body)<=0;}catch(e){}
		if(hit&&!::$bvvar{namespace}.isActorDeadOrDying(_target))this.applyOnHit(_user,_target,_primary,armorBroken);return hit;
	}
	function resolveMovementSpirit(_user,_targetTile)
	{
		local c=this.controller(),hits=[];if(c!=null)c.beginSpiritResolution();
		local targets=[],strikes=1,mult=this.m.Spec.Damage;
		if(this.hasTag("dash"))targets=::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(_user.getTile(),_targetTile));
		else{targets=::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile,1,true));strikes=2;mult=this.m.Spec.Damage/2.0;}
		try
		{
			foreach(target in targets){local hit=false;for(local i=0;i<strikes;i++)if(this.attackTarget(_user,target,mult))hit=true;if(hit)hits.push(target);}
			if(c!=null)c.noteVoluntaryDisplacement();_user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);this.Tactical.getNavigator().teleport(_user,_targetTile,null,null,false);
			if(c!=null&&hits.len()>0)c.onSpiritResolved(hits);
		}
		catch(e)
		{
			if(c!=null)c.endSpiritResolution();
			throw e;
		}
		if(c!=null)c.endSpiritResolution();return true;
	}
	function onUse(_user,_targetTile)
	{
		if(_user==null||!this.isUsable())return false;this.m.UsesSpent++;this.m.UsesThisTurn++;
		if(this.m.Spec.Shape=="self"){this.applySupport(_user);return true;}
		if(this.hasTag("dash")||this.hasTag("leap"))return this.resolveMovementSpirit(_user,_targetTile);
		if(this.hasTag("teleport_behind"))
		{
			local target=_targetTile.getEntity(),destination=this.getExecutionDestination(_user,target);if(destination==null)return false;local c=this.controller();if(c!=null)c.noteVoluntaryDisplacement();
			_user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);this.Tactical.getNavigator().teleport(_user,destination,null,null,false);
		}
		local tile=this.m.Spec.Shape=="adjacent"?_user.getTile():_targetTile,targets=this.getTargets(_user,tile),hits=[],strikes=this.hasTag("three_projectiles")?3:(this.hasTag("two_hits")?2:1),mult=this.m.Spec.Damage/strikes.tofloat(),c=this.controller();
		this.m.CurrentPrimary=_targetTile!=null&&_targetTile.IsOccupiedByActor?_targetTile.getEntity():null;
		this.m.CurrentStationaryBonus=this.hasTag("stationary_bonus")&&c!=null&&!c.hasMovedThisTurn();if(this.m.CurrentStationaryBonus)mult=2.00/strikes.tofloat();
		if(c!=null)c.beginSpiritResolution();
		try
		{
			foreach(target in targets)
			{
				local hit=false,isPrimary=target==this.m.CurrentPrimary;for(local i=0;i<strikes;i++)if(this.attackTarget(_user,target,mult,isPrimary))hit=true;
				if(hit&&this.hasTag("large_bonus"))
				{
					local large=false;try{large=target.getXPValue()>=200||"IsMiniboss" in target.m&&target.m.IsMiniboss;}catch(e){}
					if(large&&!::$bvvar{namespace}.isActorDeadOrDying(target))this.attackTarget(_user,target,0.60,isPrimary);
				}
				if(hit)hits.push(target);
			}
			if(c!=null&&hits.len()>0)c.onSpiritResolved(hits);
		}
		catch(e)
		{
			if(c!=null)c.endSpiritResolution();
			throw e;
		}
		if(c!=null)c.endSpiritResolution();return true;
	}
	function onTargetKilled(_target,_skill)
	{
		if(!this.m.IsCurrentAttack)return;local a=this.owner();if(a==null)return;
		if(this.hasTag("first_kill_ap")&&!this.m.FirstKillSpent){this.m.FirstKillSpent=true;a.setActionPoints(this.Math.min(a.getActionPointsMax(),a.getActionPoints()+2));}
		if(this.hasTag("kill_step")&&!this.m.KillStepGranted)
		{
			local result=::$bvvar{namespace}.attachTransientSkill(a,"lily_ulv_step",::$bvvar{namespace}.LilyUlvStepOwnerToken);
			if(result.Success)this.m.KillStepGranted=true;
			else ::$bvvar{namespace}.logValkyrieSkillFailure(a,"lily_ulv_step",result.Code,"lily.ulv_step.attach");
		}
	}
	function onTurnStart(){this.m.UsesThisTurn=0;this.m.FirstKillSpent=false;this.m.KillStepGranted=false;}
	function onCombatStarted(){this.m.UsesSpent=0;this.m.UsesThisTurn=0;this.m.FirstKillSpent=false;this.m.KillStepGranted=false;}
	function onCombatFinished(){this.m.UsesSpent=0;this.m.UsesThisTurn=0;this.m.FirstKillSpent=false;this.m.KillStepGranted=false;this.skill.onCombatFinished();}
	function getTooltip(){local uses=this.getMaxUses();return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{lily.spirits.tooltip.power}"},{id=5,type="text",icon="ui/icons/special.png",text=uses>=999?"$bv{lily.spirits.tooltip.main}":"$bv{lily.spirits.tooltip.uses}"+(uses-this.m.UsesSpent)+" / "+uses}];}
});
