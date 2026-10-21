this.himeko_bond_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		Bond = 0,
		PendingStages = [],
		TriggeredStages = [],
		ChallengeSpawnedStages = [],
		WeaponRewardGranted = false,
		HelmetRewardGranted = false,
		ArmorRewardGranted = false,
		SummonerRewardGranted = false,
		TrailblazeUnlocked = false
	},

	function create()
	{
		this.character_trait.create();
		this.m.ID = "$bvvar{modId}.trait.himeko_bond";
		this.m.Name = "$bv{valkyrie.himeko.bond.trait.name}";
		this.m.Description = "$bv{valkyrie.himeko.bond.trait.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/himeko_trait_icon.png";
		this.m.Bond = 0;
		this.m.PendingStages = [];
		this.m.TriggeredStages = [];
		this.m.ChallengeSpawnedStages = [];
		this.m.WeaponRewardGranted = false;
		this.m.HelmetRewardGranted = false;
		this.m.ArmorRewardGranted = false;
		this.m.SummonerRewardGranted = false;
		this.m.TrailblazeUnlocked = false;
		this.m.IsSerialized = true;
	}

	function getBond()
	{
		return this.m.Bond;
	}

	function hasStage( _list, _stage )
	{
		foreach( stage in _list )
		{
			if (stage == _stage)
			{
				return true;
			}
		}

		return false;
	}

	function addStage( _list, _stage )
	{
		if (this.hasStage(_list, _stage))
		{
			return false;
		}

		_list.push(_stage);
		return true;
	}

	function removeStage( _list, _stage )
	{
		for( local i = _list.len() - 1; i >= 0; i = --i )
		{
			if (_list[i] == _stage)
			{
				_list.remove(i);
				return true;
			}
		}

		return false;
	}

	function isKnownStage( _stage )
	{
		if (!("HimekoBondStages" in ::$bvvar{namespace}))
		{
			return false;
		}

		foreach( stage in ::$bvvar{namespace}.HimekoBondStages )
		{
			if (stage.Value == _stage)
			{
				return true;
			}
		}

		return false;
	}

	function hasLowerUnresolvedChallenge( _stage )
	{
		foreach( pendingStage in this.m.PendingStages )
		{
			if (pendingStage < _stage)
			{
				return true;
			}
		}

		foreach( challengeStage in this.m.ChallengeSpawnedStages )
		{
			if (challengeStage < _stage)
			{
				return true;
			}
		}

		return false;
	}

	function queueReachedStages( _oldBond )
	{
		if (!("HimekoBondStages" in ::$bvvar{namespace}))
		{
			return;
		}

		foreach( stage in ::$bvvar{namespace}.HimekoBondStages )
		{
			if (_oldBond < stage.Value
				&& this.m.Bond >= stage.Value
				&& !this.hasStage(this.m.TriggeredStages, stage.Value)
				&& !this.hasStage(this.m.PendingStages, stage.Value)
				&& !this.hasStage(this.m.ChallengeSpawnedStages, stage.Value)
				&& !this.hasLowerUnresolvedChallenge(stage.Value))
			{
				this.m.PendingStages.push(stage.Value);
				return;
			}
		}
	}

	function addBond( _amount )
	{
		if (_amount <= 0)
		{
			return 0;
		}

		local oldBond = this.m.Bond;
		this.m.Bond = this.Math.max(0, this.Math.min(100, oldBond + _amount));
		this.queueReachedStages(oldBond);
		return this.m.Bond - oldBond;
	}

	function hasPendingStage()
	{
		return this.m.PendingStages.len() > 0;
	}

	function hasPendingStageValue( _stage )
	{
		return this.hasStage(this.m.PendingStages, _stage);
	}

	function hasTriggeredStage( _stage )
	{
		return this.hasStage(this.m.TriggeredStages, _stage);
	}

	function hasChallengeSpawnedStage( _stage )
	{
		return this.hasStage(this.m.ChallengeSpawnedStages, _stage);
	}

	function hasTrailblazeUnlocked()
	{
		return this.m.TrailblazeUnlocked;
	}

	function getNextPendingStage()
	{
		local next = 0;

		foreach( stage in this.m.PendingStages )
		{
			if (next == 0 || stage < next)
			{
				next = stage;
			}
		}

		return next;
	}

	function startChallengeStage( _stage )
	{
		if (!::$bvvar{namespace}.isHimekoBondChallengeStage(_stage) || !this.removeStage(this.m.PendingStages, _stage))
		{
			return false;
		}

		this.addStage(this.m.ChallengeSpawnedStages, _stage);
		return true;
	}

	function completeChallengeStage( _stage )
	{
		if (!::$bvvar{namespace}.isHimekoBondChallengeStage(_stage) || this.hasStage(this.m.TriggeredStages, _stage))
		{
			return false;
		}

		this.removeStage(this.m.PendingStages, _stage);
		this.removeStage(this.m.ChallengeSpawnedStages, _stage);
		this.addStage(this.m.TriggeredStages, _stage);

		if (_stage == 20)
		{
			this.m.WeaponRewardGranted = true;
		}
		else if (_stage == 40)
		{
			this.m.HelmetRewardGranted = true;
		}
		else if (_stage == 60)
		{
			this.m.ArmorRewardGranted = true;
		}
		else if (_stage == 80)
		{
			this.m.SummonerRewardGranted = true;
		}
		else if (_stage == 100)
		{
			this.m.TrailblazeUnlocked = true;
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor != null)
		{
			if (_stage == 100 && "syncActorSkills" in ::$bvvar{namespace})
			{
				local sync = ::$bvvar{namespace}.syncActorSkills(actor, "himeko-bond-100");
				if (!sync.Success)
				{
					try { ::logError("[Battle Valkyries] [HimekoBond] failed to replace the full-bond skill; lifecycle repair will retry"); } catch (e) {}
				}
			}
			actor.getSkills().update();
			actor.setDirty(true);
		}

		this.queueReachedStages(0);
		return true;
	}

	function getCurrentStageData()
	{
		local current = null;

		foreach( stage in ::$bvvar{namespace}.HimekoBondStages )
		{
			if (this.m.Bond >= stage.Value)
			{
				current = stage;
			}
		}

		return current;
	}

	function getNextStageData()
	{
		foreach( stage in ::$bvvar{namespace}.HimekoBondStages )
		{
			if (this.m.Bond < stage.Value)
			{
				return stage;
			}
		}

		return null;
	}

	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.value}" + this.m.Bond + " / 100" }
		];
		local current = this.getCurrentStageData();
		local next = this.getNextStageData();

		if (current != null)
		{
			ret.push({ id = 4, type = "text", icon = "ui/icons/morale.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.stage}" + current.Name });
		}

		ret.push({
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = next == null ? "$bv{valkyrie.himeko.bond.trait.tooltip.max}" : "$bv{valkyrie.himeko.bond.trait.tooltip.next}" + next.Name + " (" + next.Value + ")"
		});

		if (this.m.WeaponRewardGranted) ret.push({ id = 6, type = "text", icon = "ui/icons/asset_money.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.weapon}" });
		if (this.m.HelmetRewardGranted) ret.push({ id = 7, type = "text", icon = "ui/icons/armor_head.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.helmet}" });
		if (this.m.ArmorRewardGranted) ret.push({ id = 8, type = "text", icon = "ui/icons/armor_body.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.armor}" });
		if (this.m.SummonerRewardGranted) ret.push({ id = 9, type = "text", icon = "ui/icons/special.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.summoner}" });
		if (this.m.TrailblazeUnlocked) ret.push({ id = 10, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{valkyrie.himeko.bond.trait.tooltip.oath}" });
		return ret;
	}

	function writeStageArray( _out, _list )
	{
		_out.writeU8(_list.len());

		foreach( stage in _list )
		{
			_out.writeU8(stage);
		}
	}

	function readStageArray( _in )
	{
		local ret = [];
		local count = _in.readU8();

		for( local i = 0; i < count; i = ++i )
		{
			local stage = _in.readU8();

			if (this.isKnownStage(stage) && !this.hasStage(ret, stage))
			{
				ret.push(stage);
			}
		}

		return ret;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(1);
		_out.writeU16(this.m.Bond);
		this.writeStageArray(_out, this.m.PendingStages);
		this.writeStageArray(_out, this.m.TriggeredStages);
		this.writeStageArray(_out, this.m.ChallengeSpawnedStages);
		_out.writeBool(this.m.WeaponRewardGranted);
		_out.writeBool(this.m.HelmetRewardGranted);
		_out.writeBool(this.m.ArmorRewardGranted);
		_out.writeBool(this.m.SummonerRewardGranted);
		_out.writeBool(this.m.TrailblazeUnlocked);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		local version = _in.readU8();
		this.m.Bond = this.Math.max(0, this.Math.min(100, _in.readU16()));
		this.m.PendingStages = this.readStageArray(_in);
		this.m.TriggeredStages = this.readStageArray(_in);
		this.m.ChallengeSpawnedStages = this.readStageArray(_in);
		this.m.WeaponRewardGranted = _in.readBool();
		this.m.HelmetRewardGranted = _in.readBool();
		this.m.ArmorRewardGranted = _in.readBool();
		this.m.SummonerRewardGranted = _in.readBool();
		this.m.TrailblazeUnlocked = _in.readBool();
	}
});
