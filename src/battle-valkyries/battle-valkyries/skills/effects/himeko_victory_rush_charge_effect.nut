this.himeko_victory_rush_charge_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		Count = 0,
		ChargeIcon = "skills/$bvvar{iconPrefix}/himeko_fire_support_calibration.png",
		ReadyIcon = "skills/$bvvar{iconPrefix}/himeko_orbital_suppression.png"
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.himeko_victory_rush_charge";
		this.m.Name = "$bv{effect.himeko_victory_rush_charge.name}";
		this.m.Description = "$bv{effect.himeko_victory_rush_charge.description}";
		this.m.ChargeIcon <- "skills/$bvvar{iconPrefix}/himeko_fire_support_calibration.png";
		this.m.ReadyIcon <- "skills/$bvvar{iconPrefix}/himeko_orbital_suppression.png";
		this.m.Icon = this.m.ChargeIcon;
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/himeko_fire_support_calibration_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Count = 0;
	}

	function getCount() { return this.Math.max(0, this.m.Count); }

	function refreshReadyMarker( _wasReady )
	{
		local ready = this.isReady();
		this.m.Icon = ready ? this.m.ReadyIcon : this.m.ChargeIcon;
		this.m.IconDisabled = ready
			? "skills/$bvvar{iconPrefix}/himeko_orbital_suppression_sw.png"
			: "skills/$bvvar{iconPrefix}/himeko_fire_support_calibration_sw.png";
		if (!_wasReady && ready)
		{
			local actor = this.getContainer() == null ? null : this.getContainer().getActor();
			// status_effect_75 is not present in every BB resource set. The stable
			// status_effect_34 marker is already used by the mod's combat effects.
			try { if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_34", actor.getTile()); } catch (e) {}
			try
			{
				if (actor != null && actor.isPlacedOnMap() && "playValkyrieVisual" in ::$bvvar{namespace})
					::$bvvar{namespace}.playValkyrieVisual(this, actor, "himeko_owner_ring");
			}
			catch (e) {}
		}
	}

	function setCount( _count )
	{
		local wasReady = this.isReady();
		this.m.Count = this.Math.max(0, _count);
		this.refreshReadyMarker(wasReady);
		return this.m.Count;
	}
	function addCount( _amount = 1 ) { return this.setCount(this.m.Count + _amount); }
	function clear() { this.setCount(0); }
	function isReady() { return this.getCount() >= 3; }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.himeko_victory_rush_charge.tooltip.count_prefix}" + this.getCount() + "$bv{effect.himeko_victory_rush_charge.tooltip.count_suffix}" },
			{ id = 4, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{effect.himeko_victory_rush_charge.tooltip.gain}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.himeko_victory_rush_charge.tooltip.ready}" }
		];
	}

	function onCombatStarted() { this.clear(); }
	function onCombatFinished() { this.clear(); this.skill.onCombatFinished(); }
});
