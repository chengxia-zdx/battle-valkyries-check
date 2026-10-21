this.liuying_ignite_the_sea_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsSpent = false
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.liuying_ignite_the_sea.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_lance_01.wav",
			"sounds/combat/dlc6/fire_lance_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/shield_hit_wood_01.wav",
			"sounds/combat/shield_hit_wood_02.wav"
		];
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAOE = true;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.HitChanceBonus = 100;
		this.m.DirectDamageMult = 0.45;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 4;
		this.m.MaxLevelDifference = 6;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function isUsable()
	{
		return this.skill.isUsable()
			&& !this.m.IsSpent
			&& this.getContainer() != null
			&& this.getContainer().hasSkill("$bvvar{modId}.effects.liuying_glamoth_cavalry");
	}

	function getTargetAreaTiles( _targetTile )
	{
		local ret = [];
		ret.push(_targetTile);

		for( local i = 0; i < 6; i = ++i )
		{
			if (_targetTile.hasNextTile(i))
			{
				ret.push(_targetTile.getNextTile(i));
			}
		}

		return ret;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 3,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.free}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.damage}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/armor_damage.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.armor}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.area}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.status}"
			}
		];

		if (this.m.IsSpent)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.liuying_ignite_the_sea.tooltip.spent}"
			});
		}

		return ret;
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local user = this.getContainer().getActor();
		local target = _targetTile.getEntity();
		return user != null && !::$bvvar{namespace}.isActorDeadOrDying(user)
			&& target != null && !target.isAlliedWith(user) && !::$bvvar{namespace}.isActorDeadOrDying(target) && target.isAttackable();
	}

	function onTargetSelected( _targetTile )
	{
		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 100;
			_properties.DamageRegularMin = 160;
			_properties.DamageRegularMax = 160;
			_properties.DamageRegularMult = 1.0;
			_properties.DamageArmorMult = 2.25;
			_properties.DamageDirectAdd = 0.0;
			_properties.DamageDirectMeleeAdd = 0.0;
			_properties.DamageDirectRangedAdd = 0.0;
			_properties.DamageDirectMult = 1.0;
			_properties.DamageTotalMult = 1.0;
			_properties.MeleeDamageMult = 1.0;
			_properties.RangedDamageMult = 1.0;
		}
	}

	function applyStatus( _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
		_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		this.m.IsSpent = true;

		local ret = false;
		local tiles = this.getTargetAreaTiles(_targetTile);

		foreach( tile in tiles )
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user))
			{
				break;
			}

			if (!tile.IsOccupiedByActor)
			{
				continue;
			}

			local target = tile.getEntity();

			if (target == null || target.isAlliedWith(_user) || !target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				continue;
			}

			this.Tactical.spawnSpriteEffect("effect_fire_01", this.createColor("#44f7d1"), tile, 0, 45, 1.0, 0.35, 0, 200, 200);
			local success = this.attackEntity(_user, target, false);
			ret = success || ret;

			if (success)
			{
				this.applyStatus(target);
			}
		}

		return true;
	}

	function onCombatStarted()
	{
		this.m.IsSpent = false;
	}

	function onCombatFinished()
	{
		this.m.IsSpent = false;
		this.skill.onCombatFinished();
	}
});
