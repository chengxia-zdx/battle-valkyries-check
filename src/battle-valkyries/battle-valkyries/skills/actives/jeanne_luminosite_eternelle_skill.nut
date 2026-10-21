this.jeanne_luminosite_eternelle_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.ActionPointCost = 6;
		this.m.FatigueCost = 30;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
	}

	function getActor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
	function getPassive() { return ::$bvvar{namespace}.getJeanneHolyBannerSkill(this.getActor()); }
	function getRadius() { local passive=this.getPassive(); return passive == null ? 4 : passive.getAuraRange(); }
	function getHealingPerTurn() { return ::$bvvar{namespace}.getJeanneBlessingHealing(this.getActor()); }
	function isUsable()
	{
		local passive = this.getPassive();
		return this.skill.isUsable() && passive != null && passive.hasLegalWeapon() && passive.getRevelation() >= 4;
	}

	function snapshotRecipients( _user )
	{
		local ret = [];
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || !_user.isPlacedOnMap()) return ret;
		ret.push(_user);
		foreach (ally in ::$bvvar{namespace}.getJeanneTacticalActors())
		{
			if (!::$bvvar{namespace}.isEligibleRosterAlly(_user, ally) || !ally.isPlacedOnMap()) continue;
			if (_user.getTile().getDistanceTo(ally.getTile()) <= this.getRadius()) ret.push(ally);
		}
		return ret;
	}

	function addOrRefreshOwnedEffect( _target, _id, _script )
	{
		local owner = this.getActor();
		if (_target == null || owner == null || _target.getSkills() == null) return null;
		local effect = _target.getSkills().getSkillByID(_id);
		if (effect != null)
		{
			if (("isOwnedBy" in effect) && effect.isOwnedBy(owner)) effect.onRefresh();
			return effect;
		}
		effect = ::new(_script);
		effect.setupOwner(owner);
		_target.getSkills().add(effect);
		return effect;
	}

	function applyRaised( _user )
	{
		local effect = _user.getSkills().getSkillByID(::$bvvar{namespace}.JeanneBannerRaisedID);
		if (effect == null)
		{
			effect = ::new("$bvvar{privateFolder}/skills/effects/jeanne_banner_raised_effect");
			_user.getSkills().add(effect);
		}
		return effect;
	}

	function applyProtectionAndBlessing( _target )
	{
		this.addOrRefreshOwnedEffect(_target, ::$bvvar{namespace}.JeanneHolyFlagProtectionID, "$bvvar{privateFolder}/skills/effects/jeanne_holy_flag_protection_effect");
		this.addOrRefreshOwnedEffect(_target, ::$bvvar{namespace}.JeanneHolyMaidenBlessingID, "$bvvar{privateFolder}/skills/effects/jeanne_holy_maiden_blessing_effect");
		_target.getSkills().update();
		try { if (_target.isPlacedOnMap()) this.spawnIcon("status_effect_56", _target.getTile()); } catch (e) {}
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable()) return false;
		local passive = this.getPassive();
		local recipients = this.snapshotRecipients(_user);
		if (passive == null || recipients.len() == 0 || !passive.consumeRevelation(4)) return false;
		if (passive.hasBondUpgrade(100)) passive.addRevelation(1);
		this.applyRaised(_user);
		_user.setActionPoints(0);
		_user.setDirty(true);
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "jeanne_luminosite_cast");
		foreach (target in recipients)
		{
			if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			::$bvvar{namespace}.removeJeanneNegativeEffects(target);
			::$bvvar{namespace}.improveJeanneMoraleOneStep(target);
			this.applyProtectionAndBlessing(target);
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "jeanne_holy_blessing");
		}
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "jeanne_luminosite_eternelle_cast");
		return true;
	}

	function getTooltip()
	{
		local passive = this.getPassive();
		local ret = [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", text=this.getCostString() },
			{ id=4, type="text", icon="ui/icons/vision.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.range_prefix}" + this.getRadius() + "$bv{skill.jeanne_luminosite_eternelle.tooltip.range_suffix}" },
			{ id=5, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.cleanse}" },
			{ id=6, type="text", icon="ui/icons/melee_defense.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.protection}" },
			{ id=7, type="text", icon="ui/icons/health.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.blessing_prefix}" + this.getHealingPerTurn() + "$bv{skill.jeanne_luminosite_eternelle.tooltip.blessing_suffix}" },
			{ id=8, type="text", icon="ui/icons/action_points.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.raised}" },
			{ id=9, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.revelation_prefix}" + (passive == null ? 0 : passive.getRevelation()) + "/4" + "$bv{skill.jeanne_luminosite_eternelle.tooltip.revelation_suffix}" }
		];
		if (passive != null && passive.hasBondUpgrade(100)) ret.push({ id=10, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.bond_oath}" });
		if (passive == null || !passive.hasLegalWeapon()) ret.push({ id=11, type="text", icon="ui/tooltips/warning.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.weapon_required}" });
		else if (passive.getRevelation() < 4) ret.push({ id=11, type="text", icon="ui/tooltips/warning.png", text="$bv{skill.jeanne_luminosite_eternelle.tooltip.not_ready}" });
		return ret;
	}
});
