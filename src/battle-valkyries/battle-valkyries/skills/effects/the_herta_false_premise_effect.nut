this.the_herta_false_premise_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { ActionPointPenalty = 2, InitiativePenalty = 30, AppliedCurrentAP = false },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.the_herta_false_premise";
		this.m.Name = "$bv{effect.the_herta_false_premise.name}";
		this.m.Description = "$bv{effect.the_herta_false_premise.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/the_herta_false_premise.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/the_herta_false_premise_sw.png";
		this.m.IsStacking = false;
		this.m.IsSerialized = false;
	}
	function refresh()
	{
		// The effect already lasts through the target's next completed action.
		// Reapplying it before then refreshes presentation only and must not deduct
		// current Action Points a second time.
		try { this.getContainer().update(); } catch (e) {}
	}
	function onAdded()
	{
		if (this.m.AppliedCurrentAP) return;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return;
		try { actor.getSkills().update(); } catch (e) {}
		try { actor.setActionPoints(this.Math.max(0, actor.getActionPoints() - this.m.ActionPointPenalty)); } catch (e) {}
		this.m.AppliedCurrentAP = true;
	}
	function onUpdate( _properties )
	{
		_properties.Initiative -= this.m.InitiativePenalty;
		_properties.ActionPoints -= this.Math.min(this.m.ActionPointPenalty, this.Math.max(0, _properties.ActionPoints - 6));
	}
	function onTurnEnd() { this.removeSelf(); }
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/initiative.png", text = "$bv{effect.the_herta_false_premise.tooltip.initiative}" },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.the_herta_false_premise.tooltip.ap}" }
		];
	}
});
