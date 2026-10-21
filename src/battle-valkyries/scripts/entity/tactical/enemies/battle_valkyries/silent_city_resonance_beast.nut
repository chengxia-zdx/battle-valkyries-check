// Reuse the native beast rig, AI, attacks and corpse pipeline; no player identity.
this.silent_city_resonance_beast <- this.inherit("scripts/entity/tactical/enemies/unhold", {
	m = { IsEchoLord = false },
	function create() { this.unhold.create(); this.m.Name = "$bv{enemy.silent_city.beast.name}"; this.m.XP = 450; },
	function onInit()
	{
		this.unhold.onInit(); local b = this.m.BaseProperties, boss = this.m.IsEchoLord;
		b.Hitpoints = boss ? 2400 : 420; b.MeleeSkill = boss ? 90 : 75; b.MeleeDefense = boss ? 20 : 5;
		b.RangedDefense = boss ? 15 : 0; b.Initiative = boss ? 55 : 65;
		foreach (part in [this.Const.BodyPart.Head, this.Const.BodyPart.Body]) { b.Armor[part] = boss ? 250 : 60; b.ArmorMax[part] = b.Armor[part]; }
		this.m.Hitpoints = b.Hitpoints; this.m.CurrentProperties = clone b;
		this.m.Skills.removeByID("racial.unhold");
		if (boss) this.m.Skills.add(this.new("$bvvar{privateFolder}/skills/effects/silent_city_resonance_effect"));
	},
	function onDamageReceived(attacker, skill, hit)
	{
		if (typeof attacker == "instance") attacker = attacker.get();
		local bv = ::$bvvar{namespace}, before = bv.snapshotValkyrieDamageState(this);
		local context = bv.getCurrentValkyrieActionContext(attacker, skill);
		local fixed = bv.getValkyrieFixedDamageFrameForHit(hit, this, attacker, skill);
		local result = this.unhold.onDamageReceived(attacker, skill, hit);
		local controller = this.m.Skills.getSkillByID("$bvvar{modId}.effects.silent_city_resonance");
		if (controller != null && this.isAlive() && !this.isDying())
		{
			local after = bv.snapshotValkyrieDamageState(this);
			// Cap by this hit's reported damage so a nested bonus cannot turn a zero-damage hit into a break.
			local reported = hit == null ? 0 : hit.DamageInflictedHitpoints + hit.DamageInflictedArmor;
			local actual = before.Hitpoints + before.HeadArmor + before.BodyArmor - after.Hitpoints - after.HeadArmor - after.BodyArmor;
			controller.recordHit(attacker, skill, context, fixed != null, this.Math.min(reported, actual));
		}
		return result;
	},
	function generateCorpse(tile, fatality, killer) { local corpse = this.unhold.generateCorpse(tile, fatality, killer); corpse.CorpseName = this.getName(); return corpse; }
});
