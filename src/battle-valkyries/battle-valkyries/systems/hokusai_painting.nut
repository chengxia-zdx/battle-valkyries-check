// Combat ledgers live on actors so managed skill reconstruction cannot refill them.
::$bvvar{namespace}.HokusaiInkID <- "$bvvar{modId}.effects.hokusai_ink_mark";
::$bvvar{namespace}.getHokusaiState <- function(a)
{
	if (a == null || !("BVHokusaiCombat" in a.m)) return null;
	local s = a.m.BVHokusaiCombat;
	return s.Epoch == this.ValkyrieCombatEvents.Epoch ? s : null;
};
::$bvvar{namespace}.isHokusaiExtraTurn <- function(a)
{
	local c = a.getSkills().getSkillByID("$bvvar{modId}.effects.cerydra_command_turn");
	local r = a.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	return (c != null && c.m.IsCommandPhase) || (r != null && r.m.BVIsExtraTurn);
};
::$bvvar{namespace}.getHokusaiTurn <- function(a)
{
	local epoch = this.ValkyrieCombatEvents.Epoch;
	if (!("BVHokusaiTurn" in a.m) || a.m.BVHokusaiTurn.Epoch != epoch)
	{
		// A mark may first be applied while the recipient is already acting/waiting.
		local running = "IsTurnStarted" in a.m && a.m.IsTurnStarted && !this.isHokusaiExtraTurn(a);
		a.m.BVHokusaiTurn <- {Epoch=epoch, Serial=running ? 1 : 0, StartRound=running ? ::Time.getRound() : -1, EndRound=-1, Normal=running};
	}
	return a.m.BVHokusaiTurn;
};
::$bvvar{namespace}.startHokusaiCombat <- function(a)
{
	if (a == null || this.getActorValkyrieID(a) != "katsushika_hokusai" || !a.isPlayerControlled()) return null;
	local s = this.getHokusaiState(a);
	if (s != null) return s;
	s = {Epoch=this.ValkyrieCombatEvents.Epoch, Active=true, Inspiration=1, IncomeRound=-1, Income=0,
		FatherRound=-1, NatureUntil=-1, BondUntil=-1, MoraleGuards=0, Busy=false, Cooldowns={}, Targets={}, LastAction=null};
	a.m.BVHokusaiCombat <- s;
	this.getHokusaiTurn(a);
	return s;
};
::$bvvar{namespace}.refreshHokusaiActor <- function(a) { a.getSkills().update(); a.setDirty(true); };
::$bvvar{namespace}.stopHokusaiCombat <- function(a)
{
	local s = this.getHokusaiState(a);
	if (s == null) return;
	s.Active=false; s.Busy=false; s.NatureUntil=-1; s.BondUntil=-1; s.MoraleGuards=0;
	foreach (id, ref in s.Targets)
	{
		local target = this.readValkyrieCombatWeakRef(ref);
		if (target == null) continue;
		local effect = target.getSkills().getSkillByID(this.HokusaiInkID);
		if (effect != null) { effect.removeSource(a.getID()); this.refreshHokusaiActor(target); }
	}
	s.Targets.clear();
};
::$bvvar{namespace}.beginHokusaiTurn <- function(a)
{
	if (this.getHokusaiState(a) == null && !a.getSkills().hasSkill(this.HokusaiInkID)) return;
	local t = this.getHokusaiTurn(a), round = ::Time.getRound();
	t.Normal = !this.isHokusaiExtraTurn(a) && t.EndRound != round;
	if (!t.Normal || t.StartRound == round) return;
	t.StartRound=round; t.Serial++;
	local s = this.getHokusaiState(a);
	if (s != null && s.NatureUntil >= 0 && t.Serial >= s.NatureUntil)
	{
		s.NatureUntil=-1; this.refreshHokusaiActor(a);
	}
};
::$bvvar{namespace}.endHokusaiTurn <- function(a, normal)
{
	if (!normal) return;
	local t = this.getHokusaiTurn(a);
	if (t.EndRound == ::Time.getRound()) return;
	t.EndRound=::Time.getRound(); t.Normal=false;
	local ink = a.getSkills().getSkillByID(this.HokusaiInkID);
	if (ink != null && t.Serial >= ink.m.ExpiresAfterTurn) ink.removeSelf();
	local s = this.getHokusaiState(a);
	if (s != null && s.BondUntil >= 0 && t.Serial >= s.BondUntil) { s.BondUntil=-1; s.MoraleGuards=0; }
	this.refreshHokusaiActor(a);
};
::$bvvar{namespace}.canHokusaiAct <- function(a)
{
	local s = this.getHokusaiState(a);
	return s != null && s.Active && !s.Busy && a.isPlayerControlled() && this.getActorValkyrieID(a) == "katsushika_hokusai"
		&& !this.isActorDeadOrDying(a) && a.isPlacedOnMap() && a.getCurrentProperties().IsAbleToUseSkills
		&& a.getMoraleState() != ::Const.MoraleState.Fleeing;
};
::$bvvar{namespace}.hokusaiCooldown <- function(a, key)
{
	local s=this.getHokusaiState(a);
	return s == null || !(key in s.Cooldowns) ? 0 : ::Math.max(0, s.Cooldowns[key] - ::Time.getRound());
};
::$bvvar{namespace}.addHokusaiInspiration <- function(a, amount, skill)
{
	local s=this.getHokusaiState(a);
	if (s == null || !s.Active || this.isActorDeadOrDying(a)) return;
	local before=s.Inspiration;
	s.Inspiration=::Math.min(6,s.Inspiration+amount);
	if (before < 6 && s.Inspiration == 6)
	{
		this.playValkyrieSkillAudio(a,"hokusai_painting_ready");
		this.playValkyrieVisual(skill,a,"hokusai_painting_ready");
	}
};
::$bvvar{namespace}.getHokusaiInk <- function(target)
{
	return target == null ? null : target.getSkills().getSkillByID(this.HokusaiInkID);
};
::$bvvar{namespace}.applyHokusaiInk <- function(owner,target,skill)
{
	local s=this.getHokusaiState(owner);
	if (s == null || !s.Active || !this.isEligibleValkyrieEnemyTarget(owner,target)) return false;
	local e=this.getHokusaiInk(target);
	local created=e==null;
	if (e == null)
	{
		e=::new("$bvvar{privateFolder}/skills/effects/hokusai_ink_mark_effect");
	}
	e.pruneSources();
	local added=e.m.Sources.len()<3;
	if (added) e.m.Sources.push({ID=owner.getID(),Ref=this.makeValkyrieCombatWeakRef(owner)});
	e.m.ExpiresAfterTurn=this.getHokusaiTurn(target).Serial+2;
	if (created) target.getSkills().add(e);
	s.Targets[target.getID()] <- this.makeValkyrieCombatWeakRef(target);
	this.refreshHokusaiActor(target);
	if (added) this.playValkyrieVisual(skill,target,"hokusai_ink_mark");
	return added;
};
::$bvvar{namespace}.isHokusaiSpell <- function(skill)
{
	if (!this.isBattleValkyriesManagedRuntimeSkill(skill)) return false;
	local key=skill.getBattleValkyriesSkillKey();
	return key=="hokusai_brushstroke" || key=="hokusai_alien_octopus" || key=="hokusai_thirty_six_views";
};
::$bvvar{namespace}.finalizeHokusaiSpellProperties <- function(actor,skill,target,p)
{
	if (actor != null && this.getActorValkyrieID(actor)=="katsushika_hokusai" && this.isHokusaiSpell(skill)) skill.finalizePaintingProperties(target,p);
	return p;
};
// Explicit BB human taxonomy; unknown mod types are opt-in, never inferred from equipment.
::$bvvar{namespace}.HokusaiHumanTypes <- {};
foreach (name in ["BanditThug","BanditRaider","BanditLeader","BanditMarksman","Footman","Sergeant","StandardBearer","Arbalester","Knight","Greatsword","HedgeKnight","MasterArcher","Swordmaster","Mercenary","Militia","Cultist","Necromancer","NomadCutthroat","NomadOutlaw","NomadArcher","NomadLeader","NomadExecutioner","NomadDesertStalker","NomadBladeDancer","BarbarianThrall","BarbarianMarauder","BarbarianChosen","BarbarianChampion","BarbarianDrummer","BarbarianBeastmaster","Conscript","Officer","Gunner","Engineer","Assassin","Gladiator","Slave","Manhunter"])
	if (name in ::Const.EntityType) ::$bvvar{namespace}.HokusaiHumanTypes[::Const.EntityType[name]] <- true;
::$bvvar{namespace}.isHokusaiHuman <- function(a)
{
	return a != null && !this.isActorDeadOrDying(a) && a.getType() in this.HokusaiHumanTypes;
};
::$bvvar{namespace}.getHokusaiStateText <- function(a)
{
	local s=this.getHokusaiState(a);
	if (s==null || !s.Active) return "$bv{hokusai.state.outside}";
	local t=this.getHokusaiTurn(a);
	return "$bv{hokusai.state.inspiration}"+s.Inspiration+"/6\n"+"$bv{hokusai.state.income}"+(s.IncomeRound==::Time.getRound()?s.Income:0)+"/2\n"
		+(s.NatureUntil>=0?"$bv{hokusai.state.nature}":"")
		+(s.BondUntil>=0?"$bv{hokusai.state.bond}"+s.MoraleGuards+"/2\n"+"$bv{hokusai.state.bond_turns}"+::Math.max(0,s.BondUntil-t.Serial):"");
};
::$bvvar{namespace}.tryHokusaiMoraleGuard <- function(a,change)
{
	local s=this.getHokusaiState(a);
	if (change>=0 || s==null || !s.Active || s.BondUntil<0 || s.MoraleGuards<=0 || this.isActorDeadOrDying(a)
		|| !a.isPlayerControlled() || !a.isPlacedOnMap() || this.getActorValkyrieID(a)!="katsushika_hokusai"
		|| a.getMoraleState()==::Const.MoraleState.Fleeing || a.getMoraleState()==::Const.MoraleState.Ignore
		|| ("BVHokusaiIndirectMorale" in a.m && a.m.BVHokusaiIndirectMorale>0)) return false;
	local context=this.getCurrentValkyrieActionContext();
	local source=context==null?null:this.readValkyrieCombatWeakRef(context.UserRef);
	if (source==null || source==a || source.isAlliedWith(a)) return false;
	s.MoraleGuards--; a.setDirty(true);
	return true;
};
