this.ai_ryza_pet_leap <- this.inherit("scripts/ai/tactical/behavior", {
 m = { Target = null, Skill = null },
 function create() { this.m.ID = this.Const.AI.Behavior.ID.Darkflight; this.m.Order = this.Const.AI.Behavior.Order.Darkflight; this.behavior.create(); }
 function onEvaluate(a)
 {
  this.m.Target = null; this.m.Skill = a.getSkills().getSkillByID("$bvvar{modId}.actives.ryza_pet_leap");
  if (this.m.Skill == null || !this.m.Skill.isUsable() || a.getMoraleState() == this.Const.MoraleState.Fleeing || a.getTile().hasZoneOfControlOtherThan(a.getAlliedFactions())) return 0;
  local bv = ::$bvvar{namespace};
  foreach (tile in bv.getValkyrieRadiusTiles(a.getTile(), 4, false))
  {
   if (!tile.IsOccupiedByActor || !bv.EightValkyries.enemy(a, tile.getEntity(), 4)) continue;
   for (local n = 0; n < 6; n++) if (tile.hasNextTile(n))
   { local dest = tile.getNextTile(n); if (this.m.Skill.onVerifyTarget(a.getTile(), dest)) { this.m.Target = dest; return this.Const.AI.Behavior.Score.Attack * 2; } }
  }
  return 0;
 }
 function onExecute(a)
 {
  if (this.m.Target != null && this.m.Skill != null && this.m.Skill.isUsable() && this.m.Skill.onVerifyTarget(a.getTile(), this.m.Target)) this.m.Skill.use(this.m.Target);
  this.m.Target = null; return true;
 }
});
