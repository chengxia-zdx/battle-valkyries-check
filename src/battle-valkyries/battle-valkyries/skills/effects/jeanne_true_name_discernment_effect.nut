this.jeanne_true_name_discernment_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft = 1 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_true_name_discernment";
		this.m.Name = "$bv{effect.jeanne_true_name_discernment.name}";
		this.m.Description = "$bv{effect.jeanne_true_name_discernment.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_true_name_divine_judgement.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_true_name_divine_judgement_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking = false;
		this.m.TurnsLeft = 1;
	}

	function applyImmediateControl()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return;
		try { actor.setActionPoints(this.Math.max(0, actor.getActionPoints() - 3)); } catch (e) {}
		try { ::$bvvar{namespace}.addOrRefreshStatus(null, actor, { Type="dazed", Turns=1 }); } catch (e) {}
		actor.setDirty(true);
	}

	function onAdded() { this.m.TurnsLeft = 1; this.applyImmediateControl(); }
	function onRefresh() { this.m.TurnsLeft = 1; this.applyImmediateControl(); }
	function onUpdate( _properties ) { _properties.DamageTotalMult *= 0.80; _properties.MeleeDefense -= 10; _properties.RangedDefense -= 10; }
	function onTurnEnd() { this.m.TurnsLeft--; if (this.m.TurnsLeft <= 0) this.removeSelf(); }
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/regular_damage.png", text="$bv{effect.jeanne_true_name_discernment.tooltip.damage}" },
			{ id=4, type="text", icon="ui/icons/melee_defense.png", text="$bv{effect.jeanne_true_name_discernment.tooltip.defense}" },
			{ id=5, type="text", icon="ui/icons/action_points.png", text="$bv{effect.jeanne_true_name_discernment.tooltip.control}" }
		];
	}
});
