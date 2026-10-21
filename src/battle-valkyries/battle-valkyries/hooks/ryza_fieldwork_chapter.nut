// Restrict changes to this chapter's actual battle, including retreat loot.
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
 q.getLocalCombatProperties = @(__original) function(pos, ignoreNoEnemies = false) {
  local result = __original(pos, ignoreNoEnemies);
  if (result != null) foreach (party in result.Parties)
   if (party != null && party.isLocation() && party.getFlags().get("BVChapterID") == "ryza_fieldwork") {
    result.TerrainTemplate = "tactical.plains"; result.BVRyzaFieldwork <- true; break;
   }
  return result;
 };
});
// Keep native deaths, corpses, experience and other loot. Only remove the ten
// alchemy ingredients produced by these five beast classes in this expedition.
foreach (path in ["direwolf", "hyena", "spider", "unhold", "lindwurm"])
 ::$bvvar{namespace}.MH.hook("scripts/entity/tactical/enemies/" + path, function(q) {
  q.getLootForTile = @(__original) function(killer, loot) {
   local result = __original(killer, loot), properties = ::Tactical.State.getStrategicProperties();
   if (properties == null || !("BVRyzaFieldwork" in properties) || !properties.BVRyzaFieldwork) return result;
   for (local index = result.len() - 1; index >= 0; --index) {
    if (result[index] == null) continue;
    foreach (key, reward in ::$bvvar{namespace}.RyzaFieldRewards)
     if (key != "wolf" && result[index].getID() == reward.Item) { result.remove(index); break; }
   }
   return result;
  };
 });
