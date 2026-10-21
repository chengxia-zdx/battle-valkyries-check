this.morgan_lake_grace_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { ReadyRound = -2 },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsAttack = false; this.m.IsRanged = false; this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false; this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true; this.m.ActionPointCost = 2; this.m.FatigueCost = 15;
		this.m.MinRange = 0; this.m.MaxRange = 4; this.m.MaxRangeBonus = 0;
	}
	function isReady() { return ::$bvvar{namespace}.getMorganRound() >= this.m.ReadyRound; }
	function isUsable() { return this.skill.isUsable() && this.isReady(); }
	function onVerifyTarget( _origin, _tile )
	{
		if (_tile == null || !_tile.IsOccupiedByActor || _origin.getDistanceTo(_tile) > 4) return false;
		local actor = this.getContainer().getActor(); local target = _tile.getEntity();
		return !::$bvvar{namespace}.isActorDeadOrDying(actor) && !::$bvvar{namespace}.isActorDeadOrDying(target)
			&& actor.isAlliedWith(target) && (_origin.ID == _tile.ID || _origin.hasLineOfSightTo(_tile, 4));
	}
	function onUse( _user, _tile )
	{
		if (_user == null || !this.isReady() || !this.onVerifyTarget(_user.getTile(), _tile)) return false;
		this.m.ReadyRound = ::$bvvar{namespace}.getMorganRound() + 3;
		foreach (tile in ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(), 4, true))
		{
			if (!tile.IsOccupiedByActor) continue;
			local ally = tile.getEntity();
			if (!_user.isAlliedWith(ally) || ::$bvvar{namespace}.isActorDeadOrDying(ally)) continue;
			::$bvvar{namespace}.applyMorganEffect(ally, "morgan_charisma", _user);
		}
		local target = _tile.getEntity();
		// skill.use already paid the two AP and fifteen fatigue before onUse.
		target.setActionPoints(this.Math.min(target.getActionPointsMax(), target.getActionPoints() + 4));
		target.setFatigue(this.Math.max(0, target.getFatigue() - 30));
		target.setDirty(true);
		// Deliberately never reset turn-done flags or request an extra turn.
		local passive = ::$bvvar{namespace}.getRuntimeSkillByKey(_user, "morgan_from_worlds_end");
		if (passive != null) passive.addMana(2);
		::$bvvar{namespace}.playValkyrieVisual(this, _user, "morgan_cast");
		::$bvvar{namespace}.playValkyrieVisual(this, target, "morgan_blessing");
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "morgan_lake_grace_cast");
		return true;
	}
	function onCombatStarted() { this.m.ReadyRound = -2; }
	function onCombatFinished() { this.onCombatStarted(); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		local ret = [ {id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.morgan_lake_grace.tooltip.charisma}"},
			{id=5,type="text",icon="ui/icons/action_points.png",text="$bv{skill.morgan_lake_grace.tooltip.grace}"},
			{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.morgan_lake_grace.tooltip.cooldown}"} ];
		if (!this.isReady()) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.morgan_lake_grace.tooltip.remaining}"+(this.m.ReadyRound-::$bvvar{namespace}.getMorganRound())});
		return ret;
	}
});
