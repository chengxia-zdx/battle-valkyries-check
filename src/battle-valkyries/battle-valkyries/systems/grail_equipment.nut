::$bvvar{namespace}.Grail.BattleSerial <- 0;
::$bvvar{namespace}.getGrailEquipmentActor <- function(actor) {
	actor = this.readValkyrieCombatWeakRef(actor);
	// item_container can outlive its owner during death/transfer. Test the resolved
	// table, not membership on WeakTableRef (which only forwards method calls).
	return actor != null && typeof actor == "table" && "getItems" in actor ? actor : null;
};
::$bvvar{namespace}.grailPieces <- function(actor) {
	local result = [];
	actor = this.getGrailEquipmentActor(actor);
	if (actor == null) return result;
	local items = actor.getItems();
	if (items == null) return result;
	foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Body, ::Const.ItemSlot.Head, ::Const.ItemSlot.Accessory]) {
		local item = items.getItemAtSlot(slot);
		if (item != null && "BVGrailPiece" in item.m) result.push(item);
	}
	return result;
};
::$bvvar{namespace}.grailItemState <- function(item) {
	if (!("BVGrailBattle" in item.m) || item.m.BVGrailBattle != this.Grail.BattleSerial) {
		item.m.BVGrailBattle <- this.Grail.BattleSerial; item.m.BVGrailRound <- -2; item.m.BVGrailSaved <- false;
	}
	return item.m;
};
::$bvvar{namespace}.grailActorState <- function(actor) {
	if (!("BVGrailCombat" in actor.m) || actor.m.BVGrailCombat.Battle != this.Grail.BattleSerial)
		actor.m.BVGrailCombat <- { Battle = this.Grail.BattleSerial, Round = -2, RingRound = -2, Saved = false, Protected = false, StartedWithSet = false };
	return actor.m.BVGrailCombat;
};
::$bvvar{namespace}.syncGrailGear <- function(actor) {
	actor = this.getGrailEquipmentActor(actor);
	// Unavailable ownership is not an empty loadout. Never detach on a failed read.
	if (actor == null || actor.getItems() == null || !this.isValidValkyrieSkillActor(actor)) return;
	local pieces = this.grailPieces(actor), keys = {};
	foreach (item in pieces) keys[item.m.BVGrailPiece] <- true;
	foreach (key in this.Grail.Gear) {
		local owner = "$bvvar{modId}.owner.item." + key;
		local result = key in keys ? this.attachTransientSkill(actor, "grail_court_guard", owner) : this.detachTransientSkill(actor, "grail_court_guard", owner);
		if (!result.Success && result.Code != "owner_not_found") this.logValkyrieSkillFailure(actor, "grail_court_guard", result.Code, "grail.gear_sync");
	}
	local result = "grail_gungnir" in keys ? this.attachTransientSkill(actor, "grail_oath_thrust", "$bvvar{modId}.owner.item.grail_gungnir")
		: this.detachTransientSkill(actor, "grail_oath_thrust", "$bvvar{modId}.owner.item.grail_gungnir");
	if (!result.Success && result.Code != "owner_not_found") this.logValkyrieSkillFailure(actor, "grail_oath_thrust", result.Code, "grail.gear_sync");
};
::$bvvar{namespace}.grailTrySurvive <- function(actor, attacker, hp) {
	if (attacker == null || attacker.isAlliedWith(actor) || !actor.isAbleToDie() || this.isActorDeadOrDying(actor)
		|| !("BVGrailHit" in actor.m) || actor.m.BVGrailHit == null || hp <= 0 || hp < actor.getHitpoints()) return false;
	local frame = actor.m.BVGrailHit;
	if (frame.Skill == null || !frame.Skill.isAttack()) return false;
	local state = this.grailActorState(actor), pieces = this.grailPieces(actor);
	if (!state.StartedWithSet || state.Saved || pieces.len() != 4) return false;
	foreach (item in pieces) if (this.grailItemState(item).BVGrailSaved) return false;
	state.Saved = true; state.Protected = true;
	foreach (item in pieces) this.grailItemState(item).BVGrailSaved = true;
	// Same engine boundary as the chapter shield: all earlier survival callbacks
	// arbitrate first. Buffer only the HP needed before the engine subtracts damage.
	local remain = ::Math.max(1, ::Math.floor(actor.getHitpointsMax() * 0.35));
	actor.m.Hitpoints += hp - actor.getHitpoints() + remain;
	return true;
};

::$bvvar{namespace}.registerJeanneAlterPositiveEffectID("$bvvar{modId}.effects.grail_wish_claim");
