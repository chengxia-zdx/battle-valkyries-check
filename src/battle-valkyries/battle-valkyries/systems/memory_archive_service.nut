::$bvvar{namespace}.getMemoryArchiveFlag <- function( _suffix )
{
	return ::$bvvar{namespace}.MemoryArchivePrefix + _suffix;
};

::$bvvar{namespace}.getMemoryWorldInt <- function( _suffix, _fallback = 0 )
{
	if (::World == null || ::World.Flags == null) return _fallback;
	local key = ::$bvvar{namespace}.getMemoryArchiveFlag(_suffix);
	if (!::World.Flags.has(key)) return _fallback;
	local value = ::World.Flags.get(key);
	return typeof value == "integer" || typeof value == "float" ? value.tointeger() : _fallback;
};

::$bvvar{namespace}.getMemoryWorldString <- function( _suffix, _fallback = "" )
{
	if (::World == null || ::World.Flags == null) return _fallback;
	local key = ::$bvvar{namespace}.getMemoryArchiveFlag(_suffix);
	if (!::World.Flags.has(key)) return _fallback;
	local value = ::World.Flags.get(key);
	return typeof value == "string" ? value : _fallback;
};

::$bvvar{namespace}.setMemoryWorldValue <- function( _suffix, _value )
{
	if (::World == null || ::World.Flags == null) return false;
	::World.Flags.set(::$bvvar{namespace}.getMemoryArchiveFlag(_suffix), _value);
	return true;
};

::$bvvar{namespace}.removeMemoryWorldValue <- function( _suffix )
{
	if (::World == null || ::World.Flags == null) return;
	local key = ::$bvvar{namespace}.getMemoryArchiveFlag(_suffix);
	if (::World.Flags.has(key)) ::World.Flags.remove(key);
};

::$bvvar{namespace}.getMemoryRecordProcessedFlag <- function( _recordID )
{
	return "processed." + _recordID;
};

::$bvvar{namespace}.ensureMemoryRecordID <- function( _actor )
{
	if (_actor == null || _actor.getFlags() == null) return null;
	local flags = _actor.getFlags();
	if (flags.has(::$bvvar{namespace}.MemoryRecordIDFlag))
	{
		local existing = flags.get(::$bvvar{namespace}.MemoryRecordIDFlag);
		if (typeof existing == "string" && existing != "") return existing;
	}

	local nextID = ::$bvvar{namespace}.getMemoryWorldInt("next_record_id", 0) + 1;
	::$bvvar{namespace}.setMemoryWorldValue("next_record_id", nextID);
	local recordID = "memory_" + nextID;
	flags.set(::$bvvar{namespace}.MemoryRecordIDFlag, recordID);
	return recordID;
};

::$bvvar{namespace}.isMemoryArchiveActorDead <- function( _actor )
{
	if (_actor == null) return true;
	try { if (!_actor.isAlive()) return true; } catch (e) { return true; }
	try { if (_actor.isDying()) return true; } catch (e) { try { if (_actor.m.IsDying) return true; } catch (ignored) {} }
	try { if (_actor.getHitpoints() <= 0) return true; } catch (e) { return true; }
	return false;
};

::$bvvar{namespace}.isMemoryArchiveCombatActive <- function()
{
	try { return ::Tactical != null && "State" in ::Tactical && ::Tactical.State != null; } catch (e) {}
	return false;
};

::$bvvar{namespace}.getMemoryArchiveEligibilityCode <- function( _actor )
{
	if (_actor == null) return "actor_not_found";
	if (::$bvvar{namespace}.isMemoryArchiveCombatActive()) return "in_combat";
	if (::$bvvar{namespace}.isMemoryArchiveActorDead(_actor)) return "dead";
	try { if (_actor.getBackground() == null) return "not_human"; } catch (e) { return "not_human"; }
	if (::$bvvar{namespace}.getActorValkyrieID(_actor) != null) return "valkyrie";
	if ("getActorAmphoreusHeroID" in ::$bvvar{namespace})
	{
		try { if (::$bvvar{namespace}.getActorAmphoreusHeroID(_actor) != null) return "amphoreus_hero"; } catch (e) {}
	}

	local flags = null;
	try { flags = _actor.getFlags(); } catch (e) {}
	if (flags == null) return "protected";
	if (flags.has("IsPlayerCharacter") && flags.get("IsPlayerCharacter") == true) return "origin_protagonist";
	foreach (protectedFlag in ["IsSummoned", "IsTemporary", "IsContractCharacter", "IsGuest", "IsProtected"])
	{
		if (flags.has(protectedFlag) && flags.get(protectedFlag) == true) return "protected";
	}
	try { if (_actor.isGuest()) return "protected"; } catch (e) {}
	try { if (::$bvvar{namespace}.isValkyrieTemporaryPlayerControlActiveFor(_actor)) return "protected"; } catch (e) {}

	local recordID = ::$bvvar{namespace}.ensureMemoryRecordID(_actor);
	if (recordID == null) return "protected";
	if (::$bvvar{namespace}.getMemoryWorldInt(::$bvvar{namespace}.getMemoryRecordProcessedFlag(recordID), 0) != 0) return "already_archived";
	return null;
};

::$bvvar{namespace}.getMemoryAttributeTier <- function( _value, _thresholds )
{
	local tier = 0;
	for (local i = 0; i < _thresholds.len(); i++)
	{
		if (_value >= _thresholds[i]) tier = i + 1;
	}
	return tier;
};

::$bvvar{namespace}.evaluateMemoryArchiveActor <- function( _actor )
{
	if (_actor == null) return null;
	local properties = null;
	try { properties = _actor.getBaseProperties(); } catch (e) {}
	if (properties == null) return null;

	local stats = [];
	local rewards = { Fragment = 0, Crystal = 0, Eternal = 0, Emblem = 0 };
	local eliteCount = 0;
	local legendaryCount = 0;
	foreach (attribute in ::$bvvar{namespace}.MemoryArchiveAttributes)
	{
		local value = 0;
		try { value = properties[attribute.Key].tointeger(); } catch (e) {}
		local tier = ::$bvvar{namespace}.getMemoryAttributeTier(value, attribute.Thresholds);
		if (tier >= 1) rewards.Fragment += 2;
		if (tier >= 2) rewards.Crystal += 2;
		if (tier >= 3) rewards.Eternal += 2;
		if (tier >= 2) eliteCount++;
		if (tier >= 3) legendaryCount++;
		stats.push({
			Key = attribute.Key,
			Label = attribute.Label,
			Icon = attribute.Icon,
			Value = value,
			Tier = tier,
			NextThreshold = tier >= attribute.Thresholds.len() ? 0 : attribute.Thresholds[tier]
		});
	}

	if (eliteCount >= 2) rewards.Crystal += 2;
	if (eliteCount >= 3) rewards.Eternal++;
	if (eliteCount >= 4) rewards.Emblem++;
	if (eliteCount >= 5) rewards.Emblem++;
	if (legendaryCount >= 2) rewards.Eternal += 2;
	if (legendaryCount >= 3) rewards.Emblem++;
	if (legendaryCount >= 4) rewards.Emblem++;

	return {
		Stats = stats,
		Rewards = rewards,
		EliteCount = eliteCount,
		LegendaryCount = legendaryCount,
		Rank = ::$bvvar{namespace}.getMemoryArchiveRank(eliteCount, legendaryCount)
	};
};

::$bvvar{namespace}.getMemoryActorBackgroundName <- function( _actor )
{
	try { return _actor.getBackground().getNameOnly(); } catch (e) {}
	try { return _actor.getBackground().getName(); } catch (e) {}
	return "$bv{memory.biography.unknown_background}";
};

::$bvvar{namespace}.getMemoryActorLivePortrait <- function( _actor )
{
	try { return _actor.getImagePath(); } catch (e) {}
	return "";
};

::$bvvar{namespace}.getMemoryActorArchivePortrait <- function( _actor )
{
	try { return _actor.getBackground().getIcon(); } catch (e) {}
	return "";
};

::$bvvar{namespace}.makeMemoryArchiveSnapshot <- function( _actor, _recordID, _evaluation )
{
	local actorName = "";
	try { actorName = _actor.getNameOnly(); } catch (e) { try { actorName = _actor.getName(); } catch (ignored) {} }
	local level = 1;
	local companyDays = 0;
	local archiveDay = 0;
	try { level = _actor.getLevel(); } catch (e) {}
	try { companyDays = _actor.getDaysWithCompany(); } catch (e) {}
	try { archiveDay = ::World.getTime().Days; } catch (e) {}
	return {
		Version = ::$bvvar{namespace}.MemoryArchiveVersion,
		RecordID = _recordID,
		Name = actorName,
		Background = ::$bvvar{namespace}.getMemoryActorBackgroundName(_actor),
		Portrait = ::$bvvar{namespace}.getMemoryActorArchivePortrait(_actor),
		Level = level,
		CompanyDays = companyDays,
		ArchiveDay = archiveDay,
		RankKey = _evaluation.Rank.Key,
		RankTitle = _evaluation.Rank.Title,
		EliteCount = _evaluation.EliteCount,
		LegendaryCount = _evaluation.LegendaryCount,
		Stats = _evaluation.Stats,
		Rewards = _evaluation.Rewards
	};
};

::$bvvar{namespace}.writeMemoryArchiveRecord <- function( _index, _record )
{
	local prefix = "record." + _index + ".";
	foreach (field in ["Version", "RecordID", "Name", "Background", "Portrait", "Level", "CompanyDays", "ArchiveDay", "RankKey", "RankTitle", "EliteCount", "LegendaryCount"])
	{
		::$bvvar{namespace}.setMemoryWorldValue(prefix + field, _record[field]);
	}
	foreach (stat in _record.Stats)
	{
		::$bvvar{namespace}.setMemoryWorldValue(prefix + "Stat." + stat.Key + ".Value", stat.Value);
		::$bvvar{namespace}.setMemoryWorldValue(prefix + "Stat." + stat.Key + ".Tier", stat.Tier);
	}
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		::$bvvar{namespace}.setMemoryWorldValue(prefix + "Reward." + resource.Key, _record.Rewards[resource.Key]);
	}
};

::$bvvar{namespace}.removeMemoryArchiveRecord <- function( _index )
{
	local prefix = "record." + _index + ".";
	foreach (field in ["Version", "RecordID", "Name", "Background", "Portrait", "Level", "CompanyDays", "ArchiveDay", "RankKey", "RankTitle", "EliteCount", "LegendaryCount"])
	{
		::$bvvar{namespace}.removeMemoryWorldValue(prefix + field);
	}
	foreach (attribute in ::$bvvar{namespace}.MemoryArchiveAttributes)
	{
		::$bvvar{namespace}.removeMemoryWorldValue(prefix + "Stat." + attribute.Key + ".Value");
		::$bvvar{namespace}.removeMemoryWorldValue(prefix + "Stat." + attribute.Key + ".Tier");
	}
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		::$bvvar{namespace}.removeMemoryWorldValue(prefix + "Reward." + resource.Key);
	}
};

::$bvvar{namespace}.readMemoryArchiveRecord <- function( _index )
{
	local prefix = "record." + _index + ".";
	local recordID = ::$bvvar{namespace}.getMemoryWorldString(prefix + "RecordID", "");
	if (recordID == "") return null;
	local version = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "Version", 0);
	if (version != ::$bvvar{namespace}.MemoryArchiveVersion)
	{
		try { ::logWarning("[Battle Valkyries] Skipping unsupported memory archive record version " + version + " at index " + _index); } catch (e) {}
		return null;
	}

	local stats = [];
	foreach (attribute in ::$bvvar{namespace}.MemoryArchiveAttributes)
	{
		stats.push({
			Key = attribute.Key,
			Label = attribute.Label,
			Icon = attribute.Icon,
			Value = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "Stat." + attribute.Key + ".Value", 0),
			Tier = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "Stat." + attribute.Key + ".Tier", 0),
			NextThreshold = 0
		});
	}
	local rewards = {};
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		rewards[resource.Key] <- ::$bvvar{namespace}.getMemoryWorldInt(prefix + "Reward." + resource.Key, 0);
	}
	return {
		Version = version,
		RecordID = recordID,
		Name = ::$bvvar{namespace}.getMemoryWorldString(prefix + "Name", ""),
		Background = ::$bvvar{namespace}.getMemoryWorldString(prefix + "Background", "$bv{memory.biography.unknown_background}"),
		Portrait = ::$bvvar{namespace}.getMemoryWorldString(prefix + "Portrait", ""),
		Level = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "Level", 1),
		CompanyDays = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "CompanyDays", 0),
		ArchiveDay = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "ArchiveDay", 0),
		RankKey = ::$bvvar{namespace}.getMemoryWorldString(prefix + "RankKey", "ordinary"),
		RankTitle = ::$bvvar{namespace}.getMemoryWorldString(prefix + "RankTitle", "$bv{memory.rank.ordinary}"),
		EliteCount = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "EliteCount", 0),
		LegendaryCount = ::$bvvar{namespace}.getMemoryWorldInt(prefix + "LegendaryCount", 0),
		Stats = stats,
		Rewards = rewards
	};
};

::$bvvar{namespace}.getMemoryArchiveBalancesDTO <- function()
{
	local result = [];
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		result.push({
			Key = resource.Key,
			Label = resource.Label,
			Amount = ::$bvvar{namespace}.getMemoryWorldInt("balance." + resource.Key, 0)
		});
	}
	return result;
};

::$bvvar{namespace}.getMemoryArchiveCandidateDTO <- function( _actor )
{
	local evaluation = ::$bvvar{namespace}.evaluateMemoryArchiveActor(_actor);
	if (evaluation == null) return null;
	local recordID = ::$bvvar{namespace}.ensureMemoryRecordID(_actor);
	local snapshot = ::$bvvar{namespace}.makeMemoryArchiveSnapshot(_actor, recordID, evaluation);
	local actorID = 0;
	try { actorID = _actor.getID(); } catch (e) {}
	return {
		ActorID = actorID,
		RecordID = recordID,
		Name = snapshot.Name,
		Background = snapshot.Background,
		Portrait = ::$bvvar{namespace}.getMemoryActorLivePortrait(_actor),
		Level = snapshot.Level,
		CompanyDays = snapshot.CompanyDays,
		RankKey = snapshot.RankKey,
		RankTitle = snapshot.RankTitle,
		EliteCount = snapshot.EliteCount,
		LegendaryCount = snapshot.LegendaryCount,
		Stats = snapshot.Stats,
		Rewards = snapshot.Rewards,
		CanArchive = true
	};
};

::$bvvar{namespace}.getMemoryArchiveHubDTO <- function()
{
	local candidates = [];
	if (::World != null && ::World.getPlayerRoster() != null)
	{
		foreach (actor in ::World.getPlayerRoster().getAll())
		{
			if (actor == null) continue;
			if (::$bvvar{namespace}.getMemoryArchiveEligibilityCode(actor) != null) continue;
			local dto = ::$bvvar{namespace}.getMemoryArchiveCandidateDTO(actor);
			if (dto != null) candidates.push(dto);
		}
	}

	local records = [];
	local count = ::$bvvar{namespace}.getMemoryWorldInt("record_count", 0);
	for (local i = count; i >= 1; i--)
	{
		local record = ::$bvvar{namespace}.readMemoryArchiveRecord(i);
		if (record != null) records.push(record);
	}
	return {
		Resources = ::$bvvar{namespace}.getMemoryArchiveBalancesDTO(),
		Candidates = candidates,
		Records = records
	};
};

::$bvvar{namespace}.findMemoryArchiveActorByID <- function( _actorID )
{
	if (::World == null || ::World.getPlayerRoster() == null) return null;
	local target = "" + _actorID;
	foreach (actor in ::World.getPlayerRoster().getAll())
	{
		if (actor == null) continue;
		try { if (("" + actor.getID()) == target) return actor; } catch (e) {}
	}
	return null;
};

::$bvvar{namespace}.getMemoryArchiveErrorText <- function( _code )
{
	local texts = {
		actor_not_found = "$bv{memory.error.actor_not_found}",
		in_combat = "$bv{memory.error.in_combat}",
		dead = "$bv{memory.error.dead}",
		not_human = "$bv{memory.error.protected}",
		valkyrie = "$bv{memory.error.special_identity}",
		amphoreus_hero = "$bv{memory.error.special_identity}",
		origin_protagonist = "$bv{memory.error.protected}",
		protected = "$bv{memory.error.protected}",
		already_archived = "$bv{memory.error.already_archived}",
		world_unavailable = "$bv{memory.error.world_unavailable}",
		stash_unavailable = "$bv{memory.error.stash_unavailable}",
		stash_full = "$bv{memory.error.stash_full}",
		stash_transfer_failed = "$bv{memory.error.stash_transfer_failed}",
		archive_failed = "$bv{memory.error.archive_failed}"
	};
	return _code in texts ? texts[_code] : texts.archive_failed;
};

::$bvvar{namespace}.archiveOrdinaryBrotherMemory <- function( _actorID )
{
	if (::World == null || ::World.Flags == null || ::World.getPlayerRoster() == null)
	{
		return { Success = false, Code = "world_unavailable", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("world_unavailable") };
	}
	local actor = ::$bvvar{namespace}.findMemoryArchiveActorByID(_actorID);
	local eligibility = ::$bvvar{namespace}.getMemoryArchiveEligibilityCode(actor);
	if (eligibility != null)
	{
		return { Success = false, Code = eligibility, Message = ::$bvvar{namespace}.getMemoryArchiveErrorText(eligibility) };
	}
	if (::World.Assets == null || ::World.Assets.getStash() == null)
	{
		return { Success = false, Code = "stash_unavailable", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("stash_unavailable") };
	}

	local stash = ::World.Assets.getStash();
	local equipment = actor.getItems().getAllItems();
	if (!stash.isResizable() && stash.getNumberOfEmptySlots() < equipment.len())
	{
		return { Success = false, Code = "stash_full", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("stash_full") };
	}

	local recordID = ::$bvvar{namespace}.ensureMemoryRecordID(actor);
	local evaluation = ::$bvvar{namespace}.evaluateMemoryArchiveActor(actor);
	if (recordID == null || evaluation == null)
	{
		return { Success = false, Code = "archive_failed", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("archive_failed") };
	}
	local snapshot = ::$bvvar{namespace}.makeMemoryArchiveSnapshot(actor, recordID, evaluation);
	local processedFlag = ::$bvvar{namespace}.getMemoryRecordProcessedFlag(recordID);
	if (::$bvvar{namespace}.getMemoryWorldInt(processedFlag, 0) != 0)
	{
		return { Success = false, Code = "already_archived", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("already_archived") };
	}

	try
	{
		actor.getItems().transferToStash(stash);
		foreach (item in equipment)
		{
			if (item != null && stash.getItemByInstanceID(item.getInstanceID()) == null)
			{
				throw "equipment transfer verification failed";
			}
		}
	}
	catch (e)
	{
		try { ::logError("[Battle Valkyries] Memory archive equipment transfer failed: " + e); } catch (ignored) {}
		return { Success = false, Code = "stash_transfer_failed", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("stash_transfer_failed") };
	}

	local oldCount = ::$bvvar{namespace}.getMemoryWorldInt("record_count", 0);
	local newIndex = oldCount + 1;
	local oldBalances = {};
	foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
	{
		oldBalances[resource.Key] <- ::$bvvar{namespace}.getMemoryWorldInt("balance." + resource.Key, 0);
	}

	try
	{
		::$bvvar{namespace}.writeMemoryArchiveRecord(newIndex, snapshot);
		::$bvvar{namespace}.setMemoryWorldValue("record_count", newIndex);
		::$bvvar{namespace}.setMemoryWorldValue(processedFlag, 1);
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			::$bvvar{namespace}.setMemoryWorldValue("balance." + resource.Key, oldBalances[resource.Key] + snapshot.Rewards[resource.Key]);
		}
		::World.getPlayerRoster().remove(actor);
		if (::$bvvar{namespace}.findMemoryArchiveActorByID(_actorID) != null) throw "roster removal verification failed";
	}
	catch (e)
	{
		::$bvvar{namespace}.removeMemoryArchiveRecord(newIndex);
		::$bvvar{namespace}.setMemoryWorldValue("record_count", oldCount);
		::$bvvar{namespace}.removeMemoryWorldValue(processedFlag);
		foreach (resource in ::$bvvar{namespace}.MemoryArchiveResources)
		{
			::$bvvar{namespace}.setMemoryWorldValue("balance." + resource.Key, oldBalances[resource.Key]);
		}
		try { ::logError("[Battle Valkyries] Memory archive transaction failed: " + e); } catch (ignored) {}
		return { Success = false, Code = "archive_failed", Message = ::$bvvar{namespace}.getMemoryArchiveErrorText("archive_failed") };
	}

	try
	{
		if (::World.State != null && ::World.State.getPlayer() != null) ::World.State.getPlayer().calculateModifiers();
		if (::World.State != null) ::World.State.updateTopbarAssets();
	}
	catch (e) {}
	return {
		Success = true,
		Code = "success",
		Message = "$bv{memory.result.success}",
		Name = snapshot.Name,
		RankTitle = snapshot.RankTitle,
		Rewards = snapshot.Rewards
	};
};
