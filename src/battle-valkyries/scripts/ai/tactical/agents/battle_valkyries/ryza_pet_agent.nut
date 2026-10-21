this.ryza_pet_agent <- this.inherit("scripts/ai/tactical/agents/wardog_agent", {
 function onAddBehaviors() {}
 function configure()
 {
  local a = this.getActor(), ranged = a.m.PetStats != null && a.m.PetStats.Range > 1;
  local engage = this.new(ranged ? "scripts/ai/tactical/behaviors/ai_engage_ranged" : "scripts/ai/tactical/behaviors/ai_engage_melee");
  if (ranged) { engage.m.PossibleSkills = ["$bvvar{modId}.actives.ryza_pet_attack"]; this.m.Properties.IsRangedUnit = true; this.m.Properties.OverallDefensivenessMult = 1.0; }
  this.addBehavior(engage);
  local attack = this.new("scripts/ai/tactical/behaviors/ai_attack_default"); attack.m.PossibleSkills = ["$bvvar{modId}.actives.ryza_pet_attack"]; this.addBehavior(attack);
  if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "griffin") this.addBehavior(this.new("scripts/ai/tactical/behaviors/battle_valkyries/ai_ryza_pet_leap"));
  this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee")); this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
  this.finalizeBehaviors();
 }
});
