this.kafka_spirit_control_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = {
		DirectorRef = null,
		DirectorID = null,
		DirectionRef = null,
		DirectionID = null,
		ControlHandle = null,
		Applied = false,
		Removed = false
	},

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.kafka_spirit_control";
		this.m.Name = "$bv{effect.kafka_spirit_control.name}";
		this.m.Description = "$bv{effect.kafka_spirit_control.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/kafka_listen_to_me.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/kafka_listen_to_me_sw.png";
		this.m.IconMini <- "status_effect_53_mini";
		this.m.Overlay <- "status_effect_53";
		this.m.IsStacking = false;
		this.m.ControlHandle = null;
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

	function getKafkaDirector()
	{
		local director = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.DirectorRef);
		return director != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(director) == this.m.DirectorID ? director : null;
	}

	function getKafkaDirection()
	{
		local direction = ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.DirectionRef);
		return direction != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(direction) == this.m.DirectionID ? direction : null;
	}

	function isKafkaDirectiveApplied()
	{
		return this.m.Applied && !this.m.Removed && this.m.ControlHandle != null
			&& this.m.ControlHandle.Active && !this.m.ControlHandle.Restored;
	}

	function onAdded()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local director = this.getKafkaDirector();
		this.m.ControlHandle = ::$bvvar{namespace}.acquireValkyrieTemporaryPlayerControl(actor, director);
		this.m.Applied = this.m.ControlHandle != null;
	}

	function shouldReleaseKafkaControlForLastHostile()
	{
		return this.m.ControlHandle != null && ::$bvvar{namespace}.isValkyrieTemporaryControlLastHostile(this.m.ControlHandle);
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.kafka_spirit_control.tooltip.control}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.kafka_spirit_control.tooltip.preserve}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.kafka_spirit_control.tooltip.duration}" }
		];
	}

	function restoreKafkaControl( _reason )
	{
		if (this.m.ControlHandle == null) return true;
		local restored = ::$bvvar{namespace}.restoreValkyrieTemporaryPlayerControl(this.m.ControlHandle, _reason);
		if (restored) this.m.ControlHandle = null;
		return restored;
	}

	function prepareKafkaDirectiveRemoval( _reason )
	{
		return this.restoreKafkaControl(_reason);
	}

	function onRemoved()
	{
		if (this.m.Removed) return;
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (!this.restoreKafkaControl("effect_removed")) return;
		this.m.Removed = true;
		this.m.Applied = false;
		local direction = this.getKafkaDirection();
		if (direction != null) direction.onKafkaDirectiveEffectRemoved(this, actor);
	}

	function onNewRound()
	{
		local director = this.getKafkaDirector();
		if (director == null || ::$bvvar{namespace}.isActorDeadOrDying(director) || this.shouldReleaseKafkaControlForLastHostile())
		{
			this.onRemoved();
			this.removeSelf();
		}
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
