this.alisa_orbal_shot <- this.inherit("scripts/skills/skill", {
 m={BVOrbalBow=true,BVRadiantAction=null},
 function create(){
  this.m.ID="$bvvar{modId}.actives.alisa_orbal_shot";this.m.Name="$bv{trails.bow_shot.name}";this.m.Description="$bv{trails.bow_shot.description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/alisa_flame_arrow.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/alisa_flame_arrow_sw.png";
  this.m.Type=this.Const.SkillType.Active;this.m.Order=this.Const.SkillOrder.OffensiveTargeted;this.m.IsActive=true;this.m.IsSerialized=false;
  this.m.IsAttack=true;this.m.IsRanged=true;this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsUsingHitchance=true;
  this.m.IsWeaponSkill=true;this.m.IsShowingProjectile=false;this.m.IsShieldRelevant=false;this.m.IsIgnoredAsAOO=true;
  this.m.ActionPointCost=4;this.m.FatigueCost=8;this.m.MinRange=1;this.m.MaxRange=6;this.m.MaxRangeBonus=0;this.m.DirectDamageMult=0.2;this.m.MaxLevelDifference=4;
 }
 function getTooltip(){return this.getDefaultTooltip();}
 function onUse(a,tile){
  local f=::$bvvar{namespace}.TrailsDuo;
  if(!f.alive(a)||tile==null||!tile.IsOccupiedByActor||!f.weapon(a,"alisa_orbal_bow"))return false;
  local b=tile.getEntity();if(!f.combat().enemy(a,b))return false;
  f.beginBow(a,this);local pos=f.api().captureValkyrieSkillAudioPosition(b),hit=false;
  try {f.api().playValkyrieSkillAudio(a,"alisa_flame_arrow");hit=this.attackEntity(a,b,false);
   if(hit&&pos!=null)f.api().playValkyrieSkillAudio(a,"alisa_flame_arrow_impact",pos);
  }catch(e){this.m.BVRadiantAction=null;throw e;}
  this.m.BVRadiantAction=null;f.refresh(a);return true;
 }
});
