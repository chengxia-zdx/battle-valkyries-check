this.morgan_timed_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, TurnsLeft = 2, LastTickRound = -2, CountThisTurn = false },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.IsStacking = false;
		this.m.TurnsLeft = 2; this.m.LastTickRound = -2; this.m.CountThisTurn = false;
	}
	function setMorganOwner( _actor ) { this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor); }
	function getMorganOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); }
	function onRefresh() { this.m.TurnsLeft = 2; this.m.CountThisTurn = false; }
	function beginNormalTurn()
	{
		local actor = this.getContainer().getActor();
		if (::$bvvar{namespace}.isActorDeadOrDying(actor)) { this.removeSelf(); return false; }
		if (!::$bvvar{namespace}.isMorganNormalTurn(actor)) return false;
		local round = ::$bvvar{namespace}.getMorganRound();
		if (this.m.LastTickRound == round) return false;
		this.m.LastTickRound = round;
		this.m.CountThisTurn = true;
		return true;
	}
	function onTurnStart() { this.beginNormalTurn(); }
	function onTurnEnd()
	{
		if (!this.m.CountThisTurn || !::$bvvar{namespace}.isMorganNormalTurn(this.getContainer().getActor())) return;
		this.m.CountThisTurn = false;
		if (--this.m.TurnsLeft <= 0) this.removeSelf();
	}
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [ {id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text="$bv{effect.morgan.duration_prefix}"+this.m.TurnsLeft+"$bv{effect.morgan.duration_suffix}"} ];
	}
});
