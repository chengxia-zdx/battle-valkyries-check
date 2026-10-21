// Actor-owned, epoch-scoped state: rebuilding a managed skill cannot refill it.
::$bvvar{namespace}.CCContractID <- "$bvvar{modId}.effects.c_c_contract";
::$bvvar{namespace}.CCShockID <- "$bvvar{modId}.effects.c_c_shock";
::$bvvar{namespace}.getCCState <- function(a)
{
	local s = a != null && "BVCCCombat" in a.m ? a.m.BVCCCombat : null;
	return s != null && s.Epoch == this.ValkyrieCombatEvents.Epoch ? s : null;
};
::$bvvar{namespace}.isCCAlive <- function(a)
{
	return a != null && !this.isActorDeadOrDying(a) && a.isPlacedOnMap();
};
::$bvvar{namespace}.isCCControlled <- function(a)
{
	return this.isCCAlive(a) && a.isPlayerControlled() && !a.getSkills().hasSkill("effects.charmed");
};
::$bvvar{namespace}.hasCCImmortality <- function(a)
{
	return a != null && this.getActorValkyrieID(a) == "c_c" && this.getRuntimeSkillByKey(a, "c_c_immortal_witch") != null;
};
::$bvvar{namespace}.startCCCombat <- function(a)
{
	if (a == null || this.getActorValkyrieID(a) != "c_c" || !a.isPlayerControlled()) return null;
	local s = this.getCCState(a);
	if (s != null) return s;
	s = {Epoch=this.ValkyrieCombatEvents.Epoch, Active=true, Seals=2, AttackRound=-1, HurtRound=-1,
		ContractReady=0, ShockReady=0, OathUsed=false, GutsUsed=false, Protected=false, APPenalty=false, TargetRef=null};
	a.m.BVCCCombat <- s;
	return s;
};
::$bvvar{namespace}.getCCContract <- function(a)
{
	if (a == null) return null;
	local skills=a.getSkills();
	if (skills==null) return null;
	local e = skills.getSkillByID(this.CCContractID);
	return e != null && !e.isGarbage() ? e : null;
};
::$bvvar{namespace}.clearCCContract <- function(a)
{
	a = this.readValkyrieCombatWeakRef(a);
	local s = this.getCCState(a);
	if (s == null) return;
	local target = this.readValkyrieCombatWeakRef(s.TargetRef);
	s.TargetRef = null;
	local e = this.getCCContract(target);
	if (e != null && e.getOwner() == a)
	{
		e.removeSelf(); target.getSkills().update(); target.setDirty(true);
	}
};
::$bvvar{namespace}.stopCCCombat <- function(a)
{
	this.clearCCContract(a);
	local s = this.getCCState(a);
	if (s != null) { s.Active=false; s.Seals=0; s.Protected=false; s.APPenalty=false; }
};
::$bvvar{namespace}.isCCNormalTurn <- function(a)
{
	if (!this.isCCAlive(a) || a.getSkills().hasSkill("$bvvar{modId}.effects.cerydra_command_turn")) return false;
	if ("BVCCExtraTurnFrame" in a.m && a.m.BVCCExtraTurnFrame) return false;
	local extra = a.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	return extra == null || !extra.m.BVIsExtraTurn;
};
::$bvvar{namespace}.advanceCCNormalTurn <- function(a)
{
	if (!this.isCCNormalTurn(a)) return;
	local epoch = this.ValkyrieCombatEvents.Epoch, round = ::Time.getRound();
	if (!("BVCCNormalTurn" in a.m) || a.m.BVCCNormalTurn.Epoch != epoch)
		a.m.BVCCNormalTurn <- {Epoch=epoch, Round=-1, FatigueRound=-1};
	local turn = a.m.BVCCNormalTurn;
	if (turn.Round == round) return;
	turn.Round = round;
	local s = this.getCCState(a);
	if (s != null && s.Active && this.hasCCImmortality(a))
	{
		s.Protected = false;
		if (s.APPenalty) { a.setActionPoints(::Math.max(0, a.getActionPoints()-4)); s.APPenalty=false; }
		a.setHitpoints(::Math.min(a.getHitpointsMax(), a.getHitpoints()+::Math.max(1, ::Math.floor(a.getHitpointsMax()*8/100.0))));
	}
	local e = this.getCCContract(a);
	if (e != null)
	{
		// The protection timer advances even while charm pauses the contract.
		e.m.Protected = false;
		if (e.isEffective() && turn.FatigueRound != round)
		{
			turn.FatigueRound=round; a.setFatigue(::Math.max(0,a.getFatigue()-10));
		}
	}
	a.setDirty(true);
};
::$bvvar{namespace}.addCCSeal <- function(a)
{
	local s = this.getCCState(a);
	if (s == null || !s.Active || !this.isCCControlled(a)) return;
	local before = s.Seals; s.Seals=::Math.min(6,s.Seals+1);
	if (before < 4 && s.Seals >= 4 && !s.OathUsed)
	{
		this.playValkyrieVisual(this.getRuntimeSkillByKey(a,"c_c_accomplice"),a,"c_c_seal_ready");
		this.playValkyrieSkillAudio(a,"c_c_seal_ready");
	}
	a.setDirty(true);
};
::$bvvar{namespace}.isCCActiveAttackSource <- function(source)
{
	// Positive allowlist: unknown/implicit sources must not amplify free attacks.
	return source == "direct" || source == "managed_active";
};
::$bvvar{namespace}.isCCActiveAttack <- function(a, skill)
{
	if (!this.isDirectAttack(skill)) return false;
	local source = this.getCurrentValkyrieCombatSource(a,skill);
	if (source != null && !this.isCCActiveAttackSource(source.Source)) return false;
	local ctx = this.getCurrentValkyrieActionContext(a,skill);
	return ctx != null && !ctx.IsFree && !ctx.IsImplicit && this.isCCActiveAttackSource(ctx.Source);
};
::$bvvar{namespace}.isCCSealEnemy <- function(a, target)
{
	// TargetResolved can arrive after a lethal hit has released native entity data.
	// Keep valid killing blows, but never query an invalid faction a second time.
	if (a == null || target == null) return false;
	try { return !a.isAlliedWith(target); }
	catch (e) { return false; }
};
::$bvvar{namespace}.onCCCombatEvent <- function(a,e)
{
	a = this.readValkyrieCombatWeakRef(a);
	local s = this.getCCState(a);
	if (s == null || !s.Active || !this.isCCControlled(a) || e == null) return;
	local round = ::Time.getRound();
	if (e.Type == "TargetResolved" && e.Hit && this.isDirectAttack(e.Skill)
		&& this.isCCActiveAttackSource(e.Source) && !e.IsFree && !e.IsImplicit && (e.HitpointDamage > 0 || e.ArmorDamage > 0)
		&& s.AttackRound != round)
	{
		local contract = this.getCCContract(e.Attacker);
		if (contract != null && contract.getOwner() == a && contract.isEffective() && this.isCCSealEnemy(a,e.Target))
		{
			s.AttackRound=round; this.addCCSeal(a);
		}
	}
	if (e.Type == "TargetResolved" && e.Target == a && e.Hit && !e.IsFree && !e.IsImplicit && e.HitpointDamage > 0 && s.HurtRound != round
		&& this.isDirectAttack(e.Skill) && this.isCCActiveAttackSource(e.Source) && this.isCCSealEnemy(a,e.Attacker))
	{
		s.HurtRound=round; this.addCCSeal(a);
	}
};
::$bvvar{namespace}.canCCAct <- function(a)
{
	local s = this.getCCState(a);
	return s != null && s.Active && this.isCCControlled(a) && a.getCurrentProperties().IsAbleToUseSkills
		&& a.getMoraleState() != ::Const.MoraleState.Fleeing;
};
::$bvvar{namespace}.isCCMindImmune <- function(a)
{
	local p = a.getCurrentProperties();
	if (p.MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0) return true;
	foreach (key in ["IsImmuneToMentalAttacks","IsImmuneToMindControl","IsUndead","IsConstruct"])
		if (key in p && p[key]) return true;
	foreach (id in ["racial.skeleton","racial.zombie","racial.ghost","racial.vampire","racial.golem"])
		if (a.getSkills().hasSkill(id)) return true;
	local type = a.getType();
	foreach (key,value in ::Const.EntityType)
		if (value == type && (key.find("Skeleton") == 0 || key.find("Zombie") == 0
			|| key == "Ghost" || key == "Vampire" || key == "Necrosavant" || key == "Golem" || key == "Ifrit")) return true;
	return false;
};
::$bvvar{namespace}.hasCCSurvival <- function(a)
{
	local e = this.getCCContract(a);
	if (e != null && e.hasOath() && !e.m.RescueUsed) return true;
	local s = this.getCCState(a);
	return s != null && s.Active && !s.GutsUsed && this.hasCCImmortality(a);
};
// The shared damage frame calls this before skill damage callbacks (including Morgan).
::$bvvar{namespace}.claimCCSurvival <- function(a,damage,frame)
{
	local beforeHP = "BeforeHP" in frame ? frame.BeforeHP : a.getHitpoints();
	if (frame.Triggered || !frame.CouldDie || damage <= 0 || damage < beforeHP || !this.isCCAlive(a)) return false;
	local e = this.getCCContract(a);
	if (e != null && e.hasOath() && !e.m.RescueUsed)
	{
		e.m.RescueUsed=true; e.m.Protected=true;
		frame.Kind="c_c_pact_rescue"; frame.RestoreHP=::Math.max(1,::Math.ceil(a.getHitpointsMax()*30/100.0));
		frame.OwnerRef=this.makeValkyrieCombatWeakRef(e.getOwner());
		local owner=e.getOwner();
		owner.setHitpoints(::Math.max(1,owner.getHitpoints()-::Math.ceil(owner.getHitpointsMax()*20/100.0))); owner.setDirty(true);
	}
	else
	{
		local s=this.getCCState(a);
		if (s == null || !s.Active || s.GutsUsed || !this.hasCCImmortality(a)) return false;
		s.GutsUsed=true; s.Protected=true; s.APPenalty=true;
		frame.Kind="c_c_immortal_rebirth"; frame.RestoreHP=::Math.max(1,::Math.ceil(a.getHitpointsMax()*40/100.0));
		frame.OwnerRef=this.makeValkyrieCombatWeakRef(a);
	}
	frame.Triggered=true; a.setIsAbleToDie(false); return true;
};
::$bvvar{namespace}.getCCStateText <- function(a)
{
	local s=this.getCCState(a);
	if (s == null || !s.Active) return "$bv{cc.state.outside}";
	local target=this.readValkyrieCombatWeakRef(s.TargetRef),e=this.getCCContract(target);
	return "$bv{cc.state.seals}"+s.Seals+"/6\n"+(s.OathUsed?"$bv{cc.state.oath_used}":"$bv{cc.state.oath_ready}")+"\n"
		+(s.GutsUsed?"$bv{cc.state.guts_used}":"$bv{cc.state.guts_ready}")+"\n"
		+(e==null?"$bv{cc.state.no_contract}":(e.isEffective()?"$bv{cc.state.contract_active}":"$bv{cc.state.contract_paused}"))
		+"\n$bv{cc.state.contract_cooldown}"+::Math.max(0,s.ContractReady-::Time.getRound())
		+"\n$bv{cc.state.shock_cooldown}"+::Math.max(0,s.ShockReady-::Time.getRound());
};
