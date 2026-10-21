this.lily_prayer_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m={UsesSpent=0},
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=false;this.m.IsAttack=false;this.m.ActionPointCost=4;this.m.FatigueCost=20;}
	function controller(){local c=this.getContainer();return c==null?null:c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));}
	function isUsable(){return this.skill.isUsable()&&this.m.UsesSpent<3;}
	function cleanse( _actor ){local s=_actor.getSkills();foreach(id in ["effects.bleeding","effects.goblin_poison"])while(s.hasSkill(id))s.removeByID(id);}
	function onUse( _user, _targetTile )
	{
		if(_user==null||!this.isUsable())return false;this.m.UsesSpent++;local effective=false,controller=this.controller();
		foreach(tile in ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(),2,true))if(tile.IsOccupiedByActor)
		{
			local ally=tile.getEntity();if(ally==null||!ally.isAlliedWith(_user)||::$bvvar{namespace}.isActorDeadOrDying(ally))continue;
			local amount=15+this.Math.floor(ally.getHitpointsMax()*0.15);if(controller!=null&&controller.isBlighted())amount=this.Math.floor(amount*1.25);
			local before=ally.getHitpoints();ally.setHitpoints(this.Math.min(ally.getHitpointsMax(),before+amount));this.cleanse(ally);if(ally.getHitpoints()>before)effective=true;ally.setDirty(true);
		}
		if(controller!=null)controller.onPrayerResolved(effective);return true;
	}
	function onCombatStarted(){this.m.UsesSpent=0;}
	function onCombatFinished(){this.m.UsesSpent=0;this.skill.onCombatFinished();}
	function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/heal.png",text="$bv{skill.lily_prayer.tooltip}"}];}
});
