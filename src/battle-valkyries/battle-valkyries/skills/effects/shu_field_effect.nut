this.shu_field_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m = {},
 function create()
 {
  this.valkyrie_effect_skill.create();
  this.m.ID = "$bvvar{modId}.effects.shu_field"; this.m.Name = "$bv{shu.field.name}";
  this.m.Description = "$bv{shu.field.description}"; this.m.Icon = "skills/$bvvar{iconPrefix}/shu_evergreen.png";
  this.m.IsStacking = false;
 },
 function actor() { return this.getContainer() == null ? null : this.getContainer().getActor(); },
 function isHidden() { return ::$bvvar{namespace}.Shu.protection(this.actor()) <= 0; },
 function getTooltip() { return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{shu.field.reduction}" + ::Math.round(::$bvvar{namespace}.Shu.protection(this.actor()) * 100) + "%" }]; },
 function onBeforeDamageReceived(attacker, skill, hit, p)
 {
  if (skill == null || !skill.isAttack()) return;
  // Shu's own passive applies the maximum of her shield and field protection.
  if (::$bvvar{namespace}.Shu.owner(this.actor())) return;
  p.DamageReceivedTotalMult *= 1.0 - ::$bvvar{namespace}.Shu.protection(this.actor());
 }
});
