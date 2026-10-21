::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q) {
	q.onTurnStart = @(__original) function()
	{
		::$bvvar{namespace}.beginHokusaiTurn(this);
		return __original();
	}
	q.onTurnResumed = @(__original) function()
	{
		local bv=::$bvvar{namespace};
		if (bv.getHokusaiState(this)!=null || this.getSkills().hasSkill(bv.HokusaiInkID))
		{
			local t=bv.getHokusaiTurn(this);
			t.Normal=!bv.isHokusaiExtraTurn(this) && t.EndRound!=::Time.getRound();
		}
		return __original();
	}
	q.onTurnEnd = @(__original) function()
	{
		local bv=::$bvvar{namespace};
		local relevant=bv.getHokusaiState(this)!=null || this.getSkills().hasSkill(bv.HokusaiInkID);
		local normal=relevant && bv.getHokusaiTurn(this).Normal && !bv.isHokusaiExtraTurn(this);
		local ret=__original();
		if (normal) bv.endHokusaiTurn(this,true);
		return ret;
	}
	q.onRemovedFromMap = @(__original) function()
	{
		local bv=::$bvvar{namespace};
		bv.stopHokusaiCombat(this);
		local ink=bv.getHokusaiInk(this);
		if (ink!=null) ink.removeSelf();
		return __original();
	}
	q.checkMorale = @(__original) function(change,difficulty,type=::Const.MoraleCheckType.Default,icon="",noNewLine=false)
	{
		// Vanilla returns false when a negative check succeeds (no morale change).
		if (::$bvvar{namespace}.tryHokusaiMoraleGuard(this,change)) return false;
		return __original(change,difficulty,type,icon,noNewLine);
	}
	q.onOtherActorDeath = @(__original) function(killer,victim,skill)
	{
		local old="BVHokusaiIndirectMorale" in this.m?this.m.BVHokusaiIndirectMorale:0;
		this.m.BVHokusaiIndirectMorale <- old+1;
		local ret=null;
		try { ret=__original(killer,victim,skill); }
		catch(e) { this.m.BVHokusaiIndirectMorale=old;throw e; }
		this.m.BVHokusaiIndirectMorale=old;return ret;
	}
	q.onOtherActorFleeing = @(__original) function(actor)
	{
		local old="BVHokusaiIndirectMorale" in this.m?this.m.BVHokusaiIndirectMorale:0;
		this.m.BVHokusaiIndirectMorale <- old+1;
		local ret=null;
		try { ret=__original(actor); }
		catch(e) { this.m.BVHokusaiIndirectMorale=old;throw e; }
		this.m.BVHokusaiIndirectMorale=old;return ret;
	}
});
