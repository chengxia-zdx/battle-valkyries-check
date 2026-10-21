this.yuno_destined_hunt_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, OwnerID = null },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.yuno_destined_hunt";
		this.m.Name = "$bv{effect.yuno_destined_hunt.name}";
		this.m.Description = "$bv{effect.yuno_destined_hunt.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/yuno_oracle_guard.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/yuno_oracle_guard_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking = false;
		this.m.OwnerRef = null;
		this.m.OwnerID = null;
	}

	function setYunoOwner( _owner )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		return this;
	}

	function getYunoOwner()
	{
		local owner = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
		return owner != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == this.m.OwnerID ? owner : null;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{effect.yuno_destined_hunt.tooltip.hit}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.yuno_destined_hunt.tooltip.damage}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.yuno_destined_hunt.tooltip.duration}" }
		];
	}

	function isEligibleAttackSource( _attacker, _usedSkill )
	{
		local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_attacker, _usedSkill);
		if (frame == null || !("Source" in frame) || frame.Source == null) return true;
		local source = frame.Source;
		return source != "dot" && source != "terrain" && source != "reflection"
			&& source != "fixed" && (typeof source != "string" || source.find("fixed") == null);
	}

	function getValkyrieAttackDefensePolicy( _usedSkill )
	{
		local owner = this.getYunoOwner();
		local attacker = null;
		try { attacker = _usedSkill.getContainer().getActor(); } catch (e) { attacker = null; }
		if (owner == null || attacker == null || !::$bvvar{namespace}.isDirectAttack(_usedSkill)
			|| !this.isEligibleAttackSource(attacker, _usedSkill)
			|| !attacker.isAlliedWith(owner))
		{
			return null;
		}
		return { HitChanceBonus = 15 };
	}

	function onUpdate( _properties )
	{
		_properties.DamageReceivedRegularMult *= 1.20;
		_properties.DamageReceivedArmorMult *= 1.20;
	}

	function onRefresh()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_34", actor.getTile());
	}

	function onNewRound()
	{
		this.removeSelf();
	}

	function onDeath( _fatalityType )
	{
		this.removeSelf();
	}

	function onCombatFinished()
	{
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
