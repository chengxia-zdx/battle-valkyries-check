::$bvvar{namespace}.MH.hook("scripts/states/world/asset_manager", function(q) {
 q.update = @(__original) function(worldState)
 {
  ::$bvvar{namespace}.Shu.updateWorld();
  return __original(worldState);
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
 q.onInit = @(__original) function()
 {
  ::$bvvar{namespace}.Shu.reset(); return __original();
 };
 q.onUpdate = @(__original) function()
 {
  local ret = __original(); ::$bvvar{namespace}.Shu.updateField(); return ret;
 };
 q.onBattleEnded = @(__original) function()
 {
  ::$bvvar{namespace}.Shu.clear(); return __original();
 };
});
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
 q.onDeserialize = @(__original) function(input)
 {
  ::$bvvar{namespace}.Shu.reset(); return __original(input);
 };
});
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
 q.onTurnStart = @(__original) function()
 {
  local ret = __original(); ::$bvvar{namespace}.Shu.updateField(); ::$bvvar{namespace}.Shu.tick(this); return ret;
 };
 q.onMovementFinish = @(__original) function(tile)
 {
  local ret = __original(tile); ::$bvvar{namespace}.Shu.move(); return ret;
 };
 q.onDeath = @(__original) function(killer, skill, tile, fatality)
 {
  ::$bvvar{namespace}.Shu.stop(this); return __original(killer, skill, tile, fatality);
 };
});
// Wrap the concrete shieldwall getter, preserving the shared global skill hook.
::$bvvar{namespace}.MH.hook("scripts/skills/actives/shieldwall", function(q) {
 q.getFatigueCost = @(__original) function()
 {
  local value = __original(), a = this.getContainer() == null ? null : this.getContainer().getActor();
  return ::$bvvar{namespace}.Shu.owner(a) ? ::Math.ceil(value * 0.5).tointeger() : value;
 };
});
