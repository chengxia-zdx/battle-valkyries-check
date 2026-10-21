this.shu_passive_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
 m = {},
 function create() { this.valkyrie_passive_skill.create(); },
 function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); },
 function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }]; },
 function onUpdate(p)
 {
  local a = this.actor(), f = ::$bvvar{namespace}.Shu;
  if (this.m.BVSkillKey != "shu_thick_earth" || !f.owner(a)) return;
  local shield = a.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
  if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield)) { p.MeleeDefense += 10; p.RangedDefense += 10; }
  local s = f.state(a);
  if (s != null && s.Active && f.round() < s.GuardUntil) p.MeleeDefense += 15;
 },
 function onBeforeDamageReceived(attacker, skill, hit, p)
 {
  local f = ::$bvvar{namespace}.Shu, a = this.actor(), s = f.state(a);
  if (this.m.BVSkillKey != "shu_thick_earth" || !f.owner(a) || skill == null || !skill.isAttack()) return;
  local reduction = 0.35;
  if (s != null && s.Active)
  {
   if (f.round() < s.GuardUntil) reduction = 0.50;
   reduction = ::Math.maxf(reduction, f.protection(a));
   if (s.FirstHitRound != f.round())
   {
    s.FirstHitRound = f.round(); reduction = 0.60;
    f.visual(a, "shu_guard"); f.sound(a, "shu_first_guard");
   }
  }
  p.DamageReceivedTotalMult *= 1.0 - reduction;
 },
 function onCombatStarted()
 {
  if (this.m.BVSkillKey == "shu_evergreen") { this.actor().m.BVShuRegenRound <- -999; ::$bvvar{namespace}.Shu.start(this.actor()); }
 },
 function onDeath(fatality) { if (this.m.BVSkillKey == "shu_evergreen") ::$bvvar{namespace}.Shu.stop(this.actor()); },
 function onCombatFinished() { if (this.m.BVSkillKey == "shu_evergreen") ::$bvvar{namespace}.Shu.stop(this.actor()); this.skill.onCombatFinished(); }
});
