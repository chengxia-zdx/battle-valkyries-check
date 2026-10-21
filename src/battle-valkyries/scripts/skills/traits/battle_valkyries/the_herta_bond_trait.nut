this.the_herta_bond_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { Bond = 0, PendingStages = [], TriggeredStages = [], ChallengeSpawnedStages = [], ClaimedStages = [], NoticeStages = [], Married = false, RingClaimed = false, ArmorClaimed = false, HelmetClaimed = false },
	function create()
	{
		this.character_trait.create();
		this.m.ID = "$bvvar{modId}.trait.the_herta_bond";
		this.m.Name = "$bv{valkyrie.the_herta.bond.name}";
		this.m.Description = "$bv{valkyrie.the_herta.bond.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/the_herta_bond_trait.png";
		this.m.IsSerialized = true;
		this.m.Bond = 0; this.m.Married = false; this.m.RingClaimed = false; this.m.ArmorClaimed = false; this.m.HelmetClaimed = false;
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
	function hasClaimedStage(stage)
	{
		return this.hasStage(this.m.ClaimedStages, stage);
	}
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
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{valkyrie.the_herta.bond.value}" + this.m.Bond + " / 100" }
		];
		foreach (stage in ::$bvvar{namespace}.HertaBondStages)
		{
			local state = this.hasTriggeredStage(stage.Value) ? (this.hasClaimedStage(stage.Value) ? "$bv{valkyrie.the_herta.bond.done}" : "$bv{valkyrie.the_herta.bond.unclaimed}")
				: (this.hasChallengeSpawnedStage(stage.Value) ? "$bv{valkyrie.the_herta.bond.challenge}" : "$bv{valkyrie.the_herta.bond.locked}");
			ret.push({ id = 10 + stage.Value, type = "text", icon = "ui/icons/special.png", text = stage.Value + "  " + stage.Name + " — " + state });
		}
		return ret;
	}
	function onSerialize(out)
	{
		this.skill.onSerialize(out); out.writeU8(2); out.writeBool(this.m.Married); out.writeBool(this.m.RingClaimed); out.writeU16(this.m.Bond);
		foreach (key in ["PendingStages", "TriggeredStages", "ChallengeSpawnedStages", "ClaimedStages", "NoticeStages"])
		{
			out.writeU8(this.m[key].len()); foreach (stage in this.m[key]) out.writeU8(stage);
		}
		out.writeBool(this.m.ArmorClaimed); out.writeBool(this.m.HelmetClaimed);
	}
	function onDeserialize(input)
	{
		this.skill.onDeserialize(input);
		local version = input.readU8();
		if (version != 1 && version != 2) throw "[Battle Valkyries] Unsupported Herta bond schema: " + version;
		this.m.Married = input.readBool(); this.m.RingClaimed = input.readBool();
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
		// Retain legacy receipts for starting-set migration; do not infer new perk receipts from these lists.
		this.m.ArmorClaimed = version >= 2 ? input.readBool() : false;
		this.m.HelmetClaimed = version >= 2 ? input.readBool() : false;
		foreach (stage in [40,80]) if (this.hasTriggeredStage(stage) && !this.hasClaimedStage(stage)) this.addStage(this.m.NoticeStages,stage);
		this.m.PendingStages = [];
		this.queueReachedStages();
	}
});
