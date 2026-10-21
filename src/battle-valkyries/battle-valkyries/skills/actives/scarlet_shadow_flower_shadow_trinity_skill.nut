this.scarlet_shadow_flower_shadow_trinity_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		CurrentStage = 0,
		IsCurrentAttack = false,
		Stage2DamageMult = 2.0,
		Stage2ArmorMult = 2.0,
		Stage2DirectAdd = 0.20,
		Stage4DamageMult = 2.3,
		Stage4ArmorMult = 2.0,
		Stage4DirectAdd = 0.25,
		Stage6DamageMult = 1.65,
		Stage6ArmorMult = 1.65,
		Stage6DirectAdd = 0.15
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.KilledString = "$bv{skill.scarlet_shadow_flower_shadow_trinity.killed}";
		this.m.Overlay = "";
		this.m.SoundOnUse = [
			"sounds/combat/slash_01.wav",
			"sounds/combat/slash_02.wav",
			"sounds/combat/slash_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/slash_hit_01.wav",
			"sounds/combat/slash_hit_02.wav",
			"sounds/combat/slash_hit_03.wav"
		];
		this.m.Order = ::$bvvar{namespace}.getValkyrieActiveSkillOrder() - 20;
		this.m.IsTargeted = true;
		this.m.IsTargetingActor = true;
		this.m.IsAttack = true;
		this.m.IsAOE = true;
		this.m.IsWeaponSkill = true;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsIgnoredAsAOO = true;
		this.m.HitChanceBonus = 0;
		this.m.DirectDamageMult = 0.0;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 1;
		this.m.MaxRange = 99;
		this.m.MaxLevelDifference = 99;
		this.m.ChanceDecapitate = 66;
		this.m.ChanceDisembowel = 33;
		this.m.ChanceSmash = 0;
	}

	function getActionPointCost()
	{
		return 0;
	}

	function getFatigueCost()
	{
		return 0;
	}

	function getMaxRange()
	{
		if (this.getCurrentStage() == 2)
		{
			return 1;
		}

		return 99;
	}

	function getFlyflowerEffect()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor == null || actor.getSkills() == null)
		{
			return null;
		}

		return actor.getSkills().getSkillByID("$bvvar{modId}.effects.scarlet_shadow_flyflower");
	}

	function getCurrentStage()
	{
		local effect = this.getFlyflowerEffect();
		return effect == null ? 0 : effect.getAvailableStage();
	}

	function isUsable()
	{
		return this.skill.isUsable() && this.getCurrentStage() > 0;
	}

	function normalizeDirection( _direction )
	{
		local ret = _direction;

		while (ret < 0)
		{
			ret += 6;
		}

		while (ret >= 6)
		{
			ret -= 6;
		}

		return ret;
	}

	function pushUniqueTile( _tiles, _tile )
	{
		if (_tile == null)
		{
			return;
		}

		foreach( tile in _tiles )
		{
			if (tile == _tile)
			{
				return;
			}
		}

		_tiles.push(_tile);
	}

	function addNextTile( _tiles, _originTile, _direction )
	{
		if (_originTile == null)
		{
			return null;
		}

		local dir = this.normalizeDirection(_direction);

		if (!_originTile.hasNextTile(dir))
		{
			return null;
		}

		local tile = _originTile.getNextTile(dir);
		this.pushUniqueTile(_tiles, tile);
		return tile;
	}

	function getStage6TargetTiles( _userTile, _targetTile )
	{
		local ret = [];

		if (_targetTile == null)
		{
			return ret;
		}

		this.pushUniqueTile(ret, _targetTile);

		if (_userTile == null)
		{
			return ret;
		}

		local dir = _userTile.getDirectionTo(_targetTile);
		local front = this.addNextTile(ret, _targetTile, dir);
		this.addNextTile(ret, _targetTile, dir - 1);
		this.addNextTile(ret, _targetTile, dir + 1);
		this.addNextTile(ret, front, dir);

		return ret;
	}

	function getTooltip()
	{
		local stage = this.getCurrentStage();
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
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.free}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/regular_damage.png",
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage2}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage4}"
			},
			{
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage6}"
			}
		];

		if (stage > 0)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.stage_ready}" + "[color=" + this.Const.UI.Color.PositiveValue + "]" + stage + "[/color]"
			});
		}
		else
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "$bv{skill.scarlet_shadow_flower_shadow_trinity.tooltip.unavailable}"
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

		local stage = this.getCurrentStage();
		if (stage == 0 || stage == 2 && _originTile.getDistanceTo(_targetTile) > 1)
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
		local stage = this.getCurrentStage();
		local user = this.m.Container == null ? null : this.m.Container.getActor();
		local tiles = stage == 6 ? this.getStage6TargetTiles(user == null ? null : user.getTile(), _targetTile) : [_targetTile];

		foreach( tile in tiles )
		{
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill != this)
		{
			return;
		}

		if (this.m.CurrentStage == 2)
		{
			_properties.MeleeSkill += 25;
			_properties.DamageRegularMult *= this.m.Stage2DamageMult;
			_properties.DamageArmorMult *= this.m.Stage2ArmorMult;
			_properties.DamageDirectMeleeAdd += this.m.Stage2DirectAdd;
		}
		else if (this.m.CurrentStage == 4)
		{
			_properties.MeleeSkill += 30;
			_properties.DamageRegularMult *= this.m.Stage4DamageMult;
			_properties.DamageArmorMult *= this.m.Stage4ArmorMult;
			_properties.DamageDirectMeleeAdd += this.m.Stage4DirectAdd;
		}
		else if (this.m.CurrentStage == 6)
		{
			_properties.MeleeSkill += 20;
			_properties.DamageRegularMult *= this.m.Stage6DamageMult;
			_properties.DamageArmorMult *= this.m.Stage6ArmorMult;
			_properties.DamageDirectMeleeAdd += this.m.Stage6DirectAdd;
		}
	}

	function applyStageStatus( _stage, _target )
	{
		if (_target == null || _target.getSkills() == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return;
		}

		if (_stage == 2)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));
		}
		else if (_stage == 6)
		{
			_target.getSkills().add(this.new("scripts/skills/effects/staggered_effect"));
		}
	}

	function attackStageTarget( _user, _target, _stage )
	{
		if (_target == null || _target.isAlliedWith(_user) || !_target.isAttackable() || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local tile = _target.getTile();
		this.spawnAttackEffect(tile, this.Const.Tactical.AttackEffectSlash);
		this.m.CurrentStage = _stage;
		this.m.IsCurrentAttack = true;
		local success = false;

		try
		{
			success = this.attackEntity(_user, _target, false);
		}
		catch (e)
		{
			this.m.IsCurrentAttack = false;
			this.m.CurrentStage = 0;
			throw e;
		}

		this.m.IsCurrentAttack = false;

		if (success)
		{
			this.applyStageStatus(_stage, _target);
		}

		this.m.CurrentStage = 0;
		return success;
	}

	function onUse( _user, _targetTile )
	{
		if (::$bvvar{namespace}.isActorDeadOrDying(_user) || _targetTile == null || !_targetTile.IsOccupiedByActor)
		{
			return false;
		}

		local stage = this.getCurrentStage();
		local effect = this.getFlyflowerEffect();

		if (stage == 0 || effect == null)
		{
			return false;
		}

		local ret = false;

		if (stage == 6)
		{
			local tiles = this.getStage6TargetTiles(_user.getTile(), _targetTile);

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

				ret = this.attackStageTarget(_user, tile.getEntity(), stage) || ret;
			}
		}
		else
		{
			ret = this.attackStageTarget(_user, _targetTile.getEntity(), stage);
		}

		effect.spendStage(stage);
		return true;
	}

	function onTargetKilled( _targetEntity, _skill )
	{
		if (_targetEntity == null || this.m.CurrentStage != 4)
		{
			return;
		}

		if (_skill != this && !this.m.IsCurrentAttack)
		{
			return;
		}

		local actor = this.getContainer().getActor();

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || actor.isAlliedWith(_targetEntity) || !actor.isPlacedOnMap())
		{
			return;
		}

		actor.setActionPoints(this.Math.min(actor.getActionPointsMax(), actor.getActionPoints() + 3));
		actor.setDirty(true);
		this.spawnIcon("status_effect_34", actor.getTile());
	}
});
