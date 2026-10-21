::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor",function(q) {
	q.onTurnStart = @(__original) function()
	{
		::$bvvar{namespace}.beginAbigailTurn(this);return __original();
	}
	q.onTurnResumed = @(__original) function()
	{
		local bv=::$bvvar{namespace};
		if (bv.hasAbigailState(this))
		{
			local t=bv.getAbigailTurn(this);t.Normal=!bv.isAbigailExtraTurn(this) && t.EndRound!=::Time.getRound();
		}
		return __original();
	}
	q.onTurnEnd = @(__original) function()
	{
		local bv=::$bvvar{namespace},normal=bv.hasAbigailState(this) && bv.getAbigailTurn(this).Normal && !bv.isAbigailExtraTurn(this);
		local ret=__original();if (normal) bv.endAbigailTurn(this);return ret;
	}
	q.onRemovedFromMap = @(__original) function()
	{
		local bv=::$bvvar{namespace};bv.stopAbigailCombat(this);
		foreach(kind,id in bv.AbigailEffectIDs) { local e=bv.getAbigailEffect(this,kind);if(e!=null)e.removeSelf(); }
		return __original();
	}
	q.checkMorale = @(__original) function(change,difficulty,type=::Const.MoraleCheckType.Default,icon="",noNewLine=false)
	{
		local bv=::$bvvar{namespace},s=bv.getAbigailState(this);
		if (change>=0 || s==null || !s.Active || !this.isPlayerControlled() || bv.getActorValkyrieID(this)!="abigail_williams" || bv.isActorDeadOrDying(this))
			return __original(change,difficulty,type,icon,noNewLine);
		local values=this.getCurrentProperties().MoraleCheckBravery,old=values[type];values[type]=old+20;
		local ret=null;
		try { ret=__original(change,difficulty,type,icon,noNewLine); }
		catch(e) { values[type]=old;throw e; }
		values[type]=old;return ret;
	}
});
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container",function(q) {
	q.onTurnStart = @(__original) function()
	{
		local ret=__original();::$bvvar{namespace}.processAbigailTurn(this.getActor());return ret;
	}
});
