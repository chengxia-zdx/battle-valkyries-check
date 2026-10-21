::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.getLocalCombatProperties = @(__original) function(pos, ignoreNoEnemies = false)
	{
		local result = __original(pos, ignoreNoEnemies);
		if (result != null) foreach (party in result.Parties)
			if (party != null && party.isLocation() && party.getFlags().get("BVChapterID") == "shu_granary")
			{ result.TerrainTemplate = "tactical.plains"; break; }
		return result;
	};
});
