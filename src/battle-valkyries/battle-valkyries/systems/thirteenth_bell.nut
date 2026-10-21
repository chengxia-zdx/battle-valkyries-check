// Combat-only ledgers survive managed skill repair; chapter entitlements live in actor flags.
::$bvvar{namespace}.ThirteenthBell <- {
	function api() { return ::$bvvar{namespace}; },
	function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); },
	function owns(a, id) { return this.alive(a) && a.isPlayerControlled() && this.api().getActorValkyrieID(a) == id; },
	function entitled(a, key) { return a != null && this.api().hasValkyrieLearnedSkillEntitlement(a, "thirteenth_bell_" + key); },
	function state(a)
	{
		local epoch = this.api().ValkyrieCombatEvents.Epoch;
		if (!("BVThirteenthBell" in a.m) || a.m.BVThirteenthBell.Epoch != epoch)
			a.m.BVThirteenthBell <- { Epoch = epoch, Tea = false, Crest = false, Turn = 0, LastTurnRound = -1, UsedRound = -1 };
		return a.m.BVThirteenthBell;
	},
	function tick(a)
	{
		if (!this.owns(a, "rachel_alucard") || !this.api().EightValkyries.normal(a)) return;
		local s = this.state(a), round = ::Time.getRound(); if (s.LastTurnRound == round) return;
		s.LastTurnRound = round; ++s.Turn;
	},
	function lightning(skill)
	{
		return skill != null && "BVSkillKey" in skill.m
			&& ["rachel_alucard_sword_iris", "rachel_alucard_baden_baden_lily"].find(skill.m.BVSkillKey) != null;
	},
	function onEvent(a, key, e)
	{
		if (e == null || e.Type != "DamageResolved" || e.Attacker == null || !this.alive(a) || e.Attacker.getID() != a.getID() || e.Victim == null
			|| a.isAlliedWith(e.Victim) || e.HitpointDamage + e.ArmorDamage <= 0 || !this.entitled(a, key)) return;
		local s = this.state(a);
		if (key == "tea" && this.owns(a, "rachel_alucard") && this.lightning(e.Skill) && !s.Tea)
		{
			s.Tea = true; this.api().Rachel.gain(a, 10);
		}
		if (key == "crest" && this.owns(a, "es") && e.Skill != null && "EsAuxiliary" in e.Skill.m
			&& e.Skill.m.EsAuxiliary && !e.Skill.m.EsCounter && !s.Crest)
		{
			s.Crest = true; this.api().Es.gain(a, 10);
		}
		if (key != "promise" || !this.owns(a, "rachel_alucard") || !this.lightning(e.Skill) || !this.alive(e.Victim)) return;
		local mark = e.Victim.getSkills().getSkillByID("$bvvar{modId}.effect.thirteenth_bell_mark");
		if (mark == null)
		{
			mark = ::new("$bvvar{privateFolder}/skills/effects/thirteenth_bell_mark_effect"); e.Victim.getSkills().add(mark);
		}
		mark.addOwner(a, s.Epoch, s.Turn);
	},
	function consume(a, skill, target, hit)
	{
		if (!this.owns(a, "es") || !this.entitled(a, "promise") || !this.alive(target) || a.isAlliedWith(target)
			|| skill == null || !("EsAttack" in skill.m) || !skill.m.EsAttack || ("EsAuxiliary" in skill.m && skill.m.EsAuxiliary)) return false;
		local mark = target.getSkills().getSkillByID("$bvvar{modId}.effect.thirteenth_bell_mark"); if (mark == null) return false;
		local rachel = mark.takeOwner(); if (rachel == null) return false;
		hit.DamageRegular *= 1.15; hit.DamageArmor *= 1.15;
		this.api().Rachel.wind(rachel, 1); return true;
	}
};
