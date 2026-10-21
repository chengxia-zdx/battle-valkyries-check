this.jeanne_alter_black_flame_curse_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, OwnerID = null, TurnsLeft = 2, FirstPenaltyApplied = false, FixedDamage = 10 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_alter_black_flame_curse";
		this.m.Name = "$bv{effect.jeanne_alter_black_flame_curse.name}";
		this.m.Description = "$bv{effect.jeanne_alter_black_flame_curse.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_alter_black_flame_curse_effect.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_alter_black_flame_curse_effect_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.OwnerRef = null;
		this.m.OwnerID = null;
		this.m.TurnsLeft = 2;
		this.m.FirstPenaltyApplied = false;
		this.m.FixedDamage = 10;
	}

	function setJeanneAlterOwner( _owner )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		return this;
	}

	function getJeanneAlterOwner()
	{
		local owner = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
		return owner != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == this.m.OwnerID ? owner : null;
	}

	function removeFromContainer()
	{
		local container = this.getContainer();
		if (container != null) container.remove(this);
	}

	function applyFirstPenalty()
	{
		if (this.m.FirstPenaltyApplied) return;
		this.m.FirstPenaltyApplied = true;
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) return;
		try { target.setActionPoints(this.Math.max(0, target.getActionPoints() - 3)); target.setDirty(true); } catch (e) {}
	}

	function onAdded() { this.applyFirstPenalty(); }

	function onRefresh()
	{
		this.m.TurnsLeft = 2;
	}

	function isJeanneMeleeWeaponAttack( _usedSkill )
	{
		if (_usedSkill == null || !::$bvvar{namespace}.isActiveWeaponAttack(_usedSkill)) return false;
		try { return !_usedSkill.isRanged(); } catch (e) { return false; }
	}

	function isJeanneAlterRuinAttack( _attacker, _usedSkill )
	{
		try
		{
			local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_attacker, _usedSkill);
			return frame != null && "Source" in frame && frame.Source == "jeanne_alter_ruin";
		}
		catch (e) { return false; }
	}

	function getValkyrieAttackDefensePolicy( _usedSkill )
	{
		local owner = this.getJeanneAlterOwner();
		local attacker = null;
		try { attacker = _usedSkill.getContainer().getActor(); } catch (e) { attacker = null; }
		if (owner == null || attacker == null || attacker != owner || this.isJeanneAlterRuinAttack(attacker, _usedSkill) || !this.isJeanneMeleeWeaponAttack(_usedSkill)) return null;
		return { HitChanceBonus = 15 };
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints -= 2;
		_properties.MeleeDefense -= 10;
		_properties.RangedDefense -= 10;
		_properties.Bravery -= 15;
	}

	function onTurnStart()
	{
		local target = this.getContainer() == null ? null : this.getContainer().getActor();
		local owner = this.getJeanneAlterOwner();
		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner))
		{
			this.removeFromContainer();
			return;
		}
		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, target, this.m.FixedDamage, { Source = "jeanne_alter_black_flame" });
		if (::$bvvar{namespace}.isActorDeadOrDying(target)) this.removeFromContainer();
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft--;
		if (this.m.TurnsLeft <= 0) this.removeFromContainer();
	}

	function onDeath( _fatalityType ) { this.removeFromContainer(); }
	function onCombatFinished() { this.removeFromContainer(); this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.jeanne_alter_black_flame_curse.tooltip.ap}" },
			{ id = 4, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{effect.jeanne_alter_black_flame_curse.tooltip.damage}" }
		];
	}
});
