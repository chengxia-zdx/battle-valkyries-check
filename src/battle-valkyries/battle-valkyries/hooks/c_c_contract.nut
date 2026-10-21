::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q) {
	q.onTurnStart = @(__original) function()
	{
		local normal=::$bvvar{namespace}.isCCNormalTurn(this);
		this.m.BVCCExtraTurnFrame <- !normal;
		local ret=null;
		try { ret=__original(); }
		catch(e) { this.m.BVCCExtraTurnFrame=false;throw e; }
		if (normal) ::$bvvar{namespace}.advanceCCNormalTurn(this);
		this.m.BVCCExtraTurnFrame=false;
		return ret;
	}
	q.onTurnEnd = @(__original) function()
	{
		this.m.BVCCExtraTurnFrame <- !::$bvvar{namespace}.isCCNormalTurn(this);
		local ret=null;
		try { ret=__original(); }
		catch(e) { this.m.BVCCExtraTurnFrame=false;throw e; }
		this.m.BVCCExtraTurnFrame=false;return ret;
	}
	q.setFaction = @(__original) function(f)
	{
		local ret=__original(f),bv=::$bvvar{namespace},s=bv.getCCState(this);
		local target=s==null?null:bv.readValkyrieCombatWeakRef(s.TargetRef);
		if (target!=null) { target.getSkills().update();target.setDirty(true); }
		if (bv.getCCContract(this)!=null) { this.getSkills().update();this.setDirty(true); }
		return ret;
	}
	q.onRemovedFromMap = @(__original) function()
	{
		local bv=::$bvvar{namespace},effect=bv.getCCContract(this);
		if(effect!=null) bv.clearCCContract(effect.getOwner());
		bv.stopCCCombat(this);
		return __original();
	}
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q) {
	q.onDamageReceived = @(__original) function(attacker,hp,armor)
	{
		local a=this.getActor();
		if (a!=null && "BVSurvivalFrame" in a.m && a.m.BVSurvivalFrame!=null)
			::$bvvar{namespace}.claimCCSurvival(a,hp,a.m.BVSurvivalFrame);
		return __original(attacker,hp,armor);
	}
	// Charm immunity is specific: it does not turn into universal mental immunity.
	q.add = @(__original) function(skill,order=0)
	{
		local a=this.getActor();
		if (skill!=null && skill.getID()=="effects.charmed" && ::$bvvar{namespace}.hasCCImmortality(a))
		{
			if ("Master" in skill.m && skill.m.Master!=null) skill.m.Master.removeSlave(a.getID());
			return;
		}
		return __original(skill,order);
	}
});
::$bvvar{namespace}.MH.hook("scripts/skills/actives/charm_skill",function(q) {
	q.isViableTarget = @(__original) function(user,target)
	{
		return !::$bvvar{namespace}.hasCCImmortality(target) && __original(user,target);
	}
});
