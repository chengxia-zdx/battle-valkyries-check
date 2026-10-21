this.sword_maiden_balance_final_judgment_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { IsSpent=false },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString="$bv{skill.sword_maiden_balance_final_judgment.killed}";
		this.m.IsTargeted=true; this.m.IsTargetingActor=true; this.m.IsAttack=true; this.m.IsAOE=true; this.m.IsWeaponSkill=true;
		this.m.IsRanged=true; this.m.IsUsingHitchance=true; this.m.IsVisibleTileNeeded=true;
		this.m.ActionPointCost=6; this.m.FatigueCost=30; this.m.MinRange=1; this.m.MaxRange=4; this.m.MaxLevelDifference=99;
	}
	function isUsable(){return this.skill.isUsable()&&!this.m.IsSpent;}
	function onCombatStarted(){this.m.IsSpent=false;}
	function onCombatFinished(){this.m.IsSpent=false;this.skill.onCombatFinished();}
	function onVerifyTarget(_originTile,_targetTile)
	{
		if(!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null||!_targetTile.IsOccupiedByActor)return false;
		local owner=this.getContainer()==null?null:this.getContainer().getActor();return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner,_targetTile.getEntity(),this.m.MaxRange,true);
	}
	function getTargets(_user,_targetTile){return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile,2,true));}
	function onTargetSelected(_targetTile)
	{
		foreach(target in this.getTargets(this.getContainer().getActor(),_targetTile)){local tile=target.getTile();this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,tile,tile.Pos.X,tile.Pos.Y);}
	}
	function onUse(_user,_targetTile)
	{
		if(_user==null||!this.isUsable()||!this.onVerifyTarget(_user.getTile(),_targetTile))return false;
		this.m.IsSpent=true; local main=_targetTile.getEntity(); local targets=this.getTargets(_user,_targetTile);
		::$bvvar{namespace}.applyValkyrieWeaponAttack(_user,this,main,{WeaponDamageMult=2.50,ArmorDamageMult=1.60,DirectDamageAdd=0.40,HitChance=30,IgnoreDistance=true,IgnoreShield=true,Source="sword_maiden_final_judgment"});
		foreach(target in targets)
		{
			if(::$bvvar{namespace}.isActorDeadOrDying(target))continue;
			local amount=::$bvvar{namespace}.isSwordMaidenGoblin(target)?100:60;
			::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user,this,target,amount,{Source="sword_maiden_final_judgment_fixed",BodyPart=this.Const.BodyPart.Body});
		}
		local killed=false;
		foreach(target in targets)
		{
			if(::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				killed=true;
				break;
			}
		}
		if(killed)
		{
			_user.setActionPoints(_user.getActionPointsMax());
			_user.setDirty(true);
		}
		return true;
	}
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.sword_maiden_balance_final_judgment.tooltip.primary}"},
			{id=5,type="text",icon="ui/icons/direct_damage.png",text="$bv{skill.sword_maiden_balance_final_judgment.tooltip.area}"},
			{id=6,type="text",icon="ui/icons/action_points.png",text="$bv{skill.sword_maiden_balance_final_judgment.tooltip.kill}"}];
		if(this.m.IsSpent) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.sword_maiden_balance_final_judgment.tooltip.spent}"});
		return ret;
	}
});
