this.lily_blight_controller_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_runtime_skill", {
	m = { Blight=0, IsBlighted=false, BlightedTurnsLeft=0, TransformationLocked=false, SpiritTriggerSpent=false, PrayerTriggerSpent=false, ResolutionDepth=0, PendingAutoTransform=false, MovedThisTurn=false },
	function create(){this.valkyrie_runtime_skill.create();this.m.Type=this.Const.SkillType.Passive;this.m.IsActive=false;this.m.IsHidden=false;}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function getBlight(){return this.m.Blight;}
	function isBlighted(){return this.m.IsBlighted;}
	function hasMovedThisTurn(){return this.m.MovedThisTurn;}
	function noteVoluntaryDisplacement(){this.m.MovedThisTurn=true;}
	function canTransform(){return !this.m.IsBlighted&&!this.m.TransformationLocked&&this.m.Blight>=3;}
	function getSpiritPower()
	{
		local actor=this.owner(),level=1;try{level=actor.getLevel();}catch(e){}
		local growth=2*this.Math.min(10,this.Math.max(0,level-1)); return {Min=60+growth,Max=80+growth};
	}
	function addBlight( _amount )
	{
		local actor=this.owner();if(_amount<=0||actor==null||::$bvvar{namespace}.isActorDeadOrDying(actor)||this.m.IsBlighted||this.m.TransformationLocked)return false;
		this.m.Blight=this.Math.min(6,this.m.Blight+_amount);
		if(this.m.Blight>=6)
		{
			if(this.m.ResolutionDepth>0)this.m.PendingAutoTransform=true;
			else this.transform(true);
		}
		actor.setDirty(true);
		return true;
	}
	function beginSpiritResolution(){this.m.ResolutionDepth++;}
	function endSpiritResolution()
	{
		this.m.ResolutionDepth=this.Math.max(0,this.m.ResolutionDepth-1);
		if(this.m.ResolutionDepth==0&&this.m.PendingAutoTransform)
		{
			this.m.PendingAutoTransform=false;
			this.transform(true);
		}
	}
	function getDeathBlight( _target )
	{
		try{if("IsMiniboss" in _target.m&&_target.m.IsMiniboss)return 2;}catch(e){}
		try{if(_target.getXPValue()>=200)return 2;}catch(e){}
		return 1;
	}
	function markTarget( _target )
	{
		if(_target==null||::$bvvar{namespace}.isActorDeadOrDying(_target))return;
		local effect=_target.getSkills().getSkillByID("$bvvar{modId}.effects.lily_pending_purification");
		if(effect==null){effect=this.new("$bvvar{privateFolder}/skills/effects/lily_pending_purification_effect");effect.setup(this.owner());_target.getSkills().add(effect);}else{effect.setup(this.owner());effect.onRefresh();}
	}
	function onSpiritResolved( _targets )
	{
		local any=false;foreach(target in _targets){if(target==null)continue;this.markTarget(target);any=true;}
		if(any&&!this.m.SpiritTriggerSpent)
		{
			this.m.SpiritTriggerSpent=true;
			this.addBlight(1);
		}
		return any;
	}
	function onPrayerResolved( _effective )
	{
		if(_effective&&!this.m.PrayerTriggerSpent){this.m.PrayerTriggerSpent=true;this.addBlight(1);}
	}
	function transform( _automatic=false )
	{
		local actor=this.owner();if(!this.canTransform()||actor==null||::$bvvar{namespace}.isActorDeadOrDying(actor))return false;
		this.m.IsBlighted=true;this.m.BlightedTurnsLeft=3;
		::$bvvar{namespace}.setActorTemporaryValkyrieSkin(actor,"lily_blighted_skin");
		if(_automatic)actor.setActionPoints(this.Math.min(actor.getActionPointsMax(),actor.getActionPoints()+3));
		actor.getSkills().update();actor.setDirty(true);return true;
	}
	function finishTransformation()
	{
		local actor=this.owner();this.m.IsBlighted=false;this.m.BlightedTurnsLeft=0;this.m.Blight=0;this.m.TransformationLocked=true;
		if(actor!=null){::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(actor);actor.getSkills().update();actor.setDirty(true);}
	}
	function onUpdate( _properties )
	{
		if(!this.m.IsBlighted)return;_properties.MeleeSkill+=15;_properties.RangedSkill+=15;_properties.DamageTotalMult*=1.30;_properties.DamageDirectAdd+=0.20;
	}
	function onTargetKilled( _target, _skill )
	{
		local actor=this.owner();if(actor==null||_target==null||_target.isAlliedWith(actor)||::$bvvar{namespace}.isActorDeadOrDying(actor))return;
		local record=::$bvvar{namespace}.getLilySpiritRecord(actor);if(record!=null)record.recordPurificationCredit(_target,true);
		// A previously marked enemy awards its death blight through the mark effect;
		// an enemy killed by the resolving spirit has no mark yet and is handled here.
		local marked=null;try{marked=_target.getSkills().getSkillByID("$bvvar{modId}.effects.lily_pending_purification");}catch(e){}
		if(marked==null)this.addBlight(this.getDeathBlight(_target));
	}
	function onTurnStart(){this.m.SpiritTriggerSpent=false;this.m.PrayerTriggerSpent=false;this.m.MovedThisTurn=false;}
	function onMovementFinished()
	{
		local actor=this.owner();if(actor==null)return;
		try{if(actor.m.CurrentMovementType!=this.Const.Tactical.MovementType.Involuntary)this.m.MovedThisTurn=true;}catch(e){this.m.MovedThisTurn=true;}
	}
	function onTurnEnd()
	{
		if(!this.m.IsBlighted)return; this.m.BlightedTurnsLeft--;
		if(this.m.BlightedTurnsLeft<=0){local c=this.getContainer(),s=c==null?null:c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_final_purification"));if(s!=null&&"performPurification" in s)s.performPurification(this.owner());}
	}
	function resetCombatState(){this.m.Blight=0;this.m.IsBlighted=false;this.m.BlightedTurnsLeft=0;this.m.TransformationLocked=false;this.m.SpiritTriggerSpent=false;this.m.PrayerTriggerSpent=false;this.m.ResolutionDepth=0;this.m.PendingAutoTransform=false;this.m.MovedThisTurn=false;local a=this.owner();if(a!=null&&"clearActorTemporaryValkyrieSkin" in ::$bvvar{namespace})::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(a);}
	function onCombatStarted(){this.resetCombatState();}
	function onCombatFinished(){this.resetCombatState();this.skill.onCombatFinished();}
	function onDeath( _fatalityType ){this.resetCombatState();}
	function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{skill.lily_blight_controller.tooltip.blight}"+this.m.Blight+" / 6"},{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.lily_blight_controller.tooltip.power}"}];}
});
