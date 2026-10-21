this.cerydra_war_banner_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = {
		Edict = 0,
		MaxEdict = 4,
		BaseAuraRange = 4,
		FlagAuraRangeBonus = 1,
		LastCommandRound = -1
	},

	function create()
	{
		this.valkyrie_passive_skill.create();
	}

	function getActor()
	{
		return this.getContainer() == null ? null : this.getContainer().getActor();
	}

	function getCurrentRound()
	{
		try
		{
			return this.Time.getRound();
		}
		catch (e)
		{
			return -1;
		}
	}

	function hasFlagWeapon()
	{
		local actor = this.getActor();

		if (actor == null || actor.getItems() == null)
		{
			return false;
		}

		local item = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);

		if (item == null)
		{
			return false;
		}

		local id = item.getID();
		if (id == null || typeof id != "string")
		{
			id = "";
		}

		local categories = "";

		try
		{
			categories = item.m.Categories;
		}
		catch (e)
		{
			categories = "";
		}

		if (categories == null || typeof categories != "string")
		{
			categories = "";
		}

		return id.find("banner") != null
			|| id.find("standard") != null
			|| id.find("pike") != null
			|| id.find("billhook") != null
			|| id.find("hooked_blade") != null
			|| id.find("warscythe") != null
			|| id.find("pole") != null
			|| categories.find("Polearm") != null;
	}

	function getAuraRange()
	{
		return this.m.BaseAuraRange + (this.hasFlagWeapon() ? this.m.FlagAuraRangeBonus : 0);
	}

	function getName()
	{
		return this.m.Name + " (" + this.m.Edict + "/" + this.m.MaxEdict + ")";
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
				icon = "ui/icons/bravery.png",
				text = "$bv{skill.cerydra_war_banner.tooltip.aura_prefix}" + this.getAuraRange() + "$bv{skill.cerydra_war_banner.tooltip.aura_suffix}"
			},
			{
				id = 4,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cerydra_war_banner.tooltip.edict_prefix}" + this.m.Edict + "/" + this.m.MaxEdict + "$bv{skill.cerydra_war_banner.tooltip.edict_suffix}"
			},
			{
				id = 5,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "$bv{skill.cerydra_war_banner.tooltip.merit}"
			}
		];

		local record = this.getMilitaryRecord();

		if (record != null && record.Actor != null)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{skill.cerydra_war_banner.tooltip.current}" + record.Actor.getName()
			});
		}

		return ret;
	}

	function getAllActors()
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

	function getOwnedEffect( _actor, _id )
	{
		if (_actor == null || _actor.getSkills() == null)
		{
			return null;
		}

		local effect = _actor.getSkills().getSkillByID(_id);
		return effect != null && ("isOwnedBy" in effect) && effect.isOwnedBy(this.getActor()) ? effect : null;
	}

	function clearOwnedMilitaryState()
	{
		foreach( actor in this.getAllActors() )
		{
			local merit = this.getOwnedEffect(actor, ::$bvvar{namespace}.CerydraMilitaryMeritID);
			if (merit != null)
			{
				merit.removeSelf();
			}

			local peerage = this.getOwnedEffect(actor, ::$bvvar{namespace}.CerydraPeerageID);
			if (peerage != null)
			{
				peerage.removeSelf();
			}
		}
	}

	function clearOwnedAura()
	{
		foreach( actor in this.getAllActors() )
		{
			local aura = this.getOwnedEffect(actor, ::$bvvar{namespace}.CerydraBannerAuraID);
			if (aura != null)
			{
				aura.removeSelf();
			}
		}
	}

	function getMilitaryRecord()
	{
		foreach( actor in this.getAllActors() )
		{
			local peerage = this.getOwnedEffect(actor, ::$bvvar{namespace}.CerydraPeerageID);
			if (peerage != null)
			{
				return {
					Actor = actor,
					Effect = peerage,
					IsPeerage = true
				};
			}

			local merit = this.getOwnedEffect(actor, ::$bvvar{namespace}.CerydraMilitaryMeritID);
			if (merit != null)
			{
				return {
					Actor = actor,
					Effect = merit,
					IsPeerage = false
				};
			}
		}

		return null;
	}

	function getPeerageRecord()
	{
		local record = this.getMilitaryRecord();
		return record != null && record.IsPeerage ? record : null;
	}

	function assignMilitaryMerit( _target )
	{
		local actor = this.getActor();

		if (actor == null || _target == null || actor == _target || !actor.isAlliedWith(_target) || ::$bvvar{namespace}.isActorDeadOrDying(actor) || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		this.clearOwnedMilitaryState();
		this.m.Edict = 0;

		local effect = ::new("$bvvar{privateFolder}/skills/effects/cerydra_military_merit_effect");
		effect.setupOwner(actor);
		_target.getSkills().add(effect);
		_target.getSkills().update();

		if (_target.isPlacedOnMap())
		{
			effect.spawnIcon("status_effect_34", _target.getTile());
		}

		this.addEdict(1);
		return true;
	}

	function addEdict( _amount )
	{
		if (_amount <= 0)
		{
			return false;
		}

		local old = this.m.Edict;
		this.m.Edict = this.Math.min(this.m.MaxEdict, this.m.Edict + _amount);

		if (this.m.Edict != old)
		{
			local actor = this.getActor();

			if (actor != null && actor.isPlacedOnMap())
			{
				this.spawnIcon("status_effect_34", actor.getTile());
			}

			this.tryPromoteCurrentTarget();
			return true;
		}

		return false;
	}

	function resetEdict()
	{
		this.m.Edict = 0;
	}

	function getEdict()
	{
		return this.Math.max(0, this.Math.min(this.m.MaxEdict, this.m.Edict));
	}

	function hasFullEdict()
	{
		return this.m.Edict >= this.m.MaxEdict;
	}

	function tryPromoteCurrentTarget()
	{
		if (!this.hasFullEdict())
		{
			return false;
		}

		local record = this.getMilitaryRecord();

		if (record == null || record.Actor == null || record.IsPeerage)
		{
			return false;
		}

		return this.promoteToPeerage(record.Actor);
	}

	function promoteToPeerage( _target )
	{
		local actor = this.getActor();

		if (actor == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local merit = this.getOwnedEffect(_target, ::$bvvar{namespace}.CerydraMilitaryMeritID);
		if (merit != null)
		{
			merit.removeSelf();
		}

		local peerage = this.getOwnedEffect(_target, ::$bvvar{namespace}.CerydraPeerageID);
		if (peerage == null)
		{
			peerage = ::new("$bvvar{privateFolder}/skills/effects/cerydra_peerage_effect");
			peerage.setupOwner(actor);
			_target.getSkills().add(peerage);
		}

		::$bvvar{namespace}.removeCerydraNegativeEffects(_target);
		_target.getSkills().update();

		if (_target.isPlacedOnMap())
		{
			peerage.spawnIcon("status_effect_34", _target.getTile());
		}

		return true;
	}

	function downgradePeerageToMerit( _target )
	{
		local actor = this.getActor();

		if (actor == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target))
		{
			return false;
		}

		local peerage = this.getOwnedEffect(_target, ::$bvvar{namespace}.CerydraPeerageID);
		if (peerage != null)
		{
			peerage.removeSelf();
		}

		local merit = this.getOwnedEffect(_target, ::$bvvar{namespace}.CerydraMilitaryMeritID);
		if (merit == null)
		{
			merit = ::new("$bvvar{privateFolder}/skills/effects/cerydra_military_merit_effect");
			merit.setupOwner(actor);
			_target.getSkills().add(merit);
		}

		_target.getSkills().update();
		this.resetEdict();
		return true;
	}

	function canUseCommandThisRound()
	{
		return this.m.LastCommandRound != this.getCurrentRound();
	}

	function markCommandUsed()
	{
		this.m.LastCommandRound = this.getCurrentRound();
	}

	function refreshAura()
	{
		local actor = this.getActor();

		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap())
		{
			this.clearOwnedAura();
			return;
		}

		foreach( ally in this.getAllActors() )
		{
			local aura = this.getOwnedEffect(ally, ::$bvvar{namespace}.CerydraBannerAuraID);
			local isValidAlly = ally != null && ally != actor && ally.isAlliedWith(actor)
				&& !::$bvvar{namespace}.isActorDeadOrDying(ally) && ally.isPlacedOnMap();

			if (!isValidAlly)
			{
				if (aura != null)
				{
					aura.removeSelf();
					ally.getSkills().update();
				}

				continue;
			}

			if (aura == null)
			{
				aura = ::new("$bvvar{privateFolder}/skills/effects/cerydra_banner_aura_effect");
				aura.setupOwner(actor);
				ally.getSkills().add(aura);
			}

			ally.getSkills().update();
		}
	}

	function onCombatStarted()
	{
		this.m.Edict = 0;
		this.m.LastCommandRound = -1;
		this.refreshAura();
	}

	function onTurnStart()
	{
		this.refreshAura();
	}

	function onMovementFinished()
	{
		this.refreshAura();
	}

	function onRoundEnd()
	{
		this.refreshAura();
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "DamageResolved"
			|| !("Attacker" in _event) || !("Skill" in _event) || !("Victim" in _event))
		{
			return;
		}

		local owner = this.getActor();
		local attacker = _event.Attacker;
		local skill = _event.Skill;
		local target = _event.Victim;
		if (owner == null || ::$bvvar{namespace}.isActorDeadOrDying(owner)
			|| attacker == null || skill == null || target == null || ::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			return;
		}

		local options = { Source = "cerydra_peerage_fixed" };
		if ("ActionToken" in _event && _event.ActionToken != null) options.ActionToken <- _event.ActionToken;
		if ("AttemptToken" in _event && _event.AttemptToken != null) options.AttemptToken <- _event.AttemptToken;
		::$bvvar{namespace}.applyCerydraPeerageFixedDamage(owner, attacker, skill, target, options);
	}

	function onCombatFinished()
	{
		this.clearOwnedAura();
		this.clearOwnedMilitaryState();
		this.m.Edict = 0;
		this.m.LastCommandRound = -1;
		this.skill.onCombatFinished();
	}
});
