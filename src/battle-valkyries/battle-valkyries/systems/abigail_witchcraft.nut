// Combat state stays on actors across managed-skill reconstruction, never on skins.
::$bvvar{namespace}.AbigailEffectIDs <- {
	prayer="$bvvar{modId}.effects.abigail_prayer", erosion="$bvvar{modId}.effects.abigail_erosion",
	terror="$bvvar{modId}.effects.abigail_terror", trial="$bvvar{modId}.effects.abigail_trial"
};
::$bvvar{namespace}.getAbigailState <- function(a)
{
	if (a==null || !("BVAbigailCombat" in a.m)) return null;
	return a.m.BVAbigailCombat.Epoch==this.ValkyrieCombatEvents.Epoch ? a.m.BVAbigailCombat : null;
};
::$bvvar{namespace}.isAbigailExtraTurn <- function(a)
{
	local c=a.getSkills().getSkillByID("$bvvar{modId}.effects.cerydra_command_turn");
	local r=a.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	return (c!=null && c.m.IsCommandPhase) || (r!=null && r.m.BVIsExtraTurn);
};
::$bvvar{namespace}.getAbigailTurn <- function(a)
{
	local epoch=this.ValkyrieCombatEvents.Epoch;
	if (!("BVAbigailTurn" in a.m) || a.m.BVAbigailTurn.Epoch!=epoch)
	{
		local running="IsTurnStarted" in a.m && a.m.IsTurnStarted && !this.isAbigailExtraTurn(a);
		a.m.BVAbigailTurn <- {Epoch=epoch,Serial=running?1:0,StartRound=running?::Time.getRound():-1,EndRound=-1,Processed=-1,Normal=running,TerrorUsed=false};
	}
	return a.m.BVAbigailTurn;
};
::$bvvar{namespace}.getAbigailEffect <- function(a,kind)
{
	return a==null?null:a.getSkills().getSkillByID(this.AbigailEffectIDs[kind]);
};
::$bvvar{namespace}.hasAbigailState <- function(a)
{
	if (this.getAbigailState(a)!=null) return true;
	foreach(kind,id in this.AbigailEffectIDs) if (a.getSkills().hasSkill(id)) return true;
	return false;
};
::$bvvar{namespace}.startAbigailCombat <- function(a)
{
	if (a==null || this.getActorValkyrieID(a)!="abigail_williams" || !a.isPlayerControlled()) return null;
	local state=this.getAbigailState(a);
	if (state!=null) return state;
	state={Epoch=this.ValkyrieCombatEvents.Epoch,Active=true,Keys=1,StartRound=::Math.max(1,::Time.getRound()),IncomeRound=-1,HitRound=-1,Cooldowns={},Targets={},Busy=false,LastAction=null};
	a.m.BVAbigailCombat <- state;this.getAbigailTurn(a);return state;
};
::$bvvar{namespace}.refreshAbigailActor <- function(a) { a.getSkills().update();a.setDirty(true); };
::$bvvar{namespace}.stopAbigailCombat <- function(a)
{
	local state=this.getAbigailState(a);
	if (state==null) return;
	state.Active=false;state.Keys=0;state.Busy=false;state.Cooldowns.clear();
	foreach(id,ref in state.Targets)
	{
		local target=this.readValkyrieCombatWeakRef(ref);
		if (target==null) continue;
		foreach(kind,effectID in this.AbigailEffectIDs)
		{
			local e=this.getAbigailEffect(target,kind);
			if (e!=null) e.removeSource(a.getID());
		}
		if (!this.isActorDeadOrDying(target)) this.refreshAbigailActor(target);
	}
	state.Targets.clear();
};
::$bvvar{namespace}.canAbigailAct <- function(a)
{
	local s=this.getAbigailState(a);
	return s!=null && s.Active && !s.Busy && a.isPlayerControlled() && this.getActorValkyrieID(a)=="abigail_williams"
		&& !this.isActorDeadOrDying(a) && a.isPlacedOnMap() && a.getCurrentProperties().IsAbleToUseSkills
		&& a.getMoraleState()!=::Const.MoraleState.Fleeing;
};
::$bvvar{namespace}.abigailCooldown <- function(a,key)
{
	local s=this.getAbigailState(a);
	return s==null || !(key in s.Cooldowns) ? 0 : ::Math.max(0,s.Cooldowns[key]-::Time.getRound());
};
::$bvvar{namespace}.addAbigailKeys <- function(a,amount,skill)
{
	local s=this.getAbigailState(a);
	if (s==null || !s.Active || this.isActorDeadOrDying(a) || !a.isPlacedOnMap()) return;
	local before=s.Keys;s.Keys=::Math.min(6,::Math.max(0,s.Keys+amount));
	if (before<6 && s.Keys==6)
	{
		this.playValkyrieSkillAudio(a,"abigail_gate_ready");this.playValkyrieVisual(skill,a,"abigail_gate_ring");
	}
	a.setDirty(true);
};
// Vanilla uses MoraleState.Ignore and IsImmuneToStun. Optional explicit mod
// properties below are respected if present; absence is never immunity.
::$bvvar{namespace}.abigailHasImmunity <- function(a,names)
{
	local p=a.getCurrentProperties();
	foreach(name in names) if (name in p && p[name]) return true;
	return false;
};
::$bvvar{namespace}.canReceiveAbigailEffect <- function(a,kind)
{
	if (this.isActorDeadOrDying(a) || !a.isPlacedOnMap()) return false;
	if (kind=="prayer") return a.isPlayerControlled();
	if (this.abigailHasImmunity(a,["IsImmuneToDebuffs","IsImmuneToNegativeStatusEffects"])) return false;
	if (kind=="terror" && "Legends" in getroottable())
	{
		// Legends converts these stuns to daze. Treat that as stun immunity here,
		// rather than applying a different control effect through the native hook.
		if (a.getSkills().hasSkill("perk.steel_brow")) return false;
		local immovable=a.getSkills().getSkillByID("perk.legend_immovable_object");
		if (immovable!=null && "isGrantingStunImmunity" in immovable.m && immovable.m.isGrantingStunImmunity) return false;
	}
	if (kind=="terror") return a.getMoraleState()!=::Const.MoraleState.Ignore && !this.getAbigailTurn(a).TerrorUsed
		&& !this.abigailHasImmunity(a,["IsImmuneToStun","IsImmuneToFear","IsImmuneToMorale"]);
	if (kind=="trial") return !this.abigailHasImmunity(a,["IsImmuneToDamageDebuffs"]) || !this.abigailHasImmunity(a,["IsImmuneToActionPointReduction"]);
	return !this.abigailHasImmunity(a,["IsImmuneToDefenseDebuffs"]);
};
::$bvvar{namespace}.applyAbigailEffect <- function(owner,target,kind,resolve)
{
	local s=this.getAbigailState(owner);
	if (s==null || !s.Active || this.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || !this.canReceiveAbigailEffect(target,kind)) return false;
	if (kind=="prayer" ? (owner!=target && !this.isEligibleRosterAlly(owner,target)) : !this.isEligibleValkyrieEnemyTarget(owner,target)) return false;
	local e=this.getAbigailEffect(target,kind),created=e==null;
	if (e!=null && owner.getID() in e.m.Sources) return false;
	if (created)
	{
		e=::new("$bvvar{privateFolder}/skills/effects/abigail_status_effect");e.setup(kind);
		e.m.AppliedSerial=this.getAbigailTurn(target).Serial;e.m.ExpiresAfterTurn=e.m.AppliedSerial+2;
	}
	e.m.Sources[owner.getID()] <- {Ref=this.makeValkyrieCombatWeakRef(owner),Resolve=resolve};
	if (created) target.getSkills().add(e);
	s.Targets[target.getID()] <- this.makeValkyrieCombatWeakRef(target);
	this.refreshAbigailActor(target);
	return this.getAbigailEffect(target,kind)!=null;
};
::$bvvar{namespace}.beginAbigailTurn <- function(a)
{
	if (!this.hasAbigailState(a)) return;
	local t=this.getAbigailTurn(a),round=::Time.getRound();
	t.Normal=!this.isAbigailExtraTurn(a) && t.EndRound!=round;
	if (!t.Normal || t.StartRound==round) return;
	t.StartRound=round;t.Serial++;
};
// Called from skill_container.onTurnStart after native AP/fatigue restoration and
// skill callbacks, but before actor.onTurnStart starts AI decision making.
::$bvvar{namespace}.processAbigailTurn <- function(a)
{
	if (!this.hasAbigailState(a) || this.isActorDeadOrDying(a) || !a.isPlacedOnMap()) return;
	local t=this.getAbigailTurn(a);
	if (!t.Normal || this.isAbigailExtraTurn(a) || t.Processed==t.Serial) return;
	t.Processed=t.Serial;
	local s=this.getAbigailState(a),round=::Time.getRound();
	if (s!=null && s.Active && round>s.StartRound && s.IncomeRound!=round)
	{
		s.IncomeRound=round;this.addAbigailKeys(a,1,this.getRuntimeSkillByKey(a,"abigail_outer_realm"));
	}
	foreach(kind,id in this.AbigailEffectIDs)
	{
		local e=this.getAbigailEffect(a,kind);
		if (e!=null && t.Serial>e.m.AppliedSerial && e.hasSource()) e.onNormalTurnStart(t);
	}
	this.refreshAbigailActor(a);
};
::$bvvar{namespace}.endAbigailTurn <- function(a)
{
	if (!this.hasAbigailState(a)) return;
	local t=this.getAbigailTurn(a);
	if (t.EndRound==::Time.getRound()) return;
	t.EndRound=::Time.getRound();t.Normal=false;
	foreach(kind,id in this.AbigailEffectIDs)
	{
		local e=this.getAbigailEffect(a,kind);
		if (e!=null && t.Serial>=e.m.ExpiresAfterTurn) e.removeSelf();
	}
	if (!this.isActorDeadOrDying(a)) this.refreshAbigailActor(a);
};
::$bvvar{namespace}.isAbigailSpell <- function(skill)
{
	if (!this.isBattleValkyriesManagedRuntimeSkill(skill)) return false;
	local key=skill.getBattleValkyriesSkillKey();return key=="abigail_root_touch" || key=="abigail_qliphoth_rhizome";
};
::$bvvar{namespace}.isAbigailDirectSource <- function(source) { return source=="direct" || source=="managed_active"; };
// One finalization after all vanilla/Legends callbacks, shared by ordinary
// mercenaries and Valkyries. Tooltips never consume prayer's attack charge.
::$bvvar{namespace}.finalizeAbigailUseProperties <- function(a,skill,target,p)
{
	if (a==null || skill==null) return p;
	if (this.getActorValkyrieID(a)=="abigail_williams" && this.isAbigailSpell(skill)) skill.finalizeSpellProperties(target,p);
	if (!this.isDirectAttack(skill)) return p;
	local source=this.getCurrentValkyrieCombatSource(a,skill),ctx=this.getCurrentValkyrieActionContext(a,skill);
	local indirect=["dot","damage_over_time","reflection","terrain","fixed_damage"];
	if (source!=null && (indirect.find(source.Source)!=null || source.Source.find("fixed")!=null)) return p;
	local trial=this.getAbigailEffect(a,"trial");
	if (trial!=null && trial.hasSource() && !this.abigailHasImmunity(a,["IsImmuneToDamageDebuffs","IsImmuneToDebuffs","IsImmuneToNegativeStatusEffects"])) p.DamageTotalMult*=0.8;
	if (source!=null && !this.isAbigailDirectSource(source.Source)) return p;
	if (ctx!=null && (ctx.IsFree || ctx.IsImplicit || !this.isAbigailDirectSource(ctx.Source))) return p;
	local prayer=this.getAbigailEffect(a,"prayer");
	if (prayer!=null && prayer.hasSource())
	{
		if (prayer.m.BoostReady && ctx!=null) { prayer.m.BoostReady=false;prayer.m.BoostAction=ctx.ActionToken;a.setDirty(true); }
		if (prayer.m.BoostReady || (ctx!=null && prayer.m.BoostAction==ctx.ActionToken)) p.DamageTotalMult*=1.15;
	}
	return p;
};
// Independent allow-list: adding stances here must not broaden Jeanne Alter's lockout.
::$bvvar{namespace}.AbigailDispelIDs <- ["effects.adrenaline","effects.killing_frenzy","effects.shieldwall","effects.spearwall","effects.riposte"];
::$bvvar{namespace}.dispelAbigailBuffs <- function(target)
{
	local count=0;
	foreach(id in this.AbigailDispelIDs)
	{
		local e=target.getSkills().getSkillByID(id);
		if (e!=null) { e.removeSelf();count++; }
	}
	if (count>0) this.refreshAbigailActor(target);
	return count;
};
::$bvvar{namespace}.getAbigailStateText <- function(a)
{
	local s=this.getAbigailState(a);
	return s==null || !s.Active?"$bv{abigail.outside}":"$bv{abigail.keys}"+s.Keys+"/6";
};
