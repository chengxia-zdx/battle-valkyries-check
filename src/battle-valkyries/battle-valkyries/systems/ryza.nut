// Battle-only resource state; identity remains exclusively in actor flags.
::$bvvar{namespace}.Ryza <- {
 function api() { return ::$bvvar{namespace}; },
 function alive(a) { return this.api().EightValkyries.alive(a); },
 function owner(a) { return a != null && a.isPlayerControlled() && this.api().getActorValkyrieID(a) == "ryza"; },
 function state(a) { return a != null && "BVRyza" in a.m ? a.m.BVRyza : null; },
 function start(a) { if (this.owner(a) && this.state(a) == null) a.m.BVRyza <- { CC = 3, Turn = 0, Round = -1, PulseRound = -1, FlameRound = -1, Cooldowns = {}, LastAction = null }; },
 function turn(a)
 {
  local s = this.state(a), round = ::Time.getRound();
  if (s == null || !this.alive(a) || !this.api().EightValkyries.normal(a) || s.Round == round) return;
  s.Round = round; s.Turn++;
  if (s.Turn > 1) s.CC = ::Math.min(6, s.CC + 1);
 },
 function healable(a, b)
 {
  return this.api().EightValkyries.ally(a, b, true) && (b.getHitpoints() < b.getHitpointsMax() || b.getSkills().hasSkill("effects.poison") || b.getSkills().hasSkill("effects.goblin_poison") || b.getSkills().hasSkill("effects.bleeding"));
 },
 function heal(b)
 {
  b.setHitpoints(::Math.min(b.getHitpointsMax(), b.getHitpoints() + 35));
  foreach (id in ["effects.poison", "effects.goblin_poison", "effects.bleeding"])
  { local e = b.getSkills().getSkillByID(id); if (e != null) { e.removeSelf(); break; } }
  b.getSkills().update(); b.setDirty(true);
 },
 function frost(b)
 {
  if (!this.alive(b) || !this.api().EightValkyries.debuffable(b)) return;
  local e = b.getSkills().getSkillByID("$bvvar{modId}.effects.ryza_frost");
  if (e == null) { e = ::new("$bvvar{privateFolder}/skills/effects/ryza_frost_effect"); b.getSkills().add(e); }
  e.m.UntilStart = this.api().FiveValkyries.clock(b).Starts + 1;
  b.getSkills().update();
 }
};
::$bvvar{namespace}.finalizeRyzaProperties <- function(actor, skill, properties)
{
 if (skill != null && "BVRyzaSpell" in skill.m && ::$bvvar{namespace}.Ryza.owner(actor)) skill.finalizeSpellProperties(properties);
};
