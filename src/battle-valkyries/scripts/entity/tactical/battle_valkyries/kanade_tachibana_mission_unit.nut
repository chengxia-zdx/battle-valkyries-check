this.kanade_tachibana_mission_unit <- this.inherit("scripts/entity/tactical/humans/peasant", {
 m={KanadeMissionUnit=true,KanadeKind="",KanadeSpawned=0,KanadeDismissed=false},
 function create(){this.peasant.create();this.m.XP=0;this.m.IsNonCombatant=false;this.m.MoraleState=this.Const.MoraleState.Ignore;},
 function assignRandomEquipment(){},
 function configure(kind,faction)
 {
  this.m.KanadeKind=kind;this.setFaction(faction);local b=this.m.BaseProperties;
  b.Hitpoints=kind=="cart"?240:(kind=="tent"?360:(kind=="node"||kind=="anchor"?220:100));b.ActionPoints=kind=="captive"?6:0;
  b.MeleeDefense=0;b.RangedDefense=0;b.TargetAttractionMult=3.0;b.IsAffectedByInjuries=false;b.IsAffectedByDyingAllies=false;
  b.IsImmuneToKnockBackAndGrab=true;b.IsImmuneToStun=true;
  this.m.CurrentProperties=clone b;this.m.Hitpoints=kind=="wounded"?40:b.Hitpoints;this.m.ActionPoints=b.ActionPoints;
  // Keep the turn-sequence registration made by native onPlacedOnMap balanced.
  this.m.IsControlledByPlayer=kind=="captive";this.m.IsUsingZoneOfControl=false;
  this.m.Name=::$bvvar{namespace}.KanadeMissionNames[kind];
  if(kind=="captive"){this.m.AIAgent=this.new("scripts/ai/tactical/player_agent");this.m.AIAgent.setActor(this);}
  if(kind=="cart"||kind=="tent"||kind=="node"||kind=="anchor")
  {
   foreach(name in ["head","hair","beard","helmet","armor"])if(this.hasSprite(name))this.getSprite(name).Visible=false;
   this.getSprite("body").setBrush(kind=="cart"?"donkey_tactical":(kind=="tent"?"world_bandit_camp_01":"effect_bv_kanade_tachibana_harmonics"));
  }
  this.setDirty(true);
 },
 function addXP(amount,scale=true){},
 function dismissMission(){if(this.m.KanadeDismissed)return;this.m.KanadeDismissed=true;this.m.IsAlive=false;this.m.IsDying=true;this.m.IsTurnDone=true;this.removeFromMap();},
 function kill(killer=null,skill=null,fatalityType=this.Const.FatalityType.None){this.dismissMission();::$bvvar{namespace}.KanadeMissions.refresh();},
 function retreat(){this.dismissMission();::$bvvar{namespace}.KanadeMissions.refresh();},
 function onSerialize(out){throw "[Battle Valkyries] Mission unit cannot enter roster save";}
});
