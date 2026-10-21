this.kafka_listen_to_me_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
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
		// This is a hostile-targeting utility, not an attack. Vanilla's base
		// verifier treats non-attacks as friendly utilities and rejects enemies
		// before the control-specific legality checks can run.
		if (_originTile == null || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		local direction = this.getKafkaDirection();
		return owner != null && target != null && direction != null && direction.canIssueKafkaDirective()
			&& !target.isAlliedWith(owner) && target.isAttackable() && !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& _targetTile.IsVisibleForEntity
			&& _originTile.getDistanceTo(_targetTile) >= 1 && _originTile.getDistanceTo(_targetTile) <= 5
			&& ::$bvvar{namespace}.canAcquireValkyrieTemporaryPlayerControl(target, owner)
			&& !direction.isSameKafkaDirective(target, "$bvvar{modId}.effects.kafka_spirit_control");
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local target = _targetTile.getEntity();
		local direction = this.getKafkaDirection();
		local applied = direction != null && target != null && direction.issueKafkaDirective("enemy", target);
		if (applied && "playValkyrieVisual" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.playValkyrieVisual(this, _user, "kafka_command_cast");
			::$bvvar{namespace}.playValkyrieVisual(this, target, "kafka_control");
		}
		return applied;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.kafka_listen_to_me.tooltip.control}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.kafka_listen_to_me.tooltip.preserve}" },
			{ id = 6, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.kafka_listen_to_me.tooltip.illegal}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.kafka_listen_to_me.tooltip.duration}" }
		];
		local direction = this.getKafkaDirection();
		if (direction != null && !direction.canIssueKafkaDirective()) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.kafka.shared.spent}" });
		return ret;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
	}
});
