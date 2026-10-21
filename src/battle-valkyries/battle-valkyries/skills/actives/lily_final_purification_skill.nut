this.lily_final_purification_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=false;this.m.IsAttack=true;this.m.IsRanged=true;this.m.ActionPointCost=0;this.m.FatigueCost=0;}
	function controller(){local c=this.getContainer();return c==null?null:c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));}
	function isHidden(){local c=this.controller();return c==null||!c.isBlighted();}
	function isUsable(){local c=this.controller();return this.skill.isUsable()&&c!=null&&c.isBlighted();}
	function cleanse( _actor ){local s=_actor.getSkills();foreach(id in ["effects.bleeding","effects.goblin_poison"])while(s.hasSkill(id))s.removeByID(id);}
	function performPurification( _user )
	{
		local c=this.controller();if(_user==null||c==null||!c.isBlighted()||::$bvvar{namespace}.isActorDeadOrDying(_user))return false;
		local power=c.getSpiritPower(),amount=this.Math.floor((power.Min+power.Max)/2),tiles=::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(),2,true);
		foreach(tile in tiles)if(tile.IsOccupiedByActor)
		{
			local target=tile.getEntity();if(target==null||::$bvvar{namespace}.isActorDeadOrDying(target))continue;
			if(target.isAlliedWith(_user)){local ratio=target==_user?0.25:0.15;target.setHitpoints(this.Math.min(target.getHitpointsMax(),target.getHitpoints()+this.Math.floor(target.getHitpointsMax()*ratio)));this.cleanse(target);target.setDirty(true);}
			else{::$bvvar{namespace}.applyValkyrieFixedArmorDamage(_user,this,target,this.Const.BodyPart.Body,amount*2);if(!::$bvvar{namespace}.isActorDeadOrDying(target))::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user,this,target,this.Math.floor(amount*0.5));if(!::$bvvar{namespace}.isActorDeadOrDying(target))::$bvvar{namespace}.addOrRefreshStatus(_user,target,{Type="staggered",Turns=1});}
		}
		c.finishTransformation();return true;
	}
	function onUse(_user,_targetTile){return this.performPurification(_user);}
});
