this.togawa_sakiko_full_moon_dance_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create() {
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=false; this.m.IsTargetingActor=false; this.m.IsAttack=false; this.m.IsWeaponSkill=false;
		this.m.IsUsingHitchance=false; this.m.IsIgnoredAsAOO=true;
		this.m.ActionPointCost=2; this.m.FatigueCost=10; this.m.MinRange=0; this.m.MaxRange=0;
	}
	function passive() { return this.getContainer()==null ? null : ::$bvvar{namespace}.getSakikoPassive(this.getContainer().getActor()); }
	function getActionPointCost() {
		local cost=this.skill.getActionPointCost(), actor=this.getContainer()==null?null:this.getContainer().getActor();
		return ("encoreMemoryAvailable" in ::$bvvar{namespace} && ::$bvvar{namespace}.encoreMemoryAvailable(actor,"silent_city_sakiko_entry"))?this.Math.max(0,cost-1):cost;
	}
	function isUsable() {
		local p=this.passive();
		return this.skill.isUsable() && p!=null && p.m.BattleActive && p.m.LastSwitchRound!=::$bvvar{namespace}.sakikoRound();
	}
	function getIcon() {
		local p=this.passive();
		return "skills/$bvvar{iconPrefix}/togawa_sakiko_"+(p!=null&&p.m.Organ?"organ_mode":"full_moon_dance")+".png";
	}
	function getIconDisabled() {
		local p=this.passive();
		return "skills/$bvvar{iconPrefix}/togawa_sakiko_"+(p!=null&&p.m.Organ?"organ_mode":"full_moon_dance")+"_sw.png";
	}
	function onUse(user,tile) {
		local p=this.passive(); if(p==null || !p.m.BattleActive || p.m.LastSwitchRound==::$bvvar{namespace}.sakikoRound() || !::$bvvar{namespace}.sakikoAlive(user))return false;
		if("consumeEncoreMemory" in ::$bvvar{namespace})::$bvvar{namespace}.consumeEncoreMemory(user,"silent_city_sakiko_entry");
		p.m.Organ=!p.m.Organ; p.m.LastSwitchRound=::$bvvar{namespace}.sakikoRound(); p.syncRecipients();
		::$bvvar{namespace}.playValkyrieVisual(this,user,"sakiko_stage");
		::$bvvar{namespace}.playValkyrieVisual(this,user,p.m.Organ?"sakiko_organ":"sakiko_piano");
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace})
			::$bvvar{namespace}.playValkyrieSkillAudio(user,p.m.Organ?"togawa_sakiko_full_moon_dance_organ":"togawa_sakiko_full_moon_dance_piano");
		user.setDirty(true); return true;
	}
	function getTooltip() {
		local p=this.passive();
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()}, {id=4,type="text",icon="ui/icons/special.png",text=p!=null&&p.m.Organ?"$bv{sakiko.organ}":"$bv{sakiko.piano}"}];
	}
});
