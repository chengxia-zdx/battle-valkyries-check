this.sparxie_audience_buff_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = null
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.sparxie_audience_buff.unconfigured";
		this.m.Name = "$bv{effect.sparxie_audience_buff.name}";
		this.m.Description = "$bv{effect.sparxie_audience_buff.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/sparxie_backstage_trick.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/sparxie_backstage_trick_sw.png";
		this.m.IconMini <- "status_effect_106_mini";
		this.m.IsStacking = false;
	}

	function setupOwner( _owner )
	{
		this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.ID = "$bvvar{modId}.effects.sparxie_audience_buff."
			+ (this.m.OwnerID == null ? "missing" : this.m.OwnerID.tostring());
	}

	function isSparxieAudienceBuffEffect()
	{
		return true;
	}

	function getOwner()
	{
		local owner = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Owner);
		if (owner == null
			|| ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) != this.m.OwnerID
			|| ::$bvvar{namespace}.isActorDeadOrDying(owner))
		{
			return null;
		}

		try
		{
			return owner.isPlacedOnMap() ? owner : null;
		}
		catch (e)
		{
			return null;
		}
	}

	function isOwnedBy( _owner )
	{
		return _owner != null
			&& this.m.OwnerID != null
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner) == this.m.OwnerID;
	}

	function getPassive()
	{
		local owner = this.getOwner();
		if (owner == null)
		{
			return null;
		}

		try
		{
			return owner.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("sparxie_backstage_trick"));
		}
		catch (e)
		{
			return null;
		}
	}

	function getSourceSkill( _actor, _skill, _target )
	{
		local policy = null;
		try
		{
			policy = ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(_actor, _skill, _target);
		}
		catch (e)
		{
			policy = null;
		}

		if (policy == null || !("SourceSkillRef" in policy))
		{
			return null;
		}

		return ::$bvvar{namespace}.readValkyrieCombatWeakRef(policy.SourceSkillRef);
	}

	function getSourceSkillKey( _sourceSkill )
	{
		try
		{
			return _sourceSkill == null ? null : _sourceSkill.getBattleValkyriesSkillKey();
		}
		catch (e)
		{
			return null;
		}
	}

	function isSparxieExclusiveAttack( _key )
	{
		return _key == "sparxie_backstage_trick"
			|| _key == "sparxie_live_connection"
			|| _key == "sparxie_carnival_live";
	}

	function getCurrentSource( _actor, _skill )
	{
		try
		{
			local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(_actor, _skill);
			return frame == null ? null : frame.Source;
		}
		catch (e)
		{
			return null;
		}
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "counter"
			|| _source == "followup" || _source == "fixed_damage"
			|| _source == "damage_over_time" || _source == "free";
	}

	function isEligibleActor( _owner, _actor )
	{
		if (_owner == null || _actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
		{
			return false;
		}

		local ownerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		local actorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
		if (_owner == _actor || (ownerID != null && ownerID == actorID))
		{
			return true;
		}

		return ::$bvvar{namespace}.isEligibleRosterAlly(_owner, _actor);
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		local passive = this.getPassive();
		local owner = this.getOwner();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (_properties == null || passive == null || passive.getSmile() <= 0
			|| !this.isEligibleActor(owner, actor)
			|| !::$bvvar{namespace}.isActiveWeaponAttack(_skill))
		{
			return;
		}

		// Sparxie's three dedicated attacks already apply the complete +4%
		// per-Smile multiplier in their weapon attack Spec.
		local sourceSkill = this.getSourceSkill(actor, _skill, _target);
		local sourceSkillKey = this.getSourceSkillKey(sourceSkill);
		if (this.isSparxieExclusiveAttack(sourceSkillKey))
		{
			return;
		}

		local source = this.getCurrentSource(actor, _skill);
		if (source == "followup")
		{
			// Dedicated managed actives commonly deliver their player-selected
			// direct attack through a neutral child carrier. Preserve the team
			// bonus for those active-owned strikes, while passive follow-ups
			// (Himeko, Feixiao, Audience Gift, etc.) remain excluded.
			local isActiveSource = false;
			try
			{
				isActiveSource = sourceSkill != null && sourceSkill.isActive();
			}
			catch (e)
			{
				isActiveSource = false;
			}
			if (!isActiveSource)
			{
				return;
			}
		}
		else if (this.isExcludedSource(source))
		{
			return;
		}

		_properties.DamageRegularMult *= 1.0 + passive.getSmile() * 0.02;
	}

	function getTooltip()
	{
		local owner = this.getOwner();
		local passive = this.getPassive();
		local ownerName = owner == null ? "$bv{effect.sparxie_audience_buff.tooltip.owner_missing}" : owner.getName();
		local smile = passive == null ? 0 : passive.getSmile();
		return [
			{ id = 1, type = "title", text = this.getName() + " (" + smile + "/6)" },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.sparxie_audience_buff.tooltip.owner}" + ownerName },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.sparxie_audience_buff.tooltip.damage_prefix}" + (smile * 2) + "$bv{effect.sparxie_audience_buff.tooltip.damage_suffix}" }
		];
	}

	function onCombatFinished()
	{
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
