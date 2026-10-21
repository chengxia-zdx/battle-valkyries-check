this.togawa_sakiko_crescent_echo_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create() {
		this.valkyrie_active_skill.create();
		this.m.IsTargeted=false; this.m.IsTargetingActor=false; this.m.IsAttack=false; this.m.IsWeaponSkill=false;
		this.m.IsUsingHitchance=false; this.m.IsIgnoredAsAOO=true;
		this.m.ActionPointCost=6; this.m.FatigueCost=30; this.m.MinRange=0; this.m.MaxRange=0;
	}
	function passive() { return this.getContainer()==null ? null : ::$bvvar{namespace}.getSakikoPassive(this.getContainer().getActor()); }
	function isUsable() { local p=this.passive(); return this.skill.isUsable() && p!=null && p.m.BattleActive && p.m.Melody>=6; }
	function onUse(user,tile) {
		if(!this.isUsable() || !::$bvvar{namespace}.sakikoAlive(user))return false;
		local p=this.passive(); p.m.Melody=0; p.syncRecipients();
		::$bvvar{namespace}.playValkyrieVisual(this,user,"sakiko_stage");
		foreach(actor in ::$bvvar{namespace}.sakikoRoster()) {
			if(!::$bvvar{namespace}.sakikoAlive(actor) || !::$bvvar{namespace}.isEligibleRosterAlly(user,actor)
				|| user.getTile().getDistanceTo(actor.getTile())>5)continue;
			local e=actor.getSkills().getSkillByID(::$bvvar{namespace}.SakikoSupportID);
			if(e==null || !e.isOwnedBy(user))continue;
			e.grantFever(); actor.setFatigue(this.Math.max(0,actor.getFatigue()-20));
			if(actor.getMoraleState()<this.Const.MoraleState.Steady)actor.setMoraleState(this.Const.MoraleState.Steady);
			actor.getSkills().update(); actor.setDirty(true);
			::$bvvar{namespace}.playValkyrieVisual(this,actor,"sakiko_fever");
		}
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(user,"togawa_sakiko_crescent_echo_cast");
		user.setDirty(true); return true;
	}
	function getTooltip() {
		local p=this.passive();
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()}, {id=4,type="text",icon="ui/icons/special.png",text="$bv{sakiko.melody}"+(p==null?0:p.m.Melody)+" / 6"}];
	}
});
