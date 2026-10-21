this.sparxie_live_guest_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = null
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.sparxie_live_guest.unconfigured";
		this.m.Name = "$bv{effect.sparxie_live_guest.name}";
		this.m.Description = "$bv{effect.sparxie_live_guest.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/sparxie_live_connection.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/sparxie_live_connection_sw.png";
		this.m.IconMini <- "status_effect_95_mini";
		this.m.IsStacking = false;
	}

	function setupOwner( _owner )
	{
		this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.ID = "$bvvar{modId}.effects.sparxie_live_guest."
			+ (this.m.OwnerID == null ? "missing" : this.m.OwnerID.tostring());
	}

	function isSparxieLiveGuestEffect()
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

		return owner;
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

	function getTooltip()
	{
		local owner = this.getOwner();
		local passive = this.getPassive();
		local ownerName = owner == null ? "$bv{effect.sparxie_live_guest.tooltip.owner_missing}" : owner.getName();
		local gifts = passive == null ? 0 : passive.getGuestGiftsRemaining();
		local rounds = passive == null ? 0 : passive.getGuestRoundsRemaining();
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.sparxie_live_guest.tooltip.owner}" + ownerName },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.sparxie_live_guest.tooltip.gifts_prefix}" + gifts + "$bv{effect.sparxie_live_guest.tooltip.gifts_suffix}" },
			{ id = 5, type = "text", icon = "ui/icons/hourglass.png", text = "$bv{effect.sparxie_live_guest.tooltip.rounds_prefix}" + rounds + "$bv{effect.sparxie_live_guest.tooltip.rounds_suffix}" }
		];
	}

	function onCombatFinished()
	{
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
