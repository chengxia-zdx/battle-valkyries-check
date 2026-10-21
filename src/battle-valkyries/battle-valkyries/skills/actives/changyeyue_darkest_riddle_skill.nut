this.changyeyue_darkest_riddle_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		MainDamageMult = 2.0,
		MainArmorDamageMult = 1.5,
		MainFixedHitpointDamage = 20,
		SecondaryDamageMult = 1.0,
		SecondaryArmorDamageMult = 1.0,
		SecondaryFixedHitpointDamage = 10,
		MemoryCost = 100,
		HpCostPct = 0.15
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.changyeyue_darkest_riddle.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/daze_bomb_01.wav",
			"sounds/combat/dlc6/daze_bomb_02.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/shield_hit_wood_01.wav",
			"sounds/combat/shield_hit_wood_02.wav",
			"sounds/combat/shield_hit_wood_03.wav"
		];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 10;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsAOE = true;
		this.m.IsUsingHitchance = false;
		this.m.HitChanceBonus = 100;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 20;
		this.m.MinRange = 1;
		this.m.MaxRange = 6;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getMemorySkill()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || actor.getSkills() == null)
		{
			return null;
		}

		return ::$bvvar{namespace}.getRuntimeSkillByKey(actor, "changyeyue_long_night");
	}

	function isUsable()
	{
		local memory = this.getMemorySkill();
		return this.skill.isUsable() && memory != null && memory.hasFullMemory();
	}

	function getTooltip()
	{
		local memory = this.getMemorySkill();
		local current = memory == null ? 0 : memory.getMemory();
		local max = memory == null ? this.m.MemoryCost : memory.getMemoryMax();
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
				text = this.getCostString()
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.cost}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/direct_damage.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.main}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.secondary}"
			},
			{
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.effects}"
			},
			{
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.memory_prefix}" + current + "/" + max
			}
		];

		if (memory == null || !memory.hasFullMemory())
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.changyeyue_darkest_riddle.tooltip.not_ready}"
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
			&& target != null && !target.isAlliedWith(user) && target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(target);
	}

	function onTargetSelected( _targetTile )
	{
		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function getTargetAreaTiles( _targetTile )
	{
		local ret = [];

		if (_targetTile == null)
		{
			return ret;
		}

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

	function rollWeaponDamage( _user, _target )
	{
		if (_user == null || this.m.Container == null)
		{
			return 0;
		}

		local properties = this.m.Container.buildPropertiesForUse(this, _target);
		local minDamage = this.Math.max(0, properties.DamageRegularMin);
		local maxDamage = this.Math.max(minDamage, properties.DamageRegularMax);
		local baseDamage = this.Math.rand(minDamage, maxDamage);
		local damageMult = properties.DamageRegularMult * properties.DamageTotalMult * properties.RangedDamageMult;
		return this.Math.max(0, this.Math.floor(baseDamage * damageMult));
	}

	function applyWeaponDamage( _user, _target, _damageMult, _armorDamageMult )
	{
		if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local weaponDamage = this.rollWeaponDamage(_user, _target);
		if (weaponDamage <= 0)
		{
			return;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = this.Math.floor(weaponDamage * _damageMult);
		hitInfo.DamageArmor = this.Math.floor(weaponDamage * _armorDamageMult);
		hitInfo.DamageDirect = 0.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
	}

	function applyHitpointDamage( _user, _target, _amount )
	{
		if (_amount <= 0 || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local hitInfo = clone this.Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _amount;
		hitInfo.DamageArmor = 0;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = this.Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;
		_target.onDamageReceived(_user, this, hitInfo);
	}

	function addOblivion( _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		local effect = _target.getSkills().getSkillByID("$bvvar{modId}.effects.changyeyue_oblivion");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/changyeyue_oblivion_effect");
			_target.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}
	}

	function addDarkestRiddle( _user )
	{
		if (_user == null || _user.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			return;
		}

		local effect = _user.getSkills().getSkillByID("$bvvar{modId}.effects.changyeyue_darkest_riddle");
		if (effect == null)
		{
			effect = this.new("$bvvar{privateFolder}/skills/effects/changyeyue_darkest_riddle_effect");
			_user.getSkills().add(effect);
		}
		else
		{
			effect.onRefresh();
		}
	}

	function spendHitpoints( _user )
	{
		if (_user == null || ::$bvvar{namespace}.isActorDeadOrDying(_user))
		{
			return;
		}

		local cost = this.Math.max(1, this.Math.floor(_user.getHitpoints() * this.m.HpCostPct));
		_user.setHitpoints(this.Math.max(1, _user.getHitpoints() - cost));
		_user.setDirty(true);
	}

	function isValidEnemyTarget( _user, _target )
	{
		return _user != null && _target != null && !_target.isAlliedWith(_user) && _target.isAttackable()
			&& !::$bvvar{namespace}.isActorDeadOrDying(_target);
	}

	function applyRiddleHit( _user, _target, _damageMult, _armorDamageMult, _fixedHitpointDamage )
	{
		if (!this.isValidEnemyTarget(_user, _target))
		{
			return;
		}

		this.Tactical.spawnSpriteEffect("effect_lightning_02", this.createColor("#8db9ff"), _target.getTile(), 0, 45, 1.15, 0.25, 0, 200, 200);
		local snapshot = ::$bvvar{namespace}.getValkyrieDamageSnapshot(_target);
		this.applyWeaponDamage(_user, _target, _damageMult, _armorDamageMult);
		this.applyHitpointDamage(_user, _target, _fixedHitpointDamage);
		::$bvvar{namespace}.notifyValkyrieAttackHitFromSnapshot(_user, this, _target, this.Const.BodyPart.Body, snapshot);
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local target = _targetTile.getEntity();
		if (!this.isValidEnemyTarget(_user, target))
		{
			return false;
		}

		local memory = this.getMemorySkill();
		if (memory == null || !memory.spendMemory(this.m.MemoryCost))
		{
			return false;
		}

		this.spendHitpoints(_user);
		this.addDarkestRiddle(_user);

		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			if (tile == null || !tile.IsOccupiedByActor)
			{
				continue;
			}

			local candidate = tile.getEntity();
			if (!this.isValidEnemyTarget(_user, candidate))
			{
				continue;
			}

			if (candidate.getID() == target.getID())
			{
				this.applyRiddleHit(_user, candidate, this.m.MainDamageMult, this.m.MainArmorDamageMult, this.m.MainFixedHitpointDamage);
			}
			else
			{
				this.applyRiddleHit(_user, candidate, this.m.SecondaryDamageMult, this.m.SecondaryArmorDamageMult, this.m.SecondaryFixedHitpointDamage);
			}
		}

		foreach( tile in this.getTargetAreaTiles(_targetTile) )
		{
			if (tile == null || !tile.IsOccupiedByActor)
			{
				continue;
			}

			local candidate = tile.getEntity();
			if (this.isValidEnemyTarget(_user, candidate))
			{
				this.addOblivion(candidate);
			}
		}

		return true;
	}
});
