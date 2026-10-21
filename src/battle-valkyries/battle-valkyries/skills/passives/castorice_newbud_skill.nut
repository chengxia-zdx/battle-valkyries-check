this.castorice_newbud_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Newbud = 0,
		NewbudMax = 100
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function getNewbudMax()
	{
		return this.m.NewbudMax;
	}

	function getNewbud()
	{
		return this.Math.max(0, this.Math.min(this.m.NewbudMax, this.m.Newbud));
	}

	function hasFullNewbud()
	{
		return this.getNewbud() >= this.getNewbudMax();
	}

	function addNewbud( _amount )
	{
		if (_amount <= 0)
		{
			return this.getNewbud();
		}

		this.m.Newbud = this.Math.min(this.m.NewbudMax, this.getNewbud() + _amount);
		local actor = this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap())
		{
			this.spawnIcon("status_effect_75", actor.getTile());
			actor.setDirty(true);
		}

		return this.getNewbud();
	}

	function spendNewbud( _amount )
	{
		if (_amount <= 0)
		{
			return true;
		}

		if (this.getNewbud() < _amount)
		{
			return false;
		}

		this.m.Newbud = this.getNewbud() - _amount;
		local actor = this.getContainer().getActor();
		if (actor != null)
		{
			actor.setDirty(true);
		}

		return true;
	}

	function resetNewbud()
	{
		this.m.Newbud = 0;
	}

	function getTooltip()
	{
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
				icon = "ui/icons/health.png",
				text = "$bv{skill.castorice_newbud.tooltip.health}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.castorice_newbud.tooltip.current_prefix}" + this.getNewbud() + "/" + this.getNewbudMax()
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.castorice_newbud.tooltip.full}"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += 48;
	}

	function onCombatStarted()
	{
		this.resetNewbud();
	}

	function onCombatFinished()
	{
		this.resetNewbud();
		this.skill.onCombatFinished();
	}
});
