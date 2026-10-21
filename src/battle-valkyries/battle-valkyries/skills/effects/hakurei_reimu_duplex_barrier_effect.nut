this.hakurei_reimu_duplex_barrier_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, OwnerID = null, DefenseBonus = 20, HitpointReduction = 25, InnerAvailable = true },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.hakurei_reimu_duplex_barrier";
		this.m.Name = "$bv{effect.hakurei_reimu_duplex_barrier.name}";
		this.m.Description = "$bv{effect.hakurei_reimu_duplex_barrier.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/hakurei_reimu_duplex_barrier.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/hakurei_reimu_duplex_barrier_sw.png";
		this.m.IconMini <- "status_effect_88_mini";
		this.m.Overlay <- "status_effect_88";
		this.m.IsStacking = false;
		this.m.OwnerRef = null;
		this.m.OwnerID = null;
		this.m.DefenseBonus = 20;
		this.m.HitpointReduction = 25;
		this.m.InnerAvailable = true;
	}

	function configure( _owner, _defenseBonus, _hitpointReduction )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.DefenseBonus = _defenseBonus;
		this.m.HitpointReduction = _hitpointReduction;
		this.m.InnerAvailable = true;
		return this;
	}

	function getOwner()
	{
		local owner = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
		return owner != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == this.m.OwnerID ? owner : null;
	}

	function isOwnedBy( _owner )
	{
		return _owner != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner) == this.m.OwnerID;
	}

	function getPassive()
	{
		local owner = this.getOwner();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "hakurei_reimu_inborn_intuition");
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += this.m.DefenseBonus;
		_properties.RangedDefense += this.m.DefenseBonus;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (!this.m.InnerAvailable || _hitInfo == null || !("DamageRegular" in _hitInfo) || _hitInfo.DamageRegular <= 0) return;
		local direct = "DamageDirect" in _hitInfo ? _hitInfo.DamageDirect : 0.0;
		if (direct <= 0.0)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			local armor = 1;
			try { armor = actor.getArmor(_hitInfo.BodyPart); } catch (e) { armor = 1; }
			if (armor > 0) return;
			direct = 1.0;
		}
		local potential = this.Math.floor(_hitInfo.DamageRegular * direct);
		if (potential <= 0) return;
		local prevented = this.Math.min(this.m.HitpointReduction, potential);
		local regularReduction = prevented.tofloat() / direct;
		_hitInfo.DamageRegular = this.Math.max(0, _hitInfo.DamageRegular - regularReduction);
		this.m.InnerAvailable = false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_88", actor.getTile());
	}

	function onMissed( _attacker, _skill )
	{
		this.skill.onMissed(_attacker, _skill);
		local owner = this.getOwner();
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null || target == null || _attacker == null || _skill == null || !::$bvvar{namespace}.isDirectAttack(_skill)) return;
		try { if (_attacker.isAlliedWith(owner)) return; } catch (e) { return; }
		local passive = this.getPassive();
		if (passive != null) passive.claimDefensiveSpirit();
	}

	function onRefresh() { this.m.InnerAvailable = true; }
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/melee_defense.png", text = "$bv{effect.hakurei_reimu_duplex_barrier.tooltip.outer}" },
			{ id = 4, type = "text", icon = "ui/icons/health.png", text = this.m.InnerAvailable ? "$bv{effect.hakurei_reimu_duplex_barrier.tooltip.inner_ready}" : "$bv{effect.hakurei_reimu_duplex_barrier.tooltip.inner_spent}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.hakurei_reimu_duplex_barrier.tooltip.duration}" }
		];
	}
});
