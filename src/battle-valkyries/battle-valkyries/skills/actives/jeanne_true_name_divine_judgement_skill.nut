this.jeanne_true_name_divine_judgement_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.IsRanged = false;
		this.m.IsUsingHitchance = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 2;
		this.m.MaxLevelDifference = 99;
	}

	function getActor() { return this.getContainer() == null ? null : this.getContainer().getActor(); }
	function getPassive() { return ::$bvvar{namespace}.getJeanneHolyBannerSkill(this.getActor()); }
	function isUsable()
	{
		local passive = this.getPassive();
		return this.skill.isUsable() && passive != null && passive.hasLegalWeapon()
			&& passive.getRevelation() >= 2 && !::$bvvar{namespace}.isValkyrieSkillUseBlocked(this);
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getActor();
		local target = _targetTile.getEntity();
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner, target, this.m.MaxRange, true)) return false;
		local distance = owner.getTile().getDistanceTo(target.getTile());
		return distance >= this.m.MinRange && distance <= this.m.MaxRange;
	}

	function applyDiscernment( _target )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return null;
		local effect = _target.getSkills().getSkillByID(::$bvvar{namespace}.JeanneTrueNameDiscernmentID);
		if (effect != null) effect.onRefresh();
		else
		{
			effect = ::new("$bvvar{privateFolder}/skills/effects/jeanne_true_name_discernment_effect");
			_target.getSkills().add(effect);
		}
		_target.getSkills().update();
		return effect;
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local passive = this.getPassive();
		local target = _targetTile.getEntity();
		if (passive == null || !passive.consumeRevelation(2)) return false;
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "jeanne_divine_judgement_cast");
		local soundPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
		local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
			WeaponDamageMult=1.30,
			ArmorDamageMult=1.50,
			DirectDamageAdd=0.15,
			HitChance=25,
			IgnoreDistance=true,
			IgnoreShield=true,
			Source="jeanne_divine_judgement"
		});
		if (result != null && "Hit" in result && result.Hit)
		{
			if (soundPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "jeanne_divine_judgement_impact", soundPosition);
			passive.refundJudgmentRevelation();
			if (!::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				this.applyDiscernment(target);
				if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "jeanne_judgement", result);
			}
		}
		return true;
	}

	function getTooltip()
	{
		local passive = this.getPassive();
		local ret = [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", text=this.getCostString() },
			{ id=4, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.hit}" },
			{ id=5, type="text", icon="ui/icons/regular_damage.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.damage}" },
			{ id=6, type="text", icon="ui/icons/direct_damage.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.discernment}" },
			{ id=7, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.revelation_prefix}" + (passive == null ? 0 : passive.getRevelation()) + "/4" + "$bv{skill.jeanne_true_name_divine_judgement.tooltip.revelation_suffix}" }
		];
		if (passive != null && passive.hasBondUpgrade(80)) ret.push({ id=8, type="text", icon="ui/icons/special.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.bond_rebate}" });
		if (passive == null || !passive.hasLegalWeapon()) ret.push({ id=9, type="text", icon="ui/tooltips/warning.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.weapon_required}" });
		else if (passive.getRevelation() < 2) ret.push({ id=9, type="text", icon="ui/tooltips/warning.png", text="$bv{skill.jeanne_true_name_divine_judgement.tooltip.not_ready}" });
		return ret;
	}
});
