this.hakurei_reimu_fantasy_seal_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		SpiritPowerCost = 4,
		PrimaryDamageMin = 150,
		PrimaryDamageMax = 190,
		PrimaryArmorDamageMult = 1.25,
		PrimaryDirectDamage = 0.40,
		AreaDamageMin = 80,
		AreaDamageMax = 110,
		AreaArmorDamageMult = 1.0,
		AreaDirectDamage = 0.25,
		MarkBonusDamage = 30
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.hakurei_reimu_fantasy_seal.killed}";
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsVisibleTileNeeded = true;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 30;
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
			SpiritPowerCost = "SpiritPowerCost", PrimaryDamageMin = "PrimaryDamageMin", PrimaryDamageMax = "PrimaryDamageMax",
			PrimaryArmorDamageMult = "PrimaryArmorDamageMult", PrimaryDirectDamage = "PrimaryDirectDamage",
			AreaDamageMin = "AreaDamageMin", AreaDamageMax = "AreaDamageMax", AreaArmorDamageMult = "AreaArmorDamageMult",
			AreaDirectDamage = "AreaDirectDamage", MarkBonusDamage = "MarkBonusDamage"
		}) if (key in spec) this.m[target] = spec[key];
	}

	function getPassive()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "hakurei_reimu_inborn_intuition");
	}

	function getSpiritEffect()
	{
		local passive = this.getPassive();
		return passive == null ? null : passive.getSpiritEffect();
	}

	function isUsable()
	{
		local spirit = this.getSpiritEffect();
		return this.skill.isUsable() && spirit != null && spirit.getCount() >= this.m.SpiritPowerCost;
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
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true));
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

	function applySpellDamage( _user, _target, _damageMin, _damageMax, _armorMult, _directDamage )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return null;
		local damage = this.Math.rand(_damageMin, _damageMax);
		local before = ::$bvvar{namespace}.snapshotValkyrieDamageState(_target);
		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = damage;
		hitInfo.DamageArmor = this.Math.floor(damage * _armorMult);
		hitInfo.DamageDirect = _directDamage;
		hitInfo.DamageMinimum = 0;
		hitInfo.DamageFatigue = 0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
		local after = ::$bvvar{namespace}.snapshotValkyrieDamageState(_target);
		return {
			Hit = true,
			HitpointDamage = this.Math.max(0, before.Hitpoints - after.Hitpoints),
			ArmorDamage = this.Math.max(0, before.HeadArmor + before.BodyArmor - after.HeadArmor - after.BodyArmor)
		};
	}

	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local primary = _targetTile.getEntity();
		local targets = this.getTargets(_user, _targetTile);
		local spirit = this.getSpiritEffect();
		if (primary == null || targets.len() == 0 || spirit == null || !spirit.consume(this.m.SpiritPowerCost)) return false;
		local primaryID = ::$bvvar{namespace}.getValkyrieCombatObjectID(primary);
		local mark = primary.getSkills().getSkillByID("$bvvar{modId}.effects.hakurei_reimu_sealing_charm");
		this.applySpellDamage(_user, primary, this.m.PrimaryDamageMin, this.m.PrimaryDamageMax, this.m.PrimaryArmorDamageMult, this.m.PrimaryDirectDamage);
		if (mark != null)
		{
			try { mark.removeSelf(); } catch (e) {}
			if (!::$bvvar{namespace}.isActorDeadOrDying(primary))
			{
				local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
				local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, primary, this.m.MarkBonusDamage, { ActionToken = actionToken, Source = "hakurei_reimu_fantasy_seal_fixed" });
			}
		}
		foreach (target in targets)
		{
			if (::$bvvar{namespace}.getValkyrieCombatObjectID(target) == primaryID || ::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			this.applySpellDamage(_user, target, this.m.AreaDamageMin, this.m.AreaDamageMax, this.m.AreaArmorDamageMult, this.m.AreaDirectDamage);
		}
		return true;
	}

	function getTooltip()
	{
		local spirit = this.getSpiritEffect();
		local current = spirit == null ? 0 : spirit.getCount();
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.primary}" },
			{ id = 5, type = "text", icon = "ui/icons/armor_damage.png", text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.area}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.seal}" },
			{ id = 7, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.spirit_prefix}" + current + " / " + this.m.SpiritPowerCost }
		];
		if (current < this.m.SpiritPowerCost) ret.push({ id = 8, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.hakurei_reimu_fantasy_seal.tooltip.not_ready}" });
		return ret;
	}
});
