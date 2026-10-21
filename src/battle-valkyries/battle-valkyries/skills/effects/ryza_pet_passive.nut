this.ryza_pet_passive <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create() { this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.ryza_pet_passive"; this.m.IsHidden = true; }
 function onUpdate(p)
 {
  local a = this.getContainer().getActor();
  if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "bone_mastiff") p.DamageReceivedRegularMult *= 0.9;
  if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "bone_mastiff" || ::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "iron_cerberus" || ::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "ironwing") p.MovementAPCostAdditional += 1;
 }
 function onTurnStart()
 {
  local bv = ::$bvvar{namespace}, a = this.getContainer().getActor(), round = ::Time.getRound();
  if (!bv.EightValkyries.alive(a) || !bv.EightValkyries.normal(a) || a.m.LastTurn == round) return;
  a.m.LastTurn = round;
  local properties = a.getCurrentProperties();
  if (properties.IsStunned || !properties.IsAbleToUseSkills || a.getMoraleState() == ::Const.MoraleState.Fleeing) return;
  if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) != "spirit_vulture" && ::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) != "twin_guardian") return;
  local candidates = [], radius = ::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "spirit_vulture" ? 2 : 1;
  foreach (tile in bv.getValkyrieRadiusTiles(a.getTile(), radius, true))
  {
   if (!tile.IsOccupiedByActor) continue; local b = tile.getEntity();
   if (b == a || !bv.EightValkyries.alive(b) || !a.isAlliedWith(b) || b.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
   local aid = b.getSkills().getSkillByID("$bvvar{modId}.effects.ryza_pet_aid_lock");
   if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "spirit_vulture" && ((aid != null && aid.m.Round == round) || (b.getHitpoints() >= b.getHitpointsMax() && !b.getSkills().hasSkill("effects.poison") && !b.getSkills().hasSkill("effects.goblin_poison") && !b.getSkills().hasSkill("effects.bleeding")))) continue;
   candidates.push(b);
  }
  candidates.sort(function(x,y) { local delta = x.getHitpoints().tofloat()/x.getHitpointsMax() - y.getHitpoints().tofloat()/y.getHitpointsMax(); return delta < 0 ? -1 : (delta > 0 ? 1 : (x.getID() < y.getID() ? -1 : 1)); });
  if (candidates.len() == 0 || a.getActionPoints() < 4) return; local b = candidates[0];
  a.setActionPoints(a.getActionPoints() - 4);
  if (::$bvvar{namespace}.RyzaAlchemy.family(a.m.Species) == "spirit_vulture")
  {
   local aid = b.getSkills().getSkillByID("$bvvar{modId}.effects.ryza_pet_aid_lock");
   if (aid == null) { aid = this.new("$bvvar{privateFolder}/skills/effects/ryza_pet_aid_lock"); b.getSkills().add(aid); }
   aid.m.Round = round; b.setHitpoints(::Math.min(b.getHitpointsMax(), b.getHitpoints() + 10 + a.m.Tier * 5));
   foreach (id in ["effects.poison","effects.goblin_poison","effects.bleeding"]) { local e = b.getSkills().getSkillByID(id); if (e != null) { e.removeSelf(); break; } }
   bv.playValkyrieVisual(this, b, "ryza_elixir");
  }
  else
  {
   local e = b.getSkills().getSkillByID("$bvvar{modId}.effects.ryza_pet_guard");
   if (e == null) { e = this.new("$bvvar{privateFolder}/skills/effects/ryza_pet_guard"); b.getSkills().add(e); }
   e.m.Source = bv.makeValkyrieCombatWeakRef(a); e.m.UntilStart = bv.FiveValkyries.clock(a).Starts + 1;
   bv.playValkyrieVisual(this, b, "ryza_cast");
  }
  b.getSkills().update(); b.setDirty(true);
 }
});
