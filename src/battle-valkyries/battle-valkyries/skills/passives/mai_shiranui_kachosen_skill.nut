this.mai_shiranui_kachosen_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		BonusDamageUsedThisTurn = false,
		ProcessedActionTokens = null
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.BonusDamageUsedThisTurn = false;
		this.m.ProcessedActionTokens = {};
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.mai_shiranui_kachosen.tooltip.penetration}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.mai_shiranui_kachosen.tooltip.fixed}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.mai_shiranui_kachosen.tooltip.rules}" }
		];
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties != null && ::$bvvar{namespace}.isValkyrieThrowingWeaponAttack(_skill))
		{
			_properties.DamageDirectAdd += 0.25;
		}
	}

	function isOwnerThrowingHit( _event )
	{
		if (_event == null || !("Hit" in _event) || !_event.Hit
			|| ("Nullified" in _event && _event.Nullified)
			|| !("ActionToken" in _event) || _event.ActionToken == null
			|| !("Skill" in _event) || !::$bvvar{namespace}.isValkyrieThrowingWeaponAttack(_event.Skill)
			|| !("Target" in _event) || _event.Target == null
			|| ::$bvvar{namespace}.isActorDeadOrDying(_event.Target))
		{
			return false;
		}

		local source = "Source" in _event ? _event.Source : null;
		if (source == "aoo" || source == "riposte" || source == "counter" || source == "followup"
			|| source == "fixed_damage" || source == "damage_over_time")
		{
			return false;
		}

		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner)
			&& "Attacker" in _event
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) == ::$bvvar{namespace}.getValkyrieCombatObjectID(owner);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "ActionResolved")
		{
			if ("ActionToken" in _event && _event.ActionToken in this.m.ProcessedActionTokens)
			{
				delete this.m.ProcessedActionTokens[_event.ActionToken];
			}
			return;
		}
		if (_event.Type != "TargetResolved" || this.m.BonusDamageUsedThisTurn || !this.isOwnerThrowingHit(_event)
			|| _event.ActionToken in this.m.ProcessedActionTokens)
		{
			return;
		}

		this.m.BonusDamageUsedThisTurn = true;
		this.m.ProcessedActionTokens[_event.ActionToken] <- true;
		local owner = this.getContainer().getActor();
		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, _event.Target, 10, {
			ActionToken = _event.ActionToken,
			AttemptToken = "AttemptToken" in _event ? _event.AttemptToken : null,
			Source = "mai_shiranui_kachosen"
		});
	}

	function resetTurnState()
	{
		this.m.BonusDamageUsedThisTurn = false;
		this.m.ProcessedActionTokens = {};
	}

	function onTurnStart() { this.resetTurnState(); }
	function onCombatStarted() { this.resetTurnState(); }
	function onCombatFinished()
	{
		this.resetTurnState();
		this.skill.onCombatFinished();
	}
});
