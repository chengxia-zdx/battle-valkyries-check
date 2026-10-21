this.shu_rice_item <- this.inherit("scripts/items/supplies/rice_item", {
 m = {},
 function create()
 {
  this.rice_item.create(); this.m.ID = "$bvvar{modId}.supplies.shu_rice";
  this.m.Name = "$bv{shu.rice.name}"; this.m.Description = "$bv{shu.rice.description}";
  this.m.Icon = "$bvvar{iconPrefix}/shu_rice_icon.png"; this.m.GoodForDays = 10;
  this.m.Value = 0;
 },
 function getBuyPrice() { return 0; },
 function getSellPrice() { return 0; }
});
