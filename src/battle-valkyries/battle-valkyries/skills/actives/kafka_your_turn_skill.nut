this.kafka_your_turn_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsUsingHitchance = false;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 15;
		this.m.MinRange = 1;
		this.m.MaxRange = 5;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
	}

	function getKafkaDirection()
	{
		try { return this.getContainer().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("kafka_script_direction")); }
		catch (e) { return null; }
	}

	function isUsable()
	{
		local direction = this.getKafkaDirection();
		return this.skill.isUsable() && direction != null && direction.canIssueKafkaDirective();
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		local direction = this.getKafkaDirection();
		return owner != null && target != null && direction != null && direction.canIssueKafkaDirective()
			&& target.getID() != owner.getID() && target.isAlliedWith(owner) && target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& _originTile.getDistanceTo(_targetTile) >= 1 && _originTile.getDistanceTo(_targetTile) <= 5
			&& !direction.isSameKafkaDirective(target, "$bvvar{modId}.effects.kafka_script_protagonist");
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local target = _targetTile.getEntity();
		local direction = this.getKafkaDirection();
		local applied = direction != null && target != null && direction.issueKafkaDirective("ally", target);
		if (applied && "playValkyrieVisual" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.playValkyrieVisual(this, _user, "kafka_command_cast");
			::$bvvar{namespace}.playValkyrieVisual(this, target, "kafka_protagonist");
		}
		return applied;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.kafka_your_turn.tooltip.ap}" },
			{ id = 5, type = "text", icon = "ui/icons/health.png", text = "$bv{skill.kafka_your_turn.tooltip.attributes}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.kafka_your_turn.tooltip.duration}" }
		];
		local direction = this.getKafkaDirection();
		if (direction != null && !direction.canIssueKafkaDirective()) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.kafka.shared.spent}" });
		return ret;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
	}
});
