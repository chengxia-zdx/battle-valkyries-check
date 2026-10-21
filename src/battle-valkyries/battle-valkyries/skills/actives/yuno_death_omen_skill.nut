this.yuno_death_omen_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { UsesThisTurn = 0 },

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
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
		this.m.UsesThisTurn = 0;
	}

	function getActionPointCost()
	{
		return this.m.UsesThisTurn * 6;
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable() && actor != null && !::$bvvar{namespace}.isActorDeadOrDying(actor)
			&& actor.getActionPoints() >= this.getActionPointCost();
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.yuno_death_omen.tooltip.attack}" },
			{ id = 5, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.yuno_death_omen.tooltip.followup}" },
			{ id = 6, type = "text", icon = "ui/icons/action_points.png", text = "$bv{skill.yuno_death_omen.tooltip.refund}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.yuno_death_omen.tooltip.duration}" }
		];
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return actor != null && target != null && !target.isAlliedWith(actor) && target.isAttackable()
			&& _originTile.getDistanceTo(_targetTile) <= 6
			&& !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& target.getSkills().getSkillByID("$bvvar{modId}.effects.yuno_death_omen") == null;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user)
			|| _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}
		local target = _targetTile.getEntity();
		if (target == null || target.isAlliedWith(_user) || !target.isAttackable()
			|| ::$bvvar{namespace}.isActorDeadOrDying(target)
			|| target.getSkills().getSkillByID("$bvvar{modId}.effects.yuno_death_omen") != null)
		{
			return false;
		}
		local effect = this.new("$bvvar{privateFolder}/skills/effects/yuno_death_omen_effect");
		effect.setYunoOwner(_user);
		target.getSkills().add(effect);
		if (target.getSkills().getSkillByID("$bvvar{modId}.effects.yuno_death_omen") != effect)
		{
			return false;
		}
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "yuno_omen");
		this.m.UsesThisTurn++;
		return true;
	}

	function onTurnStart()
	{
		this.m.UsesThisTurn = 0;
	}

	function onCombatStarted()
	{
		this.m.UsesThisTurn = 0;
	}

	function onCombatFinished()
	{
		this.m.UsesThisTurn = 0;
		this.skill.onCombatFinished();
	}
});
