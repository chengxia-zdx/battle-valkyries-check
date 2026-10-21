this.cipher_old_patron_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Owner = null,
		OwnerID = 0,
		Kickback = 0,
		MaxKickback = 3,
		FixedDamagePerKickback = 15
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		if (!("IconMini" in this.m)) this.m.IconMini <- "";
		if (!("Overlay" in this.m)) this.m.Overlay <- "";
		this.m.ID = "$bvvar{modId}.effects.cipher_old_patron";
		this.m.Name = "$bv{effect.cipher_old_patron.name}";
		this.m.Description = "$bv{effect.cipher_old_patron.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/cipher_lucky_paw.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/cipher_lucky_paw_sw.png";
		this.m.IconMini <- "status_effect_53_mini";
		this.m.Overlay <- "status_effect_53";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsSerialized = false;
	}

	function setupOwner( _owner )
	{
		this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner);
		this.m.OwnerID = _owner == null ? 0 : _owner.getID();
	}

	function getOwner()
	{
		if (this.m.Owner == null || this.m.Owner.isNull())
		{
			return null;
		}

		local owner = this.m.Owner;
		return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner;
	}

	function isOwnedBy( _owner )
	{
		return _owner != null && this.m.OwnerID != 0 && this.m.OwnerID == _owner.getID();
	}

	function getKickback()
	{
		return this.m.Kickback;
	}

	function getFixedDamage()
	{
		return this.m.Kickback * this.m.FixedDamagePerKickback;
	}

	function getName()
	{
		return this.m.Kickback <= 0 ? this.m.Name : this.m.Name + " (" + this.m.Kickback + "/" + this.m.MaxKickback + ")";
	}

	function addKickback( _amount = 1 )
	{
		if (_amount <= 0 || this.m.Kickback >= this.m.MaxKickback)
		{
			return false;
		}

		local old = this.m.Kickback;
		this.m.Kickback = this.Math.min(this.m.MaxKickback, this.m.Kickback + _amount);

		if (this.m.Kickback != old)
		{
			local container = this.getContainer();
			local actor = container == null ? null : container.getActor();

			if (actor != null && actor.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_53", actor.getTile());
			}

			if (container != null)
			{
				container.update();
			}
		}

		return this.m.Kickback != old;
	}

	function recordAttack( _attacker, _skill )
	{
		if (_attacker == null || _skill == null || !_skill.isAttack() || ::$bvvar{namespace}.isActorDeadOrDying(_attacker))
		{
			return false;
		}

		local owner = this.getOwner();
		local target = this.getContainer() == null ? null : this.getContainer().getActor();

		if (owner == null || target == null || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return false;
		}

		if (!_attacker.isAlliedWith(owner) || target.isAlliedWith(owner))
		{
			return false;
		}

		return this.addKickback(1);
	}

	function getTooltip()
	{
		local owner = this.getOwner();
		local ownerName = owner == null ? "$bv{effect.cipher_old_patron.tooltip.owner_missing}" : owner.getName();
		local damage = this.getFixedDamage();

		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.cipher_old_patron.tooltip.owner}" + ownerName
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{effect.cipher_old_patron.tooltip.kickback}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{effect.cipher_old_patron.tooltip.kickback_prefix}" + this.m.Kickback + "/" + this.m.MaxKickback + "$bv{effect.cipher_old_patron.tooltip.kickback_suffix}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{effect.cipher_old_patron.tooltip.damage_prefix}" + damage + "$bv{effect.cipher_old_patron.tooltip.damage_suffix}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{effect.cipher_old_patron.tooltip.damage}"
			}
		];
	}
});
