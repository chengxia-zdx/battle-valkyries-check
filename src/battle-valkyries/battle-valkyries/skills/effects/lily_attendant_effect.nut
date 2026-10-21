this.lily_attendant_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={Mode="crow",TurnsLeft=4,TriggeredThisTurn=false},
	function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.lily_attendant";this.m.Name="$bv{effect.lily_attendant.name}";this.m.Description="$bv{effect.lily_attendant.description}";this.m.Icon="skills/$bvvar{iconPrefix}/lily_spirit_western_merchant.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/lily_spirit_western_merchant_sw.png";this.m.IconMini<-"status_effect_34_mini";this.m.IsStacking=false;this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;}
	function configure(_mode){this.m.Mode=_mode;this.m.TurnsLeft=4;this.m.TriggeredThisTurn=false;this.m.ID="$bvvar{modId}.effects.lily_attendant_"+_mode;return this;}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function strike(_target,_mult)
	{
		local owner=this.owner();if(owner==null||_target==null||::$bvvar{namespace}.isActorDeadOrDying(owner)||::$bvvar{namespace}.isActorDeadOrDying(_target))return;
		local controller=owner.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));if(controller==null)return;local p=controller.getSpiritPower();::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner,this,_target,this.Math.floor((p.Min+p.Max)*0.5*_mult));controller.onSpiritResolved([_target]);
	}
	function findCrowTarget(_owner)
	{
		local candidates=::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_owner,::$bvvar{namespace}.getValkyrieRadiusTiles(_owner.getTile(),6,true)),best=null,bestDistance=99,bestRatio=2.0;
		foreach(target in candidates)
		{
			if(!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_owner,target,6,true))continue;local distance=_owner.getTile().getDistanceTo(target.getTile()),ratio=1.0;try{ratio=target.getHitpoints().tofloat()/this.Math.max(1,target.getHitpointsMax()).tofloat();}catch(e){}
			if(best==null||distance<bestDistance||distance==bestDistance&&ratio<bestRatio){best=target;bestDistance=distance;bestRatio=ratio;}
		}
		return best;
	}
	function onTurnStart(){this.m.TriggeredThisTurn=false;if(this.m.Mode=="crow"){local owner=this.owner();if(owner!=null)this.strike(this.findCrowTarget(owner),0.50);}}
	function onTargetHit(_skill,_target,_bodyPart,_damageHitpoints,_damageArmor)
	{
		if(this.m.Mode!="maiden"||this.m.TriggeredThisTurn||_target==null||_skill==this||(_damageHitpoints<=0&&_damageArmor<=0))return;this.m.TriggeredThisTurn=true;this.strike(_target,0.60);
	}
	function onTurnEnd(){if(--this.m.TurnsLeft<=0)this.removeSelf();}
});
