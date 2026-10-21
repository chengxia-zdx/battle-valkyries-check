this.sword_maiden_balance_condemnation_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { UsedThisTurn=false, FreeUseSpent=false },

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.sword_maiden_balance_condemnation.killed}";
		this.m.IsTargeted=true; this.m.IsTargetingActor=true; this.m.IsAttack=true; this.m.IsWeaponSkill=true;
		this.m.IsRanged=false; this.m.IsUsingHitchance=true; this.m.IsVisibleTileNeeded=true;
		this.m.ActionPointCost=4; this.m.FatigueCost=18; this.m.MinRange=1; this.m.MaxRange=2; this.m.MaxLevelDifference=99;
	}

	function getActor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
	function hasFinalMilestone() { return ::$bvvar{namespace}.isSwordMaidenMilestoneUnlocked(this.getActor(), 300); }
	function isFreeUse() { return this.hasFinalMilestone() && !this.m.FreeUseSpent; }
	function getActionPointCost() { return this.isFreeUse() ? 0 : this.m.ActionPointCost; }
	function getFatigueCost() { return this.isFreeUse() ? 0 : this.m.FatigueCost; }
	function isUsable() { return this.skill.isUsable() && !this.m.UsedThisTurn; }
	function resetByRootExtermination() { this.m.UsedThisTurn = false; }
	function onTurnStart() { this.m.UsedThisTurn=false; this.m.FreeUseSpent=false; }
	function onCombatStarted() { this.onTurnStart(); }
	function onCombatFinished() { this.onTurnStart(); this.skill.onCombatFinished(); }

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile,_targetTile) || _targetTile==null || !_targetTile.IsOccupiedByActor) return false;
		local owner=this.getActor(); local target=_targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner,target,this.m.MaxRange,true)
			&& owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function onUse( _user, _targetTile )
	{
		if (_user==null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(),_targetTile)) return false;
		local target=_targetTile.getEntity();
		local goblin=::$bvvar{namespace}.isSwordMaidenGoblin(target);
		local finalMilestone=this.hasFinalMilestone();
		local freeUse=finalMilestone && !this.m.FreeUseSpent;
		this.m.UsedThisTurn=true;
		if (freeUse) this.m.FreeUseSpent=true;
		local result=::$bvvar{namespace}.applyValkyrieWeaponAttack(_user,this,target,{
			WeaponDamageMult=(goblin ? 2.10 : 1.60) * (freeUse ? 1.30 : 1.0),
			ArmorDamageMult=1.40,
			DirectDamageAdd=0.25,
			HitChance=20,
			IgnoreDistance=true,
			IgnoreShield=true,
			Source="sword_maiden_condemnation"
		});
		if (finalMilestone && result != null && "Hit" in result && result.Hit) _user.setDirty(true);
		if (result != null && "Hit" in result && result.Hit && ::$bvvar{namespace}.isActorDeadOrDying(target)
			&& !::$bvvar{namespace}.isSwordMaidenMilestoneUnlocked(_user,150))
		{
			_user.setActionPoints(this.Math.min(_user.getActionPointsMax(),_user.getActionPoints()+3));
			_user.setFatigue(this.Math.max(0,_user.getFatigue()-10));
			_user.setDirty(true);
		}
		return true;
	}

	function getTooltip()
	{
		local ret=[
			{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}, {id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.sword_maiden_balance_condemnation.tooltip.hit}"},
			{id=5,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.sword_maiden_balance_condemnation.tooltip.damage}"},
			{id=6,type="text",icon="ui/icons/direct_damage.png",text="$bv{skill.sword_maiden_balance_condemnation.tooltip.goblin}"},
			{id=7,type="text",icon="ui/icons/action_points.png",text="$bv{skill.sword_maiden_balance_condemnation.tooltip.kill}"}
		];
		if (this.m.UsedThisTurn) ret.push({id=8,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.sword_maiden_balance_condemnation.tooltip.used}"});
		return ret;
	}
});
