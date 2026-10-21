// A stationary friendly summon. Rachel drives its movement; no independent actions.
this.rachel_george <- this.inherit("scripts/entity/tactical/actor", {
 function create(){this.m.Type=::Const.EntityType.Wardog;this.m.BloodType=::Const.BloodType.None;this.m.XP=0;this.m.MoraleState=::Const.MoraleState.Ignore;this.actor.create();this.m.AIAgent=this.new("scripts/ai/tactical/agents/wardog_agent");this.m.AIAgent.setActor(this);this.m.Name="$bv{rachel.george_xiii.name}";},
 function onInit(){this.actor.onInit();local p=this.m.BaseProperties;p.Hitpoints=30;p.ActionPoints=0;p.Stamina=100;p.Initiative=0;p.Bravery=100;p.IsAffectedByNight=false;p.IsAffectedByInjuries=false;p.IsImmuneToBleeding=true;p.Armor=[0,0];p.ArmorMax=[0,0];this.m.Hitpoints=30;this.m.ActionPoints=0;this.m.CurrentProperties=clone p;this.m.IsUsingZoneOfControl=false;this.m.ActionPointCosts=::Const.DefaultMovementAPCost;this.m.FatigueCosts=::Const.DefaultMovementFatigueCost;this.addSprite("socket").setBrush("bust_base_beasts");this.addSprite("body").setBrush("entity_bv_rachel_alucard_george");foreach(n in ["armor","head","helmet","injury","closed_eyes"])this.addSprite(n).Visible=false;this.addDefaultStatusSprites();this.m.Items.getAppearance().Body="entity_bv_rachel_alucard_george";},
 function updateGeorgeFacing()
 {
  // The authored brush faces right. Reapply after faction/appearance changes,
  // just as native summoned animals do; a spawn's default facing can be left.
  if(this.hasSprite("body"))this.getSprite("body").setHorizontalFlipping(!this.isAlliedWithPlayer());
 },
 function onFactionChanged(){this.actor.onFactionChanged();this.updateGeorgeFacing();},
 function onAppearanceChanged(appearance,dirty=true){if(this.hasSprite("body"))this.getSprite("body").setBrush("entity_bv_rachel_alucard_george");this.updateGeorgeFacing();if(dirty)this.setDirty(true);},
 function assignRandomEquipment(){}
});
