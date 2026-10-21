this.kafka_script_protagonist_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		DirectorRef = null,
		DirectorID = null,
		DirectionRef = null,
		DirectionID = null,
		Applied = false,
		Removed = false
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.kafka_script_protagonist";
		this.m.Name = "$bv{effect.kafka_script_protagonist.name}";
		this.m.Description = "$bv{effect.kafka_script_protagonist.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/kafka_spirit_whisper.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/kafka_spirit_whisper_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
		this.m.IsStacking = false;
		this.m.Applied = false;
		this.m.Removed = false;
	}

	function setKafkaDirector( _director, _direction )
	{
		this.m.DirectorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_director);
		this.m.DirectorID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_director);
		this.m.DirectionRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_direction);
		this.m.DirectionID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_direction);
		return this;
	}

	function getKafkaDirection()
	{
		local direction = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.DirectionRef);
		return direction != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(direction) == this.m.DirectionID ? direction : null;
	}

	function isKafkaDirectiveApplied()
	{
		return this.m.Applied && !this.m.Removed;
	}

	function onAdded()
	{
		this.m.Applied = true;
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += 6;
		_properties.Hitpoints += 10;
		_properties.Bravery += 10;
		_properties.Stamina += 10;
		_properties.MeleeSkill += 10;
		_properties.RangedSkill += 10;
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
		_properties.Initiative += 10;
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.kafka_script_protagonist.tooltip.ap}" },
			{ id = 4, type = "text", icon = "ui/icons/health.png", text = "$bv{effect.kafka_script_protagonist.tooltip.attributes}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.kafka_script_protagonist.tooltip.duration}" }
		];
	}

	function scheduleKafkaResourceClamp( _actor )
	{
		local actorRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_actor);
		::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _tag )
		{
			local actor = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.ActorRef);
			if (actor == null) return;
			try { actor.setHitpoints(::Math.min(actor.getHitpoints(), actor.getHitpointsMax())); } catch (e) {}
			try { actor.setActionPoints(::Math.min(actor.getActionPoints(), actor.getActionPointsMax())); } catch (e) {}
			try { actor.setDirty(true); } catch (e) {}
		}, { ActorRef = actorRef });
	}

	function onRemoved()
	{
		if (this.m.Removed) return;
		this.m.Removed = true;
		this.m.Applied = false;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor != null) this.scheduleKafkaResourceClamp(actor);
		local direction = this.getKafkaDirection();
		if (direction != null) direction.onKafkaDirectiveEffectRemoved(this, actor);
	}

	function prepareKafkaDirectiveRemoval( _reason )
	{
		return true;
	}

	function onDeath( _fatalityType )
	{
		this.onRemoved();
		this.removeSelf();
	}

	function onCombatFinished()
	{
		this.onRemoved();
		this.removeSelf();
		this.skill.onCombatFinished();
	}
});
