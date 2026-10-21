this.jingliu_cold_moon_sword_heart_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {},

	function create()
	{
		this.valkyrie_passive_skill.create();
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
				icon = "ui/icons/special.png",
				text = "$bv{skill.jingliu_cold_moon_sword_heart.tooltip.stack}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.jingliu_cold_moon_sword_heart.tooltip.full}"
			}
		];
	}

	function isOwner( _actor )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return actor != null && _actor != null
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(actor) == ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "TargetResolved"
			|| !("Hit" in _event) || !_event.Hit || ("Nullified" in _event && _event.Nullified)
			|| !("Attacker" in _event) || !this.isOwner(_event.Attacker)
			|| !("Skill" in _event) || !::$bvvar{namespace}.isDirectAttack(_event.Skill)
			|| !("Target" in _event) || _event.Target == null)
		{
			return;
		}

		local actor = this.getContainer().getActor();
		if (::$bvvar{namespace}.isActorDeadOrDying(actor) || _event.Target.isAlliedWith(actor)) return;
		actor.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/jingliu_moonlight_effect"));
	}
});
