this.saber_bond_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { Bond = 0, PendingStages = [], TriggeredStages = [], ChallengeSpawnedStages = [], ClaimedStages = [], NoticeStages = [] },
	function create()
	{
		this.character_trait.create();
		this.m.ID = "$bvvar{modId}.trait.saber_bond";
		this.m.Name = "$bv{valkyrie.saber.bond.name}";
		this.m.Description = "$bv{valkyrie.saber.bond.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/saber_bond_trait.png";
		this.m.IsSerialized = true;
		this.m.Bond = 0;
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"]) this.m[key] = [];
	}
	function getBond() { return this.m.Bond; }
	function hasStage(list, stage) { return list.find(stage) != null; }
	function addStage(list, stage) { if (this.hasStage(list, stage)) return false; list.push(stage); return true; }
	function removeStage(list, stage) { local i = list.find(stage); if (i == null) return false; list.remove(i); return true; }
	function hasTriggeredStage(stage) { return this.hasStage(this.m.TriggeredStages, stage); }
	function hasChallengeSpawnedStage(stage) { return this.hasStage(this.m.ChallengeSpawnedStages, stage); }
	function hasPendingStageValue(stage) { return this.hasStage(this.m.PendingStages, stage); }
	function hasPendingStage() { return this.m.PendingStages.len() > 0; }
	function getNextPendingStage() { return this.hasPendingStage() ? this.m.PendingStages[0] : 0; }
	function getNoticeStage() { return this.m.NoticeStages.len() > 0 ? this.m.NoticeStages[0] : 0; }
	function hasClaimedStage(stage) { return this.hasStage(this.m.ClaimedStages, stage); }
	function acknowledgeNotice(stage) { return this.removeStage(this.m.NoticeStages, stage); }
	function queueReachedStages()
	{
		foreach (stage in [20, 40, 60, 80, 100])
		{
			if (this.hasTriggeredStage(stage)) continue;
			if (this.m.Bond >= stage && !this.hasChallengeSpawnedStage(stage)) this.addStage(this.m.PendingStages, stage);
			return; // The lowest unresolved stage owns the queue, even across multiple thresholds.
		}
	}
	function addBond(amount)
	{
		if (amount <= 0) return 0;
		local old = this.m.Bond;
		this.m.Bond = this.Math.min(100, old + amount);
		this.queueReachedStages();
		return this.m.Bond - old;
	}
	function startChallengeStage(stage)
	{
		if (stage != this.getNextPendingStage() || stage == 0 || this.hasTriggeredStage(stage)) return false;
		this.removeStage(this.m.PendingStages, stage);
		this.addStage(this.m.ChallengeSpawnedStages, stage);
		return true;
	}
	function completeChallengeStage(stage)
	{
		if (!this.hasChallengeSpawnedStage(stage) || this.hasTriggeredStage(stage)) return false;
		this.removeStage(this.m.ChallengeSpawnedStages, stage);
		this.addStage(this.m.TriggeredStages, stage);
		this.addStage(this.m.NoticeStages, stage);
		this.queueReachedStages();
		// Completion is durable entitlement. Delivery may be retried after a full stash or load.
		return true;
	}
	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{valkyrie.saber.bond.value}" + this.m.Bond + " / 100" }
		];
		foreach (stage in ::$bvvar{namespace}.SaberBondStages)
		{
			local state = this.hasTriggeredStage(stage.Value) ? (this.hasClaimedStage(stage.Value) ? "$bv{valkyrie.saber.bond.done}" : "$bv{valkyrie.saber.bond.unclaimed}")
				: (this.hasChallengeSpawnedStage(stage.Value) ? "$bv{valkyrie.saber.bond.challenge}" : "$bv{valkyrie.saber.bond.locked}");
			ret.push({ id = 10 + stage.Value, type = "text", icon = "ui/icons/special.png", text = stage.Value + "  " + stage.Name + " — " + state });
		}
		return ret;
	}
	function onSerialize(out)
	{
		this.skill.onSerialize(out); out.writeU8(1); out.writeU16(this.m.Bond);
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"])
		{
			out.writeU8(this.m[key].len()); foreach (stage in this.m[key]) out.writeU8(stage);
		}
	}
	function onDeserialize(input)
	{
		this.skill.onDeserialize(input);
		local version = input.readU8();
		if (version != 1) throw "[Battle Valkyries] Unsupported Saber bond schema: " + version;
		this.m.Bond = this.Math.max(0, this.Math.min(100, input.readU16()));
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"])
		{
			this.m[key] = []; local count = input.readU8();
			for (local i = 0; i < count; ++i)
			{
				local stage = input.readU8();
				if ([20, 40, 60, 80, 100].find(stage) != null) this.addStage(this.m[key], stage);
			}
		}
		this.m.PendingStages = [];
		this.queueReachedStages();
	}
});
