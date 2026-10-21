this.grail_court_guard_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); },
	function onUpdate(p) {
		local pieces = ::$bvvar{namespace}.grailPieces(this.getContainer().getActor());
		if (pieces.len() >= 2) { p.MeleeDefense += 10; p.RangedDefense += 10; }
	},
	function onTurnStart() {
		local bv = ::$bvvar{namespace}, actor = this.getContainer().getActor();
		if (!bv.isMorganNormalTurn(actor)) return;
		local state = bv.grailActorState(actor), round = ::Time.getRound();
		if (state.RingRound == round) return;
		state.RingRound = round; state.Protected = false;
		foreach (item in bv.grailPieces(actor)) if (item.m.BVGrailPiece == "grail_oath_ring") {
			local itemState = bv.grailItemState(item);
			if (itemState.BVGrailRound == round) return;
			itemState.BVGrailRound = round; actor.setFatigue(::Math.max(0, actor.getFatigue() - 5));
		}
	},
	function onBeforeDamageReceived(attacker, skill, hit, p) {
		local actor = this.getContainer().getActor();
		if (attacker != null && !attacker.isAlliedWith(actor) && skill != null && skill.isAttack()
			&& ::$bvvar{namespace}.grailActorState(actor).Protected) p.DamageReceivedTotalMult *= 0.5;
	}
});
