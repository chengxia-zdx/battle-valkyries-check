this.togawa_sakiko_ensemble_stage_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Melody=0, Organ=false, BattleActive=false, LastSwitchRound=-1, LastAuraEnabled=false },
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
	function auraEnabled() {
		local a = this.owner();
		return this.m.BattleActive && ::$bvvar{namespace}.sakikoAlive(a)
			&& !a.getSkills().hasSkill("effects.stunned") && a.getMoraleState() != this.Const.MoraleState.Fleeing;
	}
	function syncRecipients() {
		local owner = this.owner();
		if (!this.m.BattleActive || !::$bvvar{namespace}.sakikoAlive(owner)) { this.clearRecipients(); return; }
		foreach (actor in ::$bvvar{namespace}.sakikoRoster()) {
			if (!::$bvvar{namespace}.sakikoAlive(actor) || !::$bvvar{namespace}.isEligibleRosterAlly(owner,actor)) continue;
			local e = actor.getSkills().getSkillByID(::$bvvar{namespace}.SakikoSupportID);
			if (e == null) {
				e = ::new("$bvvar{privateFolder}/skills/effects/togawa_sakiko_ensemble_effect");
				e.setupOwner(owner); actor.getSkills().add(e);
			}
			actor.getSkills().update(); actor.setDirty(true);
		}
	}
	function clearRecipients() {
		local owner = this.owner();
		foreach (actor in ::$bvvar{namespace}.sakikoRoster()) {
			local e = actor.getSkills().getSkillByID(::$bvvar{namespace}.SakikoSupportID);
			if (e != null && e.isOwnedBy(owner)) { e.removeSelf(); actor.getSkills().update(); actor.setDirty(true); }
		}
	}
	function onUpdate(_properties) {
		local enabled = this.auraEnabled();
		if (enabled != this.m.LastAuraEnabled) { this.m.LastAuraEnabled = enabled; this.syncRecipients(); }
	}
	function onCombatStarted() {
		this.m.Melody=2; this.m.Organ=false; this.m.LastSwitchRound=-1; this.m.BattleActive=true;
		this.m.LastAuraEnabled=this.auraEnabled();
		::$bvvar{namespace}.SakikoTurns = {}; this.syncRecipients();
	}
	function stop() { this.m.BattleActive=false; this.m.Melody=0; this.m.Organ=false; this.clearRecipients(); }
	function onDeath(_fatalityType) { this.stop(); }
	function onRemoved() { this.stop(); }
	function onCombatFinished() { this.stop(); this.skill.onCombatFinished(); }
	function getName() { return this.m.Name + " (" + this.m.Melody + "/6)"; }
	function getTooltip() {
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text=this.m.Organ ? "$bv{sakiko.organ}" : "$bv{sakiko.piano}"}];
	}
});
