this.hakurei_reimu_sealing_charm_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Armed = false },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.hakurei_reimu_sealing_charm";
		this.m.Name = "$bv{effect.hakurei_reimu_sealing_charm.name}";
		this.m.Description = "$bv{effect.hakurei_reimu_sealing_charm.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/hakurei_reimu_hakurei_amulet.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/hakurei_reimu_hakurei_amulet_sw.png";
		this.m.IconMini <- "status_effect_91_mini";
		this.m.Overlay <- "status_effect_91";
		this.m.IsStacking = false;
		this.m.Armed = false;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeSkill -= 10;
		_properties.RangedSkill -= 10;
	}

	function onRefresh()
	{
		this.m.Armed = false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null && actor.isPlacedOnMap()) this.spawnIcon("status_effect_91", actor.getTile());
	}

	function onTurnStart() { this.m.Armed = true; }
	function onTurnEnd() { if (this.m.Armed) this.removeSelf(); }
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/melee_skill.png", text = "$bv{effect.hakurei_reimu_sealing_charm.tooltip.attack}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.hakurei_reimu_sealing_charm.tooltip.duration}" }
		];
	}
});
