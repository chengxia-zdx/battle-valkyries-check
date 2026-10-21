this.xilian_test_annihilation_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {
		IsResolvingAnnihilation = false,
		AnnihilationGeneration = 0,
		AnnihilationDefeated = 0,
		AnnihilationSkipped = 0
	},

	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.Overlay = "";
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsWeaponSkill = false;
		this.m.IsShieldRelevant = false;
		this.m.IsVisibleTileNeeded = false;
		this.m.IsStacking = false;
		this.m.ActionPointCost = 0;
		this.m.FatigueCost = 0;
		this.m.MinRange = 0;
		this.m.MaxRange = 0;
		this.resetAnnihilationState();
	}

	function getAllTacticalActors()
	{
		if (!("Tactical" in getroottable()) || ::Tactical == null || !("Entities" in ::Tactical) || ::Tactical.Entities == null)
		{
			return [];
		}

		try
		{
			return ::Tactical.Entities.getAllInstancesAsArray();
		}
		catch (e)
		{
			return [];
		}
	}

	function isEligibleEnemy( _user, _target )
	{
		if (_user == null || _target == null || _target == _user)
		{
			return false;
		}

		try
		{
			return _target.isAlive()
				&& !_target.isDying()
				&& _target.isPlacedOnMap()
				&& !_target.isAlliedWith(_user);
		}
		catch (e)
		{
			return false;
		}
	}

	function getEligibleEnemies( _user )
	{
		local enemies = [];

		foreach( actor in this.getAllTacticalActors() )
		{
			if (this.isEligibleEnemy(_user, actor))
			{
				enemies.push(actor);
			}
		}

		return enemies;
	}

	function isTestOriginXilian( _actor )
	{
		return _actor != null
			&& ::$bvvar{namespace}.getActorValkyrieID(_actor) == "xilian"
			&& ::$bvvar{namespace}.isBattleValkyriesTestOrigin();
	}

	function isUsable()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable()
			&& !this.m.IsResolvingAnnihilation
			&& this.isTestOriginXilian(actor)
			&& this.getEligibleEnemies(actor).len() > 0;
	}

	function resetAnnihilationState()
	{
		this.m.IsResolvingAnnihilation = false;
		this.m.AnnihilationGeneration = ++this.m.AnnihilationGeneration;
		this.m.AnnihilationDefeated = 0;
		this.m.AnnihilationSkipped = 0;
	}

	function finishAnnihilation( _reason )
	{
		if (!this.m.IsResolvingAnnihilation)
		{
			return;
		}

		this.m.IsResolvingAnnihilation = false;
		::logInfo("[Battle Valkyries] Xilian test annihilation finished: defeated="
			+ this.m.AnnihilationDefeated
			+ ", skipped="
			+ this.m.AnnihilationSkipped
			+ ", reason="
			+ _reason
			+ ".");
	}

	function scheduleAnnihilationStep( _user, _generation, _isArmed, _failedActorIDs )
	{
		local tag = {
			SkillRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(this),
			SkillID = ::$bvvar{namespace}.getValkyrieCombatObjectID(this),
			UserRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_user),
			UserID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_user),
			Generation = _generation,
			IsArmed = _isArmed,
			FailedActorIDs = _failedActorIDs
		};

		if (tag.SkillRef == null || tag.UserRef == null)
		{
			this.finishAnnihilation("weak-reference-unavailable");
			return false;
		}

		::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _tag )
		{
			local skill = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.SkillRef);

			if (skill == null || ::$bvvar{namespace}.getValkyrieCombatObjectID(skill) != _tag.SkillID)
			{
				return;
			}

			skill.resolveAnnihilationStep(_tag);
		}, tag);
		return true;
	}

	function resolveAnnihilationStep( _tag )
	{
		if (_tag == null
			|| !this.m.IsResolvingAnnihilation
			|| _tag.Generation != this.m.AnnihilationGeneration)
		{
			return;
		}

		local user = ::$bvvar{namespace}.readValkyrieCombatWeakRef(_tag.UserRef);

		if (user == null
			|| ::$bvvar{namespace}.getValkyrieCombatObjectID(user) != _tag.UserID
			|| !this.isTestOriginXilian(user)
			|| ::$bvvar{namespace}.isActorDeadOrDying(user))
		{
			this.finishAnnihilation("user-invalid");
			return;
		}

		// Give the original skill action a full virtual tick to resolve before
		// any death callback is allowed to end the tactical battle.
		if (!_tag.IsArmed)
		{
			this.scheduleAnnihilationStep(user, _tag.Generation, true, _tag.FailedActorIDs);
			return;
		}

		local target = null;
		local targetID = null;

		foreach( enemy in this.getEligibleEnemies(user) )
		{
			local enemyID = ::$bvvar{namespace}.getValkyrieCombatObjectID(enemy);
			local enemyKey = enemyID == null ? null : enemyID.tostring();

			if (enemyKey == null || !(enemyKey in _tag.FailedActorIDs))
			{
				target = enemy;
				targetID = enemyID;
				break;
			}
		}

		if (target == null)
		{
			this.finishAnnihilation(this.m.AnnihilationSkipped == 0 ? "all-hostiles-defeated" : "remaining-hostiles-skipped");
			return;
		}

		local defeated = false;

		try
		{
			target.kill(user, this, this.Const.FatalityType.None, true);
			defeated = true;
		}
		catch (e)
		{
			// Some death callbacks can throw after the actor has already been
			// removed. Count that as a completed defeat; only skip actors that
			// are still valid enemies after the failed callback.
			defeated = !this.isEligibleEnemy(user, target);

			if (!defeated)
			{
				local failedKey = targetID == null ? null : targetID.tostring();

				if (failedKey == null)
				{
					::logWarning("[Battle Valkyries] Xilian test annihilation stopped after an unidentified enemy failed to die: " + e);
					this.m.AnnihilationSkipped = ++this.m.AnnihilationSkipped;
					this.finishAnnihilation("unidentified-enemy-failed");
					return;
				}

				_tag.FailedActorIDs[failedKey] <- true;
				this.m.AnnihilationSkipped = ++this.m.AnnihilationSkipped;
				::logWarning("[Battle Valkyries] Xilian test annihilation skipped hostile actor " + failedKey + ": " + e);
			}
		}

		if (defeated)
		{
			this.m.AnnihilationDefeated = ++this.m.AnnihilationDefeated;
		}

		// Re-scan instead of consuming a stale snapshot. Mounted undead and
		// similar enemies may spawn a replacement actor during their death.
		if (this.m.IsResolvingAnnihilation && _tag.Generation == this.m.AnnihilationGeneration)
		{
			this.scheduleAnnihilationStep(user, _tag.Generation, true, _tag.FailedActorIDs);
		}
	}

	function getTooltip()
	{
		return [
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
				icon = "ui/icons/special.png",
				text = "$bv{skill.xilian_test_annihilation.tooltip.effect}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.xilian_test_annihilation.tooltip.test_origin}"
			}
		];
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.IsResolvingAnnihilation
			|| !this.isTestOriginXilian(_user)
			|| ::$bvvar{namespace}.isActorDeadOrDying(_user)
			|| this.getEligibleEnemies(_user).len() == 0)
		{
			return false;
		}

		this.m.IsResolvingAnnihilation = true;
		this.m.AnnihilationGeneration = ++this.m.AnnihilationGeneration;
		this.m.AnnihilationDefeated = 0;
		this.m.AnnihilationSkipped = 0;

		if (!this.scheduleAnnihilationStep(_user, this.m.AnnihilationGeneration, false, {}))
		{
			return false;
		}

		_user.setDirty(true);
		return true;
	}

	function onCombatStarted()
	{
		this.resetAnnihilationState();
	}

	function onCombatFinished()
	{
		this.resetAnnihilationState();
		this.skill.onCombatFinished();
	}
});
