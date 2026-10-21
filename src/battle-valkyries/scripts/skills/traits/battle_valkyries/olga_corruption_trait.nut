this.olga_corruption_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { Corruption = 0, PrologueSeen = false, PendingStages = [], TriggeredStages = [], ChallengeSpawnedStages = [], ClaimedStages = [], NoticeStages = [] },
	function create()
	{
		this.character_trait.create();
		this.m.ID = "$bvvar{modId}.trait.olga_corruption";
		this.m.Name = "$bv{olga.corruption.name}";
		this.m.Description = "$bv{olga.corruption.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/olga_trait_icon.png";
		this.m.IsSerialized = true;
		this.m.Corruption = 0; this.m.PrologueSeen = false;
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"]) this.m[key] = [];
	}
	// Compatibility getter for the shared narrative DTO, not the bond consumable registry.
	function getCorruption() { return this.m.Corruption; }
	function getBond() { return this.m.Corruption; }
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
			if (this.hasTriggeredStage(stage)) { if (this.hasClaimedStage(stage)) continue; return; }
			if (this.m.Corruption >= stage && !this.hasChallengeSpawnedStage(stage)) this.addStage(this.m.PendingStages, stage);
			return; // The lowest unresolved stage owns the queue, even across multiple thresholds.
		}
	}
	function addCorruption(amount)
	{
		if (typeof amount != "integer" || amount <= 0) return 0;
		local old = this.m.Corruption;
		this.m.Corruption = this.Math.min(100, old + amount);
		this.queueReachedStages();
		return this.m.Corruption - old;
	}
	function startChallengeStage(stage)
	{
		if (!this.m.PrologueSeen || stage != this.getNextPendingStage() || stage == 0 || this.hasTriggeredStage(stage)) return false;
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
		// Completion is durable entitlement. Skill synchronization may be retried after load.
		return true;
	}
	function migrateLegacyStage(stage)
	{
		this.m.Corruption = stage * 20;
		this.m.PrologueSeen = stage > 0;
		for (local i = 1; i <= stage; ++i)
		{
			this.addStage(this.m.TriggeredStages, i * 20);
			this.addStage(this.m.ClaimedStages, i * 20);
		}
	}
	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{olga.corruption.value}" + this.m.Corruption + " / 100" }
		];
		foreach (stage in ::$bvvar{namespace}.OlgaCorruptionStages)
		{
			local state = this.hasTriggeredStage(stage.Value) ? (this.hasClaimedStage(stage.Value) ? "$bv{olga.corruption.done}" : "$bv{olga.corruption.unclaimed}")
				: (this.hasChallengeSpawnedStage(stage.Value) ? "$bv{olga.corruption.challenge}" : (this.hasPendingStageValue(stage.Value) ? "$bv{olga.corruption.pending}" : "$bv{olga.corruption.locked}"));
			ret.push({ id = 10 + stage.Value, type = "text", icon = "ui/icons/special.png", text = stage.Value + "  " + stage.Name + " — " + state });
		}
		return ret;
	}
	function onSerialize(out)
	{
		this.skill.onSerialize(out); out.writeU8(1); out.writeU8(this.m.Corruption); out.writeBool(this.m.PrologueSeen);
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"])
		{
			out.writeU8(this.m[key].len()); foreach (stage in this.m[key]) out.writeU8(stage);
		}
	}
	function onDeserialize(input)
	{
		this.skill.onDeserialize(input);
		local version = input.readU8();
		if (version != 1) throw "[Battle Valkyries] Unsupported Olga corruption schema: " + version;
		this.m.Corruption = this.Math.max(0, this.Math.min(100, input.readU8()));
		this.m.PrologueSeen = input.readBool();
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
