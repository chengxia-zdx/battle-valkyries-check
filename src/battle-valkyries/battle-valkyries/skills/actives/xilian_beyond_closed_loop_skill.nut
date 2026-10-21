this.xilian_beyond_closed_loop_skill <- this.inherit("$bvvar{privateFolder}/skills/actives/valkyrie_generic_active_skill", {
	function create()
	{
		this.valkyrie_generic_active_skill.create();
	}

	function isUltimateUnlocked()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return false;
		}

		local trait = actor.getSkills().getSkillByID(::$bvvar{namespace}.XilianBondTraitID);
		return trait != null && trait.hasUltimateSkillUnlocked();
	}

	function getName()
	{
		return this.isUltimateUnlocked() ? "$bv{skill.xilian_tomorrow_first_page.name}" : this.m.Name;
	}

	function getDescription()
	{
		return this.isUltimateUnlocked() ? "$bv{skill.xilian_tomorrow_first_page.description}" : this.m.Description;
	}

	function getMaxUses()
	{
		return this.isUltimateUnlocked() ? 2 : this.valkyrie_generic_active_skill.getMaxUses();
	}

	function syncUltimateTargetingRange()
	{
		this.m.MinRange = this.isUltimateUnlocked() ? 0 : this.m.Spec.MinRange;
		this.m.MaxRange = this.isUltimateUnlocked() ? 6 : this.m.Spec.MaxRange;
	}

	function isUsable()
	{
		this.syncUltimateTargetingRange();
		return this.valkyrie_generic_active_skill.isUsable();
	}

	function getMinRange()
	{
		this.syncUltimateTargetingRange();
		return this.m.MinRange;
	}

	function getMaxRange()
	{
		this.syncUltimateTargetingRange();
		return this.m.MaxRange;
	}

	function isInRange( _targetTile, _userTile = null )
	{
		this.syncUltimateTargetingRange();
		return this.skill.isInRange(_targetTile, _userTile);
	}

	function getTooltip()
	{
		this.syncUltimateTargetingRange();
		local upgraded = this.isUltimateUnlocked();
		local ret = [
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
				icon = "ui/icons/fatigue.png",
				text = upgraded ? "$bv{skill.xilian_tomorrow_first_page.tooltip.uses}" : "$bv{skill.generic.once_free}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/vision.png",
				text = upgraded ? "$bv{skill.xilian_tomorrow_first_page.tooltip.range}" : "$bv{skill.xilian_beyond_closed_loop.tooltip.range}"
			}
		];

		local id = 5;

		foreach( row in this.m.Spec.Tooltip )
		{
			ret.push({
				id = id,
				type = "text",
				icon = "Icon" in row ? row.Icon : "ui/icons/special.png",
				text = row.Text
			});
			id = ++id;
		}

		if (upgraded)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.xilian_tomorrow_first_page.tooltip.self}"
			});
			id = ++id;
			ret.push({
				id = id,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.xilian_tomorrow_first_page.tooltip.anchor}"
			});
			id = ++id;
		}

		if (this.getRemainingUses() <= 0)
		{
			ret.push({
				id = id,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.generic.spent}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		this.syncUltimateTargetingRange();

		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();

		if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target) || ::$bvvar{namespace}.isActorDeadOrDying(user))
		{
			return false;
		}

		if (!target.isAlliedWith(user) || !target.isAttackable())
		{
			return false;
		}

		return this.isUltimateUnlocked() || target.getID() != user.getID();
	}

	function applyTomorrowAnchor( _target )
	{
		if (_target == null || _target.getSkills() == null)
		{
			return;
		}

		_target.getSkills().removeByID("$bvvar{modId}.effects.xilian_tomorrow_anchor");
		_target.getSkills().add(this.new("$bvvar{privateFolder}/skills/effects/xilian_tomorrow_anchor_effect"));
		_target.getSkills().update();
		_target.setDirty(true);
	}

	function onUse( _user, _targetTile )
	{
		this.syncUltimateTargetingRange();
		local target = _targetTile == null || !_targetTile.IsOccupiedByActor ? null : _targetTile.getEntity();
		local upgraded = this.isUltimateUnlocked();
		local ret = this.valkyrie_generic_active_skill.onUse(_user, _targetTile);

		if (ret && upgraded)
		{
			this.applyTomorrowAnchor(target);
		}

		return ret;
	}
});
