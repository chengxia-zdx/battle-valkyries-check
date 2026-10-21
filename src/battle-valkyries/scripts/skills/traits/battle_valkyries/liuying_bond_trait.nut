this.liuying_bond_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		Bond = 0,
		PendingStages = [],
		TriggeredStages = [],
		ChallengeSpawnedStages = [],
		AttributeBoostGranted = false,
		CoreRewardGranted = false,
		UltimateSkillUnlocked = false
	},

	function create()
	{
		this.character_trait.create();
		this.m.ID = "$bvvar{modId}.trait.liuying_bond";
		this.m.Name = "$bv{valkyrie.liuying.bond.trait.name}";
		this.m.Description = "$bv{valkyrie.liuying.bond.trait.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/liuying_trait_icon.png";
		this.m.Bond = 0;
		this.m.PendingStages = [];
		this.m.TriggeredStages = [];
		this.m.ChallengeSpawnedStages = [];
		this.m.AttributeBoostGranted = false;
		this.m.CoreRewardGranted = false;
		this.m.UltimateSkillUnlocked = false;
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
		if (!this.hasStage(_list, _stage))
		{
			_list.push(_stage);
			return true;
		}

		return false;
	}

	function isKnownStage( _stage )
	{
		if (!("LiuyingBondStages" in ::$bvvar{namespace}))
		{
			return false;
		}

		foreach( stage in ::$bvvar{namespace}.LiuyingBondStages )
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
		if (!("LiuyingBondStages" in ::$bvvar{namespace}))
		{
			return;
		}

		foreach( stage in ::$bvvar{namespace}.LiuyingBondStages )
		{
			if (_oldBond < stage.Value
				&& this.m.Bond >= stage.Value
				&& !this.hasStage(this.m.TriggeredStages, stage.Value)
				&& !this.hasStage(this.m.PendingStages, stage.Value)
				&& !this.hasStage(this.m.ChallengeSpawnedStages, stage.Value)
				&& !this.hasLowerUnresolvedChallenge(stage.Value))
			{
				this.m.PendingStages.push(stage.Value);
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
		this.m.Bond = this.Math.max(0, this.Math.min(100, this.m.Bond + _amount));

		if (this.m.Bond <= oldBond || !("LiuyingBondStages" in ::$bvvar{namespace}))
		{
			return this.m.Bond - oldBond;
		}

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

	function hasUltimateSkillUnlocked()
	{
		return this.m.UltimateSkillUnlocked;
	}

	function getEnemyScalingThreat()
	{
		local threat = 0.0;

		foreach( stage in this.m.TriggeredStages )
		{
			threat += ::$bvvar{namespace}.getLiuyingBondThreatFromStage(stage);
		}

		return threat;
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

	function removePendingStage( _stage )
	{
		for( local i = this.m.PendingStages.len() - 1; i >= 0; i = --i )
		{
			if (this.m.PendingStages[i] == _stage)
			{
				this.m.PendingStages.remove(i);
				return true;
			}
		}

		return false;
	}

	function completePendingStage( _stage )
	{
		if (!this.removePendingStage(_stage))
		{
			return false;
		}

		this.addStage(this.m.TriggeredStages, _stage);

		if (::World != null && ::World.Assets != null)
		{
			local money = ::$bvvar{namespace}.getLiuyingBondMoneyReward(_stage);

			if (money > 0)
			{
				::World.Assets.addMoney(money);
			}
		}

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();

		if (actor != null)
		{
			actor.setPerkPoints(actor.getPerkPoints() + ::$bvvar{namespace}.getLiuyingBondPerkReward(_stage));
		}

		return true;
	}

	function removeChallengeSpawnedStage( _stage )
	{
		for( local i = this.m.ChallengeSpawnedStages.len() - 1; i >= 0; i = --i )
		{
			if (this.m.ChallengeSpawnedStages[i] == _stage)
			{
				this.m.ChallengeSpawnedStages.remove(i);
				return true;
			}
		}

		return false;
	}

	function startChallengeStage( _stage )
	{
		if (!::$bvvar{namespace}.isLiuyingBondChallengeStage(_stage) || !this.removePendingStage(_stage))
		{
			return false;
		}

		this.addStage(this.m.ChallengeSpawnedStages, _stage);
		return true;
	}

	function grantPerkReward( _actor, _stage )
	{
		if (_actor != null)
		{
			_actor.setPerkPoints(_actor.getPerkPoints() + ::$bvvar{namespace}.getLiuyingBondPerkReward(_stage));
		}
	}

	function grantAttributeBoost( _actor )
	{
		if (_actor == null || this.m.AttributeBoostGranted)
		{
			return false;
		}

		local boost = ::$bvvar{namespace}.LiuyingBondAttributeReward;
		local p = _actor.getBaseProperties();
		p.Hitpoints += boost;
		p.Bravery += boost;
		p.Stamina += boost;
		p.MeleeSkill += boost;
		p.RangedSkill += boost;
		p.MeleeDefense += boost;
		p.RangedDefense += boost;
		p.Initiative += boost;
		this.m.AttributeBoostGranted = true;

		_actor.getSkills().update();
		_actor.setHitpoints(this.Math.min(_actor.getHitpointsMax(), _actor.getHitpoints() + boost));
		_actor.setDirty(true);
		return true;
	}

	function completeChallengeStage( _stage )
	{
		if (!::$bvvar{namespace}.isLiuyingBondChallengeStage(_stage) || this.hasStage(this.m.TriggeredStages, _stage))
		{
			return false;
		}

		this.removePendingStage(_stage);
		this.removeChallengeSpawnedStage(_stage);
		this.addStage(this.m.TriggeredStages, _stage);

		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		this.grantPerkReward(actor, _stage);

		if (::World != null && ::World.Assets != null)
		{
			local money = ::$bvvar{namespace}.getLiuyingBondMoneyReward(_stage);

			if (money > 0)
			{
				::World.Assets.addMoney(money);
			}
		}

		if (_stage == 60)
		{
			this.grantAttributeBoost(actor);
			this.m.CoreRewardGranted = true;
		}
		else if (_stage == 100)
		{
			this.m.UltimateSkillUnlocked = true;
		}

		if (actor != null)
		{
			actor.getSkills().update();
			actor.setDirty(true);
		}

		this.queueReachedStages(0);
		return true;
	}

	function getCurrentStageData()
	{
		if (!("LiuyingBondStages" in ::$bvvar{namespace}))
		{
			return null;
		}

		local current = null;

		foreach( stage in ::$bvvar{namespace}.LiuyingBondStages )
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
		if (!("LiuyingBondStages" in ::$bvvar{namespace}))
		{
			return null;
		}

		foreach( stage in ::$bvvar{namespace}.LiuyingBondStages )
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
				icon = "ui/icons/special.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.value}" + this.m.Bond + " / 100"
			}
		];

		local current = this.getCurrentStageData();

		if (current != null)
		{
			ret.push({
				id = 4,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.stage}" + current.Name
			});
		}

		local next = this.getNextStageData();

		if (next != null)
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.next}" + next.Name + " (" + next.Value + ")"
			});
		}
		else
		{
			ret.push({
				id = 5,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.max}"
			});
		}

		if (this.m.AttributeBoostGranted)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/level.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.attribute_boost}"
			});
		}

		if (this.m.CoreRewardGranted)
		{
			ret.push({
				id = 7,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.core}"
			});
		}

		if (this.m.UltimateSkillUnlocked)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/special.png",
				text = "$bv{valkyrie.liuying.bond.trait.tooltip.ultimate}"
			});
		}

		return ret;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(1);
		_out.writeU16(this.m.Bond);
		_out.writeU8(this.m.PendingStages.len());

		foreach( stage in this.m.PendingStages )
		{
			_out.writeU8(stage);
		}

		_out.writeU8(this.m.TriggeredStages.len());

		foreach( stage in this.m.TriggeredStages )
		{
			_out.writeU8(stage);
		}

		_out.writeU8(this.m.ChallengeSpawnedStages.len());

		foreach( stage in this.m.ChallengeSpawnedStages )
		{
			_out.writeU8(stage);
		}

		_out.writeBool(this.m.AttributeBoostGranted);
		_out.writeBool(this.m.CoreRewardGranted);
		_out.writeBool(this.m.UltimateSkillUnlocked);
	}

	function onDeserialize( _in )
	{
		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.onDeserialize.begin");
		}

		this.skill.onDeserialize(_in);
		local version = _in.readU8();
		this.m.Bond = this.Math.max(0, this.Math.min(100, _in.readU16()));

		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.header version=" + version + " bond=" + this.m.Bond);
		}

		this.m.PendingStages = [];
		this.m.TriggeredStages = [];
		this.m.ChallengeSpawnedStages = [];
		this.m.AttributeBoostGranted = false;
		this.m.CoreRewardGranted = false;
		this.m.UltimateSkillUnlocked = false;

		local numPending = _in.readU8();

		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.pending count=" + numPending);
		}

		for( local i = 0; i < numPending; i = ++i )
		{
			local stage = _in.readU8();

			if (this.isKnownStage(stage) && !this.hasStage(this.m.PendingStages, stage))
			{
				this.m.PendingStages.push(stage);
			}
		}

		local numTriggered = _in.readU8();

		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.triggered count=" + numTriggered);
		}

		for( local i = 0; i < numTriggered; i = ++i )
		{
			local stage = _in.readU8();

			if (this.isKnownStage(stage) && !this.hasStage(this.m.TriggeredStages, stage))
			{
				this.m.TriggeredStages.push(stage);
			}
		}

		local numChallengeSpawned = _in.readU8();

		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.challengeSpawned count=" + numChallengeSpawned);
		}

		for( local i = 0; i < numChallengeSpawned; i = ++i )
		{
			local stage = _in.readU8();

			if (this.isKnownStage(stage) && !this.hasStage(this.m.ChallengeSpawnedStages, stage))
			{
				this.m.ChallengeSpawnedStages.push(stage);
			}
		}

		this.m.AttributeBoostGranted = _in.readBool();
		this.m.CoreRewardGranted = _in.readBool();
		this.m.UltimateSkillUnlocked = _in.readBool();

		if ("logSaveLoadDebug" in ::$bvvar{namespace})
		{
			::$bvvar{namespace}.logSaveLoadDebug("liuying_bond_trait.onDeserialize.end attributeBoost=" + (this.m.AttributeBoostGranted ? "true" : "false") + " coreReward=" + (this.m.CoreRewardGranted ? "true" : "false") + " ultimate=" + (this.m.UltimateSkillUnlocked ? "true" : "false"));
		}
	}
});
