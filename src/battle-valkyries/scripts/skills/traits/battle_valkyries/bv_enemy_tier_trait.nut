// Ordinary NPC trait: no Valkyrie identity, managed skills or player progression.
this.bv_enemy_tier_trait <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "trait.bv_enemy_tier";
		this.m.Name = "$bv{enemy_expansion.trait.name}";
		this.m.Description = "$bv{enemy_expansion.trait.description}";
		this.m.Icon = "ui/traits/trait_brute.png";
		this.m.Type = this.Const.SkillType.Trait;
		this.m.Order = this.Const.SkillOrder.Trait;
		this.m.IsActive = false;
		this.m.IsHidden = true;
		this.m.IsStacking = false;
	}
	function onDeath( _fatalityType )
	{
		local actor = this.getContainer().getActor();
		if (actor != null) ::$bvvar{namespace}.EnemyRewards.death(actor);
	}
	function onUpdate( _properties )
	{
		local actor = this.getContainer().getActor();
		if (actor == null) return;
		local key = actor.getFlags().get("BVExpandedEnemyKey");
		local def = ::$bvvar{namespace}.getExpandedEnemyDefinition(key);
		if (def == null) return;
		if (key == "orcs_t25" || key == "orcs_t4") _properties.Bravery -= 15;
		local profile = ::$bvvar{namespace}.getExpandedEnemyCombatProfile(key);
		if (profile != null)
		{
			// Multiplication of HitpointsMult also scales racial HP added later.
			_properties.HitpointsMult *= profile.Hitpoints;
			_properties.DamageTotalMult *= profile.Damage;
			foreach (property, delta in profile.Add) _properties[property] += delta;
			return;
		}
		local tier = ::$bvvar{namespace}.ExpandedEnemyTiers[def.Tier];
		// Modify each freshly calculated property set, never persistent base values.
		_properties.HitpointsMult *= tier.Hitpoints;
		_properties.DamageTotalMult *= tier.Damage;
		_properties.MeleeSkill += tier.Attack;
		_properties.RangedSkill += tier.Attack;
		_properties.MeleeDefense += tier.Defense;
		_properties.RangedDefense += tier.Defense;
	}
});
