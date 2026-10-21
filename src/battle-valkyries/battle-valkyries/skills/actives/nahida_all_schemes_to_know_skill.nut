this.nahida_all_schemes_to_know_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		Radius = 2,
		MaxTargets = 4,
		Cooldown = 3,
		MarkDuration = 3,
		DamageMin = 40,
		DamageMax = 60,
		DirectDamage = 0.25,
		AvailableRound = 0
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.nahida_all_schemes_to_know.killed}";
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = false;
		this.m.IsRanged = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 18;
		this.m.MinRange = 2;
		this.m.MaxRange = 7;
		this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
	}

	function onValkyrieSkillBound( _definition )
	{
		if (_definition == null || !("Spec" in _definition)) return;
		local spec = _definition.Spec;
		foreach (key, target in {
			ActionPointCost = "ActionPointCost", FatigueCost = "FatigueCost", MinRange = "MinRange", MaxRange = "MaxRange",
			Radius = "Radius", MaxTargets = "MaxTargets", Cooldown = "Cooldown", MarkDuration = "MarkDuration",
			DamageMin = "DamageMin", DamageMax = "DamageMax", DirectDamage = "DirectDamage"
		}) if (key in spec) this.m[target] = spec[key];
	}

	function getRound()
	{
		try { return this.Time.getRound(); } catch (e) { return 0; }
	}

	function getPassive()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "nahida_tri_karma_purification");
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getPassive() != null && this.getRound() >= this.m.AvailableRound;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true)
			&& owner.getTile().getDistanceTo(target.getTile()) >= this.m.MinRange;
	}

	function getTargets( _user, _targetTile )
	{
		local tiles = ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, this.m.Radius, true);
		local targets = ::$bvvar{namespace}.sortValkyrieTargetsByDistance(_targetTile, ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, tiles));
		while (targets.len() > this.m.MaxTargets) targets.remove(targets.len() - 1);
		return targets;
	}

	function onTargetSelected( _targetTile )
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null) return;
		foreach (target in this.getTargets(owner, _targetTile))
		{
			local tile = target.getTile();
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function applyInitialDamage( _user, _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		local damage = this.Math.rand(this.m.DamageMin, this.m.DamageMax);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage;
		hitInfo.DamageArmor = damage;
		hitInfo.DamageDirect = this.m.DirectDamage;
		hitInfo.DamageMinimum = 0;
		hitInfo.DamageFatigue = 0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || _targetTile == null || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local targets = this.getTargets(_user, _targetTile);
		local passive = this.getPassive();
		if (targets.len() == 0 || passive == null) return false;

		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "nahida_all_schemes_cast");
		foreach (target in targets)
		{
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "nahida_seed", { Scale = 0.62, EndScale = 0.86 });
			this.applyInitialDamage(_user, target);
		}

		passive.clearOwnedSeeds();
		local network = passive.createNetworkToken();
		foreach (target in targets)
		{
			if (!::$bvvar{namespace}.isActorDeadOrDying(target)) passive.applySeed(target, network, this.m.MarkDuration);
		}
		this.m.AvailableRound = this.getRound() + this.m.Cooldown;
		return true;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.nahida_all_schemes_to_know.tooltip.damage}" },
			{ id = 5, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_all_schemes_to_know.tooltip.mark}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.nahida_all_schemes_to_know.tooltip.recast}" }
		];
		local remaining = this.Math.max(0, this.m.AvailableRound - this.getRound());
		if (remaining > 0) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.nahida_all_schemes_to_know.tooltip.cooldown_prefix}" + remaining + "$bv{skill.nahida_all_schemes_to_know.tooltip.cooldown_suffix}" });
		return ret;
	}

	function onCombatStarted() { this.m.AvailableRound = 0; }
	function onCombatFinished() { this.m.AvailableRound = 0; this.skill.onCombatFinished(); }
});
