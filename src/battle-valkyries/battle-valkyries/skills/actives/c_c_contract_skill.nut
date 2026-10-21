// Three non-weapon commands share targeting, state and paid-use validation.
this.c_c_contract_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m={Mode="contract"},
	function create()
	{
		this.valkyrie_active_skill.create(); this.m.IsTargeted=true;this.m.IsTargetingActor=true;
		this.m.IsAttack=false;this.m.IsRanged=false;this.m.IsWeaponSkill=false;this.m.IsUsingHitchance=false;
		this.m.IsVisibleTileNeeded=true;this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;
		this.m.MinRange=1;this.m.MaxRange=4;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=4;
	}
	function onValkyrieSkillBound(d) { this.m.Mode=d.Spec.Mode;this.m.ActionPointCost=d.Spec.AP;this.m.FatigueCost=d.Spec.Fatigue;this.m.MaxRange=d.Spec.Range; }
	function owner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.getContainer().getActor()); }
	function isReady()
	{
		local bv=::$bvvar{namespace},a=this.owner(),s=bv.getCCState(a);
		if (!bv.canCCAct(a)) return false;
		return this.m.Mode=="contract" ? ::Time.getRound()>=s.ContractReady : this.m.Mode=="shock" ? ::Time.getRound()>=s.ShockReady : (!s.OathUsed && s.Seals>=4);
	}
	function isUsable() { return this.skill.isUsable() && this.isReady(); }
	function onVerifyTarget(origin,tile)
	{
		local bv=::$bvvar{namespace},a=this.owner();
		if (origin==null || tile==null || !tile.IsOccupiedByActor || !this.isReady()
			|| !tile.IsVisibleForEntity || !this.skill.onVerifyTarget(origin,tile)
			|| origin.getDistanceTo(tile)<1 || origin.getDistanceTo(tile)>this.m.MaxRange
			|| !origin.hasLineOfSightTo(tile,this.m.MaxRange)) return false;
		local target=tile.getEntity();
		if (!bv.isCCAlive(target) || target.isHiddenToPlayer()) return false;
		if (this.m.Mode=="shock") return !a.isAlliedWith(target) && !bv.isCCMindImmune(target) && !target.getSkills().hasSkill(bv.CCShockID);
		if (!bv.isCCControlled(target) || !bv.isEligibleRosterAlly(a,target)) return false;
		local e=bv.getCCContract(target);
		if (this.m.Mode=="contract") return e==null || !e.isBound();
		return e!=null && e.getOwner()==a && e.isEffective();
	}
	function onUse(user,tile)
	{
		// Vanilla pays AP/fatigue before onUse; do not recheck affordability here.
		local bv=::$bvvar{namespace};
		user=bv.readValkyrieCombatWeakRef(user);
		if (user!=this.owner() || !this.isReady() || !this.onVerifyTarget(user.getTile(),tile)) return false;
		local s=bv.getCCState(user),target=tile.getEntity();
		if (this.m.Mode=="contract")
		{
			bv.clearCCContract(user);
			local old=bv.getCCContract(target);if(old!=null)old.removeSelf();
			local effect=::new("$bvvar{privateFolder}/skills/effects/c_c_contract_effect");
			effect.m.OwnerRef=bv.makeValkyrieCombatWeakRef(user);s.TargetRef=bv.makeValkyrieCombatWeakRef(target);
			target.getSkills().add(effect);s.ContractReady=::Time.getRound()+2;
			bv.playValkyrieVisual(this,target,"c_c_contract_ring");bv.playValkyrieSkillAudio(user,"c_c_contract_cast");
		}
		else if(this.m.Mode=="shock")
		{
			// Resolve the morale check BEFORE adding the -15 Resolve effect.
			target.checkMorale(-1,-10,::Const.MoraleCheckType.MentalAttack);
			target.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/c_c_shock_effect"));s.ShockReady=::Time.getRound()+2;
			bv.playValkyrieVisual(this,target,"c_c_shock_fracture");bv.playValkyrieSkillAudio(user,"c_c_shock_apply",bv.captureValkyrieSkillAudioPosition(target));
		}
		else
		{
			local effect=bv.getCCContract(target);s.Seals-=4;s.OathUsed=true;
			effect.m.OathUntil=::Time.getRound()+2;effect.m.RescueUsed=false;effect.m.Protected=false;
			target.setFatigue(::Math.max(0,target.getFatigue()-20));
			bv.playValkyrieVisual(this,target,"c_c_oath_ward");bv.playValkyrieSkillAudio(user,"c_c_oath_cast");
		}
		target.getSkills().update();target.setDirty(true);user.setDirty(true);return true;
	}
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/special.png",text=::$bvvar{namespace}.getCCStateText(this.owner())}];
		ret.push({id=5,type="text",icon="ui/tooltips/warning.png",text=this.m.Mode=="shock"?"$bv{cc.target.shock}":"$bv{cc.target.contract}"});
		return ret;
	}
});
