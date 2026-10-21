this.valkyrie_bounty_contract <- this.inherit("scripts/contracts/contract", {
	m = {
		SerializationVersion = 5,
		IsCamp = false,
		CampSize = 0,
		CampT4 = 0,
		CampT5 = 0,
		Target = null,
		TargetEntityID = 0,
		BountyID = "",
		ValkyrieID = "",
		Stars = 1,
		Reward = 0,
		AcceptedValkyrieCount = 0,
		EscortBudget = 0,
		FixedChampionCount = 0,
		ChampionPolicyID = "",
		EnemyThemeID = "",
		TargetKilled = false, // Persisted compatibility name: confirmed victory, including enemy retreat.
		IsPlayerAttacking = false,
		StartDay = 0,
		WasSuccessful = false,
		IsTimedOut = false,
		SafeCancelAfterDeserialize = false,
		RewardScreenShown = false,
		RewardSettlementFailed = false
	},

	function create()
	{
		this.contract.create();
		this.m.Type = "contract.valkyrie_bounty";
		this.m.Name = "$bv{contract.bounty.name}";
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
	}

	function configureBounty( _snapshot, _home )
	{
		this.m.BountyID = _snapshot.BountyID;
		this.m.ValkyrieID = _snapshot.ValkyrieID;
		this.m.Stars = _snapshot.Stars;
		this.m.Reward = _snapshot.Reward;
		this.m.AcceptedValkyrieCount = _snapshot.AcceptedValkyrieCount;
		this.m.EscortBudget = _snapshot.EscortBudget;
		this.m.FixedChampionCount = _snapshot.FixedChampionCount;
		this.m.ChampionPolicyID = _snapshot.ChampionPolicyID;
		this.m.EnemyThemeID = _snapshot.EnemyThemeID;
		this.m.IsCamp = "IsCamp" in _snapshot && _snapshot.IsCamp;
		if (this.m.IsCamp)
		{
			this.m.CampSize = _snapshot.CampSize;
			this.m.CampT4 = _snapshot.CampT4;
			this.m.CampT5 = _snapshot.CampT5;
		}
		this.setHome(_home);
		this.setOrigin(_home);
		this.setFaction(_home.getFaction());

		// Legends contract UI expects every settlement contract to have a real
		// employer character. Without it, activation refresh calls getName() on an
		// invalid character object and the contract manager rolls back acceptance.
		local issuerFaction = this.World.FactionManager.getFaction(_home.getFaction());
		local employer = issuerFaction == null ? null : issuerFaction.getRandomCharacter();
		if (employer == null)
		{
			throw "[Battle Valkyries] Bounty contract has no valid settlement employer.";
		}

		this.setEmployerID(employer.getID());
		::logInfo("[Battle Valkyries][BountyDebug] stage=contract.employer.done bounty=" + this.m.BountyID + " employer=" + employer.getID() + " employer_name=" + employer.getName());
	}

	function getBountyID()
	{
		return this.m.BountyID;
	}

	function getBountyCombatID()
	{
		return "BattleValkyriesBounty:" + this.m.BountyID;
	}

	function isBountyEntityNull( _entity )
	{
		if (_entity == null)
		{
			return true;
		}

		try
		{
			return "isNull" in _entity && _entity.isNull();
		}
		catch (e)
		{
			return true;
		}
	}

	function getBountyTroopType( _symbol, _script )
	{
		local troops = this.Const.World.Spawn.Troops;
		if (typeof troops == "table" && _symbol in troops)
		{
			return troops[_symbol];
		}

		local scriptMap = null;
		try
		{
			scriptMap = this.Const.World.Spawn.RF_ScriptToTroopMap;
		}
		catch (e)
		{
			scriptMap = null;
		}

		if (typeof scriptMap == "table" && _script in scriptMap)
		{
			return scriptMap[_script];
		}

		foreach( troop in troops )
		{
			if (typeof troop == "table" && "Script" in troop && troop.Script == _script)
			{
				return troop;
			}
		}

		return null;
	}

	function startBounty()
	{
		if (this.m.IsCamp) return this.startBountyCamp();
		// contract_manager.addContract() intentionally adds its offer-time jitter.
		// A Hub bounty is already accepted, so reset the fixed deadline only after
		// it has entered that manager flow.
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.contract.start();
		this.m.StartDay = this.World.getTime().Days;
		local theme = ::$bvvar{namespace}.getValkyrieBountyEnemyThemeByID(this.m.EnemyThemeID);
		if (theme == null)
		{
			throw "[Battle Valkyries] Bounty contract has no valid enemy theme: " + this.m.EnemyThemeID;
		}

		local player = this.World.State.getPlayer();
		if (player == null)
		{
			throw "[Battle Valkyries] Bounty target spawn failed: player party unavailable.";
		}

		// Home/Origin only satisfy the vanilla contract metadata contract. The Hub
		// accepts this bounty wherever the player is, so the actual trail must begin
		// at the player instead of at an otherwise unknown issuing settlement.
		local trailOriginTile = player.getTile();
		local tile = this.getTileToSpawnLocation(trailOriginTile, 5, 10, [this.Const.World.TerrainType.Mountains], true, true, true);
		if (tile == null)
		{
			throw "[Battle Valkyries] Bounty target spawn failed: no reachable land tile.";
		}

		local factionType = this.Const.FactionType[theme.FactionType];
		local spawnTemplate = this.Const.World.Spawn[theme.SpawnTemplate];
		local lowBudgetTest = ::$bvvar{namespace}.ValkyrieBountyDifficulty.DebugLowBudgetTest;
		local enemyFaction = this.World.FactionManager.getFactionOfType(factionType);
		if (enemyFaction == null || spawnTemplate == null)
		{
			throw "[Battle Valkyries] Bounty target spawn failed: unavailable theme runtime data.";
		}

		// Do not use getScaledDifficultyMult() or getMinibossModifier(): bounty
		// snapshot values are already final and must not be multiplied again.
		local minibossBypass = 0;
		if ("getValkyrieEnemyMinibossBonus" in ::$bvvar{namespace})
		{
			minibossBypass = -::$bvvar{namespace}.getValkyrieEnemyMinibossBonus("world");
		}
		// Low-budget testing uses the exact normal template and normal spawn path.
		local party = enemyFaction.spawnEntity(tile, "$bv{contract.bounty.target_name}", false, spawnTemplate, this.m.EscortBudget, minibossBypass);
		if (party == null)
		{
			throw "[Battle Valkyries] Bounty target spawn failed: faction returned no party.";
		}

		party.setDescription("$bv{contract.bounty.target_description}");
		party.setFootprintType(this.Const.World.FootprintsType[theme.FootprintType]);
		party.setFootprintSizeOverride(0.75);
		party.setAttackableByAI(false);
		party.getController().getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
		if (lowBudgetTest)
		{
			::logInfo("[Battle Valkyries][BountyDebug] stage=low_budget_test.enabled bounty=" + this.m.BountyID + " budget=" + this.m.EscortBudget + " troops=" + party.getTroops().len());
		}
		else
		{
			this.addFixedBountyChampions(party);
		}

		this.Const.World.Common.addFootprintsFromTo(trailOriginTile, party.getTile(), this.Const.GenericFootprints, this.Const.World.FootprintsType[theme.FootprintType], 0.75);
		this.m.Target = this.WeakTableRef(party);
		this.m.TargetEntityID = party.getID();
		party.getSprite("selection").Visible = true;
		party.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
		this.setState("Running");
		::logInfo("[Battle Valkyries] Bounty target created near player: contract=" + this.getID() + ", home=" + this.m.Home.getID() + ", target=" + this.m.TargetEntityID);
	}

	function startBountyCamp()
	{
		local ns = ::$bvvar{namespace};
		local t = ns.BountyCamps.theme(this.m.EnemyThemeID);
		if (!ns.BountyCamps.available(t)) throw "[Battle Valkyries] Bounty camp theme unavailable";
		local player = this.World.State.getPlayer();
		if (player == null) throw "[Battle Valkyries] Bounty camp needs player position";
		local tile = this.getTileToSpawnLocation(player.getTile(), 6, 12, [this.Const.World.TerrainType.Mountains], false, true, true);
		if (tile == null) throw "[Battle Valkyries] No reachable bounty camp tile";
		local camp = this.World.spawnLocation("scripts/entity/world/locations/battle_valkyries_bounty_camp", tile.Coords);
		if (camp == null) throw "[Battle Valkyries] Failed to create bounty camp";
		// Own the location before fallible setup so acceptance rollback can remove it.
		this.m.Target = this.WeakTableRef(camp);
		this.m.TargetEntityID = camp.getID();
		camp.getFlags().set("BVBountyCampID", this.m.BountyID);
		camp.getFlags().set("BVBountyCampTheme", t.ID);
		camp.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[t.Faction]).getID());
		camp.applyBountyTheme();
		ns.BountyCamps.populate(camp, t, this.m.AcceptedValkyrieCount);
		camp.setDiscovered(true);
		camp.setAttackableByAI(false);
		camp.getSprite("selection").Visible = true;
		camp.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
		this.m.TimeOut = this.Time.getVirtualTimeF() + this.World.getTime().SecondsPerDay * 7.0;
		this.contract.start();
		this.m.StartDay = this.World.getTime().Days;
		this.setState("Running");
	}

	function addFixedBountyChampions( _party )
	{
		local theme = ::$bvvar{namespace}.getValkyrieBountyEnemyThemeByID(this.m.EnemyThemeID);
		if (theme == null)
		{
			return;
		}

		for (local i = 0; i < this.m.FixedChampionCount; i = ++i)
		{
			if (this.m.ChampionPolicyID == "vanilla_champion")
			{
				local championType = this.getBountyTroopType(theme.ChampionTroop, theme.ChampionTroopScript);
				if (championType == null)
				{
					throw "[Battle Valkyries] Bounty champion troop is unavailable: " + theme.ChampionTroopScript;
				}

				// Only this branch requests Variant/miniboss behavior, so Named gear
				// remains exclusively in the vanilla Wildmen champion path.
				this.Const.World.Common.addTroop(_party, { Type = championType }, true, 100);
			}
			else
			{
				local resolvedEliteType = this.getBountyTroopType(theme.BountyEliteTroop, theme.BountyEliteTroopScript);
				if (resolvedEliteType == null)
				{
					throw "[Battle Valkyries] Bounty elite troop is unavailable: " + theme.BountyEliteTroopScript;
				}

				local eliteType = clone resolvedEliteType;
				eliteType.Script = "scripts/entity/tactical/enemies/battle_valkyries/valkyrie_bounty_elite";
				eliteType.Variant = 0;
				local elite = this.Const.World.Common.addTroop(_party, { Type = eliteType }, true, 0);
				elite.Name = "$bv{contract.bounty.elite.name}";
				elite.IsValkyrieBountyElite <- true;
			}
		}
	}

	function getChampionPolicyObjective()
	{
		if (this.m.IsCamp) return this.m.FixedChampionCount > 0 ? "$bv{bounty.camp.objective.champions}" : "$bv{bounty.camp.objective.elites}";
		return this.m.ChampionPolicyID == "vanilla_champion"
			? "$bv{contract.bounty.champions.vanilla}"
			: "$bv{contract.bounty.champions.elite}";
	}

	function createStates()
	{
		this.m.States.push({
			ID = "Running",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = this.Contract.m.IsCamp
					? ["$bv{bounty.camp.objective.destroy}", "$bv{bounty.camp.objective.victory}"]
					: ["$bv{contract.bounty.objective.track}", this.Contract.getChampionPolicyObjective()];
			},
			function update()
			{
				if (this.Contract.isBountyEntityNull(this.Contract.m.Target))
				{
					this.Contract.cleanupBountyTarget("unexpected_target_disappearance");
					::logWarning("[Battle Valkyries] Bounty target disappeared without a confirmed player victory: " + this.Contract.m.BountyID);
					this.World.Contracts.finishActiveContract(true);
				}
			}
			function onCombatVictory( _combatID )
			{
				if (_combatID != this.Contract.getBountyCombatID())
				{
					return;
				}

				// The host reports EnemyDestroyed and EnemyRetreated as victories.
				// Surviving/escaped defenders (including champions) never block rewards.
				this.Contract.m.TargetKilled = true;
				this.Contract.setState("RewardPending");
			}
			function onRetreatedFromCombat( _combatID )
			{
				if (_combatID != this.Contract.getBountyCombatID())
				{
					return;
				}
			}
		});
		this.m.States.push({
			ID = "RewardPending",
			function start()
			{
				this.Contract.m.BulletpointsObjectives = ["$bv{contract.bounty.objective.claim}"];
			},
			function update()
			{
				if (!this.Contract.m.RewardScreenShown)
				{
					this.Contract.m.RewardScreenShown = true;
					this.Contract.setScreen("Success");
					this.World.Contracts.showActiveContract();
				}
			}
		});
		// Schema-v3 saves may have persisted this state. It is now only a
		// migration alias and must never restore the old Home-return flow.
		this.m.States.push({
			ID = "Return",
			function start()
			{
				this.Contract.setState("RewardPending");
			},
			function update()
			{
				this.Contract.setState("RewardPending");
				this.Contract.m.ActiveState.update();
			}
		});
	}

	function createScreens()
	{
		this.importScreens(this.Const.Contracts.Overview);
		this.m.Screens.push({
			ID = "Success",
			Title = "$bv{contract.bounty.success.title}",
			Text = "$bv{contract.bounty.success.text}",
			Image = "",
			Characters = [],
			List = [],
			ShowEmployer = false,
			Options = [
				{
					Text = "$bv{contract.bounty.success.claim}",
					function getResult()
					{
						if (this.Contract.m.WasSuccessful)
						{
							return 0;
						}

						local result = null;
						try
						{
							result = ::$bvvar{namespace}.settleValkyrieBountyReward({
								BountyID = this.Contract.m.BountyID,
								ValkyrieID = this.Contract.m.ValkyrieID,
								Stars = this.Contract.m.Stars,
								Reward = this.Contract.m.Reward
							}, null);
						}
						catch (e)
						{
							::logWarning("[Battle Valkyries] Bounty reward settlement threw for " + this.Contract.m.BountyID + ": " + e);
						}

						if (result == null || !("Success" in result) || !result.Success)
						{
							this.Contract.m.RewardSettlementFailed = true;
							local code = result != null && "Code" in result ? result.Code : "exception";
							::logWarning("[Battle Valkyries] Bounty reward settlement failed for " + this.Contract.m.BountyID + ": " + code);
							return "Success";
						}

						this.Contract.m.WasSuccessful = true;
						this.Contract.cleanupBountyTarget("success");
						this.World.Contracts.finishActiveContract(false);
						return 0;
					}
				}
			]
		});
	}

	function onPrepareVariables( _vars )
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(this.m.ValkyrieID);
		_vars.push(["valkyrie", template == null ? this.m.ValkyrieID : template.Name]);
		_vars.push(["stars", this.m.Stars]);
		_vars.push(["reward", this.m.Reward]);
		_vars.push(["claim_failure", this.m.RewardSettlementFailed ? "$bv{contract.bounty.success.failure}" : ""]);
	}

	function update()
	{
		if (this.m.SafeCancelAfterDeserialize)
		{
			this.m.SafeCancelAfterDeserialize = false;
			this.cleanupBountyTarget("unsupported_serialization");
			::logWarning("[Battle Valkyries] Bounty contract cancelled after unsupported serialized payload.");
			this.World.Contracts.finishActiveContract(true);
			return;
		}

		// Only an unconfirmed Running bounty may expire. RewardPending (and the
		// legacy Return alias that routes into it) must reach the world-layer
		// reward screen even when the deadline is crossed during tactical combat.
		if (this.m.ActiveState != null && this.m.ActiveState.ID != "Running")
		{
			this.m.ActiveState.update();
			return;
		}

		if (this.m.ActiveState != null && this.m.ActiveState.ID == "Running" && !this.m.TargetKilled && !this.m.IsTimedOut && this.Time.getVirtualTimeF() >= this.m.TimeOut)
		{
			this.m.IsTimedOut = true;
			this.cleanupBountyTarget("timeout");
			::logInfo("[Battle Valkyries] Bounty contract timed out: " + this.m.BountyID);
			this.World.Contracts.finishActiveContract(true);
			return;
		}

		if (this.m.ActiveState != null && "update" in this.m.ActiveState)
		{
			this.m.ActiveState.update();
		}
	}

	function onTargetAttacked( _target, _isPlayerAttacking )
	{
		if (this.isBountyEntityNull(_target))
		{
			return;
		}

		local properties = this.World.State.getLocalCombatProperties(_target.getPos(), true);
		// Use the host location encounter: it owns terrain, surviving troops and loot.
		properties.CombatID = this.getBountyCombatID();
		this.World.Contracts.startScriptedCombat(properties, true, true, true);
	}

	function cleanupBountyTarget( _reason )
	{
		if (!this.isBountyEntityNull(this.m.Target))
		{
			if (this.m.IsCamp && this.m.Target.getFlags().get("BVBountyCampID") != this.m.BountyID)
			{
				this.m.Target = null;
				this.m.TargetEntityID = 0;
				return;
			}
			this.m.Target.setOnCombatWithPlayerCallback(null);
			this.m.Target.getSprite("selection").Visible = false;
			if (this.m.Target.isAlive())
			{
				this.m.Target.die();
			}
		}

		this.m.Target = null;
		this.m.TargetEntityID = 0;
		::logInfo("[Battle Valkyries] Bounty target cleanup: " + _reason);
	}

	function cancel()
	{
		this.contract.cancel();
		this.cleanupBountyTarget("cancel");
	}

	function onClear()
	{
		this.cleanupBountyTarget(this.m.WasSuccessful ? "success" : "clear");
		if (!this.isBountyEntityNull(this.m.Home))
		{
			this.m.Home.getSprite("selection").Visible = false;
		}
		this.contract.onClear();
	}

	function onIsValid()
	{
		return this.m.BountyID != "" && this.m.ValkyrieID != "" && this.m.EnemyThemeID != "";
	}

	function onSerialize( _out )
	{
		_out.writeI32(this.m.SerializationVersion);
		_out.writeString(this.getSerializedBountyPayload());
		this.contract.onSerialize(_out);
	}

	function getSerializedBountyPayload()
	{
		local targetID = !this.isBountyEntityNull(this.m.Target) ? this.m.Target.getID() : this.m.TargetEntityID;
		return targetID + "|" + this.m.BountyID + "|" + this.m.ValkyrieID + "|" + this.m.Stars + "|" + this.m.AcceptedValkyrieCount + "|" + this.m.EscortBudget + "|" + this.m.FixedChampionCount + "|" + this.m.ChampionPolicyID + "|" + this.m.EnemyThemeID + "|" + (this.m.TargetKilled ? 1 : 0) + "|" + (this.m.IsPlayerAttacking ? 1 : 0) + "|" + this.m.StartDay + "|" + this.m.Reward + "|" + (this.m.IsCamp ? 1 : 0) + "|" + this.m.CampSize + "|" + this.m.CampT4 + "|" + this.m.CampT5;
	}

	function deserializeBountyPayload( _payload, _version )
	{
		local parts = split(_payload, "|");
		local expectedFields = _version == 3 ? 12 : (_version == 4 ? 13 : 17);
		if (parts.len() != expectedFields)
		{
			return false;
		}

		this.m.TargetEntityID = parts[0].tointeger();
		this.m.BountyID = parts[1];
		this.m.ValkyrieID = parts[2];
		this.m.Stars = parts[3].tointeger();
		this.m.AcceptedValkyrieCount = parts[4].tointeger();
		this.m.EscortBudget = parts[5].tointeger();
		this.m.FixedChampionCount = parts[6].tointeger();
		this.m.ChampionPolicyID = parts[7];
		this.m.EnemyThemeID = parts[8];
		this.m.TargetKilled = parts[9].tointeger() != 0;
		this.m.IsPlayerAttacking = parts[10].tointeger() != 0;
		this.m.StartDay = parts[11].tointeger();
		this.m.Reward = _version == 3 ? ::$bvvar{namespace}.getValkyrieBountyReward(this.m.Stars) : parts[12].tointeger();
		this.m.IsCamp = _version >= 5 && parts[13] == "1";
		if (_version >= 5)
		{
			if (parts[13] != "0" && parts[13] != "1") return false;
			this.m.CampSize = parts[14].tointeger();
			this.m.CampT4 = parts[15].tointeger();
			this.m.CampT5 = parts[16].tointeger();
			// Keep the historical size ceiling for existing camps; new one-star camps have no T5.
			if (this.m.IsCamp && (this.m.CampSize < 1 || this.m.CampSize > 28 + this.m.FixedChampionCount || this.m.CampT4 < 0 || this.m.CampT5 < 0
				|| this.m.FixedChampionCount < 0 || this.m.FixedChampionCount > 12 || this.m.CampT4 + this.m.CampT5 + this.m.FixedChampionCount > this.m.CampSize || this.m.EscortBudget <= 0)) return false;
		}
		return this.m.BountyID != "" && this.m.ValkyrieID != "" && this.m.EnemyThemeID != "" && this.m.Stars >= 1 && this.m.Stars <= 3 && this.m.Reward >= 0;
	}

	function onDeserialize( _in )
	{
		local version = _in.readI32();
		local canRestoreTarget = false;
		if (version == 1)
		{
			this.m.TargetEntityID = _in.readU32();
			this.m.BountyID = _in.readString();
			this.m.ValkyrieID = _in.readString();
			this.m.Stars = _in.readU8();
			this.m.AcceptedValkyrieCount = _in.readU8();
			this.m.EscortBudget = _in.readU16();
			this.m.FixedChampionCount = _in.readU8();
			// v1 predates a persisted champion policy. Do not re-evaluate DLC here:
			// it would turn the same active contract into different rewards after load.
			this.m.SafeCancelAfterDeserialize = true;
			this.m.EnemyThemeID = _in.readString();
			this.m.TargetKilled = _in.readBool();
			this.m.IsPlayerAttacking = _in.readBool();
		}
		else
		{
			// Schema v2+ deliberately keeps the whole custom payload inside one
			// length-prefixed string. Future versions can therefore be discarded
			// without desynchronizing the parent contract's binary stream.
			local payload = _in.readString();
			if (version == this.m.SerializationVersion || version == 4 || version == 3)
			{
				try { canRestoreTarget = this.deserializeBountyPayload(payload, version); }
				catch (e) { canRestoreTarget = false; }
				if (!canRestoreTarget) this.m.SafeCancelAfterDeserialize = true;
			}
			else
			{
				this.m.SafeCancelAfterDeserialize = true;
				if (version == 2)
				{
					::logWarning("[Battle Valkyries] Legacy bounty contract schema v2 has no persisted champion policy; payload discarded and contract will be cancelled safely.");
				}
				else
				{
					::logWarning("[Battle Valkyries] Unsupported bounty contract serialization version " + version + "; payload discarded and contract will be cancelled safely.");
				}
			}
		}
		// This v3 field only described how the encounter was initiated; it was
		// never a stable identity for the combat that eventually reported back.
		// Clear it for every restored schema, including legacy v3 payloads that
		// persisted true, and authorize outcomes exclusively by CombatID.
		this.m.IsPlayerAttacking = false;
		this.contract.onDeserialize(_in);
		if (canRestoreTarget && this.m.TargetEntityID != 0)
		{
			local target = this.World.getEntityByID(this.m.TargetEntityID);
			if (target != null && (!this.m.IsCamp || (target.getFlags().get("BVBountyCampID") == this.m.BountyID && target.getFlags().has("BVBountyCamp"))))
			{
				this.m.Target = this.WeakTableRef(target);
				target.getSprite("selection").Visible = true;
				target.setOnCombatWithPlayerCallback(this.onTargetAttacked.bindenv(this));
			}
		}
		::logInfo("[Battle Valkyries] Bounty contract deserialized: version=" + version + ", target=" + this.m.TargetEntityID + ", restored=" + (this.m.Target != null));
	}
});
