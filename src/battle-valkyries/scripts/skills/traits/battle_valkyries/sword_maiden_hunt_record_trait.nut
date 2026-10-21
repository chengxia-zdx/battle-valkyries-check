this.sword_maiden_hunt_record_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		TotalPoints = 0,
		DirectKills = 0,
		AssistConvictions = 0,
		KillCounts = null,
		PendingPoints = 0,
		PendingDirectKills = 0,
		PendingAssistConvictions = 0,
		PendingKillCounts = null,
		CombatCredits = null
	},

	function makeCounts()
	{
		local ret = { other = 0, champion_bonus = 0 };
		foreach (entry in ::$bvvar{namespace}.SwordMaidenGoblinTypes) ret[entry.Key] <- 0;
		return ret;
	}

	function create()
	{
		this.character_trait.create();
		this.m.ID = ::$bvvar{namespace}.SwordMaidenHuntTraitID;
		this.m.Name = "$bv{hunt.sword_maiden.record.name}";
		this.m.Description = "$bv{hunt.sword_maiden.record.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/sword_maiden_trait_icon.png";
		this.m.IsHidden = true;
		this.m.IsSerialized = true;
		this.m.KillCounts = this.makeCounts();
		this.m.PendingKillCounts = this.makeCounts();
		this.m.CombatCredits = {};
	}

	function getTotalPoints() { return this.m.TotalPoints; }
	function getPendingPoints() { return this.m.PendingPoints; }
	function getDirectKills() { return this.m.DirectKills; }
	function getAssistConvictions() { return this.m.AssistConvictions; }
	function getKillCount( _key ) { return _key in this.m.KillCounts ? this.m.KillCounts[_key] : 0; }
	function getRank() { return ::$bvvar{namespace}.getSwordMaidenHuntRank(this.m.TotalPoints); }

	function getTargetToken( _target )
	{
		try { return "entity-" + _target.getID().tostring(); } catch (e) { return "object-" + _target.tostring(); }
	}

	function recordGoblinCredit( _target, _isDirect )
	{
		local info = ::$bvvar{namespace}.getSwordMaidenGoblinInfo(_target);
		if (info == null) return 0;
		local token = this.getTargetToken(_target);
		local amount = _isDirect ? info.Points : this.Math.floor((info.Points + 1) / 2);
		if (token in this.m.CombatCredits)
		{
			local previous = this.m.CombatCredits[token];
			if (!_isDirect || previous.Direct) return 0;
			local delta = this.Math.max(0, amount - previous.Points);
			this.m.PendingPoints += delta;
			this.m.PendingDirectKills++;
			this.m.PendingAssistConvictions = this.Math.max(0, this.m.PendingAssistConvictions - 1);
			previous.Direct = true;
			previous.Points = amount;
			return delta;
		}
		this.m.CombatCredits[token] <- { Direct = _isDirect, Points = amount };
		this.m.PendingPoints += amount;
		if (_isDirect) this.m.PendingDirectKills++; else this.m.PendingAssistConvictions++;
		if (!(info.Key in this.m.PendingKillCounts)) this.m.PendingKillCounts[info.Key] <- 0;
		this.m.PendingKillCounts[info.Key]++;
		if (info.IsChampion) this.m.PendingKillCounts.champion_bonus++;
		return amount;
	}

	function recordMarkedAssist( _target )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return 0;
		try { if (!actor.isPlacedOnMap()) return 0; } catch (e) { return 0; }
		return this.recordGoblinCredit(_target, false);
	}

	function onTargetKilled( _target, _skill )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null || _target == null || _target.isAlliedWith(actor) || ::$bvvar{namespace}.isActorDeadOrDying(actor)) return;
		try { if (!actor.isPlacedOnMap()) return; } catch (e) { return; }
		this.recordGoblinCredit(_target, true);
	}

	function commitPendingProgress()
	{
		local added = this.m.PendingPoints;
		if (added <= 0)
		{
			this.m.CombatCredits = {};
			return 0;
		}
		this.m.TotalPoints += this.m.PendingPoints;
		this.m.DirectKills += this.m.PendingDirectKills;
		this.m.AssistConvictions += this.m.PendingAssistConvictions;
		foreach (key, count in this.m.PendingKillCounts)
		{
			if (!(key in this.m.KillCounts)) this.m.KillCounts[key] <- 0;
			this.m.KillCounts[key] += count;
		}
		this.m.PendingPoints = 0;
		this.m.PendingDirectKills = 0;
		this.m.PendingAssistConvictions = 0;
		this.m.PendingKillCounts = this.makeCounts();
		this.m.CombatCredits = {};
		return added;
	}

	function onUpdate( _properties )
	{
		local rank = this.getRank();
		_properties.Hitpoints += rank * 2;
		_properties.Stamina += rank * 2;
		_properties.MeleeSkill += rank;
		_properties.MeleeDefense += rank;
		_properties.DamageTotalMult *= 1.0 + rank * 0.01;
	}

	function onCombatStarted() { this.m.CombatCredits = {}; }

	function writeCounts( _out, _counts )
	{
		foreach (entry in ::$bvvar{namespace}.SwordMaidenGoblinTypes) _out.writeU32(entry.Key in _counts ? _counts[entry.Key] : 0);
		_out.writeU32("other" in _counts ? _counts.other : 0);
		_out.writeU32("champion_bonus" in _counts ? _counts.champion_bonus : 0);
	}

	function readCounts( _in )
	{
		local ret = this.makeCounts();
		foreach (entry in ::$bvvar{namespace}.SwordMaidenGoblinTypes) ret[entry.Key] = _in.readU32();
		ret.other = _in.readU32();
		ret.champion_bonus = _in.readU32();
		return ret;
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU8(1);
		_out.writeU32(this.m.TotalPoints);
		_out.writeU32(this.m.DirectKills);
		_out.writeU32(this.m.AssistConvictions);
		this.writeCounts(_out, this.m.KillCounts);
		_out.writeU32(this.m.PendingPoints);
		_out.writeU32(this.m.PendingDirectKills);
		_out.writeU32(this.m.PendingAssistConvictions);
		this.writeCounts(_out, this.m.PendingKillCounts);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		local version = _in.readU8();
		this.m.TotalPoints = _in.readU32();
		this.m.DirectKills = _in.readU32();
		this.m.AssistConvictions = _in.readU32();
		this.m.KillCounts = this.readCounts(_in);
		this.m.PendingPoints = _in.readU32();
		this.m.PendingDirectKills = _in.readU32();
		this.m.PendingAssistConvictions = _in.readU32();
		this.m.PendingKillCounts = this.readCounts(_in);
		this.m.CombatCredits = {};
	}
});
