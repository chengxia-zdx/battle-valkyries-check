// Sakiko's combat-only runner. No actor flags or serialized turn state.
::$bvvar{namespace}.SakikoSupportID <- "$bvvar{modId}.effects.togawa_sakiko_ensemble";
::$bvvar{namespace}.SakikoTurns <- {};
::$bvvar{namespace}.sakikoRound <- function() { return ::Time.getRound(); };
::$bvvar{namespace}.getSakikoPassive <- function(_actor) {
	return _actor == null ? null : this.getRuntimeSkillByKey(_actor, "togawa_sakiko_ensemble_stage");
};
::$bvvar{namespace}.sakikoAlive <- function(_actor) {
	return _actor != null && !this.isActorDeadOrDying(_actor) && _actor.isPlacedOnMap();
};
::$bvvar{namespace}.sakikoRoster <- function() {
	return ::World == null || ::World.getPlayerRoster() == null ? [] : ::World.getPlayerRoster().getAll();
};
::$bvvar{namespace}.sakikoExtraTurn <- function(_actor) {
	local c = _actor.getSkills().getSkillByID("$bvvar{modId}.effects.cerydra_command_turn");
	if (c != null && c.m.IsCommandPhase) return true;
	local r = _actor.getSkills().getSkillByID("$bvvar{modId}.effects.robin_granted_action");
	return r != null && r.m.BVIsExtraTurn;
};
::$bvvar{namespace}.sakikoTurn <- function(_actor) {
	local key = _actor.getID().tostring();
	if (!(key in this.SakikoTurns)) this.SakikoTurns[key] <- { Round=-1, EndRound=-1, Normal=false, RecoveryRound=-1, DiscountRound=-1, Discounts=0 };
	return this.SakikoTurns[key];
};
::$bvvar{namespace}.sakikoNormalAction <- function(_actor) {
	local t = this.sakikoTurn(_actor);
	return this.sakikoAlive(_actor) && t.Round == this.sakikoRound() && t.Normal && !this.sakikoExtraTurn(_actor);
};
::$bvvar{namespace}.sakikoHasConductor <- function() {
	foreach (actor in this.sakikoRoster()) {
		local p = this.getSakikoPassive(actor);
		if (p != null && p.m.BattleActive) return true;
	}
	return false;
};
::$bvvar{namespace}.sakikoRecover <- function(_actor) {
	local t = this.sakikoTurn(_actor), round = this.sakikoRound();
	if (t.RecoveryRound == round) return;
	t.RecoveryRound = round;
	_actor.setFatigue(::Math.max(0, _actor.getFatigue() - 5));
	_actor.setDirty(true);
};
::$bvvar{namespace}.beginSakikoTurn <- function(_actor) {
	if (!this.sakikoHasConductor() || !this.sakikoAlive(_actor)) return;
	local t = this.sakikoTurn(_actor), round = this.sakikoRound();
	t.Normal = !this.sakikoExtraTurn(_actor) && t.EndRound != round;
	if (!t.Normal || t.Round == round) return;
	t.Round = round;
	local p = this.getSakikoPassive(_actor);
	if (p != null && p.m.BattleActive) {
		local before = p.m.Melody;
		p.m.Melody = ::Math.min(6, p.m.Melody + 2);
		if (before < 6 && p.m.Melody == 6 && "playValkyrieSkillAudio" in this)
			this.playValkyrieSkillAudio(_actor, "togawa_sakiko_ensemble_stage_ready");
		this.sakikoRecover(_actor);
		if (p.m.Melody == 6) this.playValkyrieVisual(p, _actor, "sakiko_stage");
	}
	local effect = _actor.getSkills().getSkillByID(this.SakikoSupportID);
	if (effect != null) effect.beginNormalTurn(round);
};
::$bvvar{namespace}.endSakikoTurn <- function(_actor) {
	local key = _actor.getID().tostring();
	if (!(key in this.SakikoTurns)) return;
	local t = this.SakikoTurns[key];
	if (!t.Normal || this.sakikoExtraTurn(_actor)) return;
	local effect = _actor.getSkills().getSkillByID(this.SakikoSupportID);
	if (effect != null) effect.endNormalTurn(this.sakikoRound());
	t.EndRound = this.sakikoRound(); t.Normal = false;
};
::$bvvar{namespace}.refreshSakikoRecipients <- function() {
	foreach (actor in this.sakikoRoster()) {
		local p = this.getSakikoPassive(actor);
		if (p != null && p.m.BattleActive) p.syncRecipients();
	}
};

// Add a final AP adjustment after the existing primary weapon policy. Preserve
// its range, accuracy, fatigue and charge commit, including another Valkyrie's.
::$bvvar{namespace}.appendSakikoWeaponPolicy <- function(_skill, _policy) {
	local actor = _skill.getContainer().getActor();
	local effect = actor.getSkills().getSkillByID(this.SakikoSupportID);
	if (effect == null || !effect.canDiscount(_skill)) return _policy;
	if (_policy == null) {
		_policy = this.normalizeValkyrieWeaponSkillPolicy({Token="sakiko_support"}).Policy;
		_policy.Provider <- null; _policy.ProviderKey <- "togawa_sakiko_ensemble_stage"; _policy.Raw <- {};
	}
	_policy.FinalAPProvider <- effect;
	return _policy;
};

// FatigueEffectMult also affects movement in vanilla. Apply Organ only to the
// payable active-skill cost, after weapon mastery and other cost modifiers.
::$bvvar{namespace}.adjustSakikoFatigueCost <- function(_skill, _cost) {
	if (!_skill.isActive() || _skill.getContainer()==null) return _cost;
	local effect = _skill.getContainer().getSkillByID(this.SakikoSupportID);
	local mode = effect==null ? 0 : effect.mode();
	return mode==2 || mode==3 ? ::Math.ceil(_cost*0.8).tointeger() : _cost;
};
