this.si_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,HitSpec=null},
 function f(){return ::$bvvar{namespace}.Si;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create()
 {
  this.valkyrie_active_skill.create();this.m.IsWeaponSkill=false;this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;
  this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=4;this.m.IsIgnoredAsAOO=true;
 },
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=clone d.Spec;this.m.ActionPointCost=d.Spec.AP;this.m.FatigueCost=d.Spec.Fatigue;
  this.m.MinRange=this.m.BVSkillKey=="si_sanctuary"?0:1;this.m.MaxRange=d.Spec.Range;
  this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsAttack=d.Spec.Attack;this.m.IsRanged=d.Spec.Attack;
  this.m.IsUsingHitchance=this.m.BVSkillKey=="si_brush";this.m.IsShieldRelevant=this.m.BVSkillKey=="si_brush";this.m.DirectDamageMult=d.Spec.Pierce;
 },
 function isUsable(){return this.f().ready(this.actor(),this.m.BVSkillKey,this.m.Spec)&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile)
 {
  local f=this.f(),a=this.actor(),d=this.m.Spec,k=this.m.BVSkillKey;
  if(!f.owner(a)||origin==null||tile==null||!tile.IsOccupiedByActor||!tile.IsVisibleForEntity)return false;
  local distance=origin.getDistanceTo(tile);
  if(distance<this.m.MinRange||distance>d.Range||::Math.abs(origin.Level-tile.Level)>4||!origin.hasLineOfSightTo(tile,d.Range))return false;
  local b=tile.getEntity();
  if(k=="si_sanctuary")return f.ally(a,b);
  return f.enemy(a,b)&&(k!="si_dragon"||f.marked(a,b));
 },
 function getAffectedTiles(tile)
 {
  if(tile==null)return [];local out=[],f=this.f(),k=this.m.BVSkillKey;
  if(k=="si_landscape"&&tile.IsOccupiedByActor){foreach(b in f.nearbyEnemies(this.actor(),tile.getEntity()))out.push(b.getTile());return out;}
  if(k=="si_sanctuary")return f.api().getValkyrieRadiusTiles(tile,1,true);
  if(k=="si_dragon"){foreach(m in f.marks(this.actor()))out.push(f.read(m.Target).getTile());return out;}
  return [tile];
 },
 function onTargetSelected(tile)
 {
  this.skill.onTargetSelected(tile);
  if(this.m.BVSkillKey!="si_brush")foreach(t in this.getAffectedTiles(tile))this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 function onAnySkillUsed(skill,target,p)
 {
  if(skill!=this||!this.m.IsAttack)return;
  local d=this.m.HitSpec==null?this.m.Spec:this.m.HitSpec;
  p.DamageRegularMin=d.Low;p.DamageRegularMax=d.High;p.DamageArmorMult=d.Armor;
  p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
  p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;p.RangedSkill+=d.Hit;
 },
 function strike(a,b,secondary=false)
 {
  local f=this.f();if(!f.able(a)||!f.enemy(a,b))return false;
  local d=clone this.m.Spec;if(secondary){d.Low=120;d.High=160;}
  local tile=b.getTile(),pos=f.api().captureValkyrieSkillAudioPosition(b);this.m.HitSpec=d;
  local hit=false;
  try{hit=this.attackEntity(a,b,false);}
catch(e){this.m.HitSpec=null;throw e;}
  this.m.HitSpec=null;
  if(hit)
  {
   if(this.m.BVSkillKey=="si_brush")
   {
    f.visual(a,tile,"si_frost_impact");f.sound(a,"si_brush_impact",pos);
    if(f.enemy(a,b))f.mark(a,b);
   }
   else {f.visual(a,tile,"si_dragon_impact");f.visual(a,tile,"si_scroll_close",240);}
  }
  return hit;
 },
 function onUse(a,tile)
 {
  if(!this.isUsable()||!this.onVerifyTarget(a.getTile(),tile))return false;
  local f=this.f(),k=this.m.BVSkillKey,b=tile.getEntity();
  // Validate the full action before spending the battle-only resource once.
  f.spend(a,k,this.m.Spec);
  switch(k)
  {
   case "si_brush":
    f.visual(a,a.getTile(),"si_cast");f.visual(a,tile,"si_brush_travel");f.sound(a,"si_brush_cast");this.strike(a,b);break;
   case "si_landscape":f.landscape(a,b);break;
   case "si_sanctuary":f.sanctuary(a,b);break;
   case "si_dragon":
    local targets=[f.ref(b)];foreach(m in f.marks(a))if(f.read(m.Target)!=b)targets.push(m.Target);
    f.visual(a,a.getTile(),"si_dragon_cast");f.visual(a,a.getTile(),"si_scroll_cast");f.sound(a,"si_dragon_cast");
    local first=true,impact=false;
    foreach(r in targets)
    {
     if(!f.able(a))break;local target=f.read(r);if(!f.enemy(a,target))continue;
     f.link(a,a.getTile(),target.getTile());local pos=f.api().captureValkyrieSkillAudioPosition(target);
     if(this.strike(a,target,!first)&&!impact){f.sound(a,"si_dragon_impact",pos);impact=true;}
first=false;
    }
    f.clearMarks(a);if(f.owner(a))f.afterglow(a);break;
  }
  f.update(a);return true;
 },
 function getTooltip()
 {
  local f=this.f(),a=this.actor(),s=f.state(a),d=this.m.Spec;
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
   {id=3,type="text",text=this.getCostString()},
   {id=4,type="text",icon="ui/icons/special.png",text="$bv{si.ink}"+(s==null?0:s.Ink)+" / 6; $bv{si.ink_cost}"+d.Ink},
   {id=5,type="text",icon="ui/icons/time.png",text="$bv{si.cooldown}"+f.cooldown(a,this.m.BVSkillKey)}];
  if(s==null||!f.owner(a))out.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{si.unavailable.owner}"});
  else if(s.Ink<d.Ink)out.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{si.unavailable.ink}"});
  else if(f.cooldown(a,this.m.BVSkillKey)>0)out.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{si.unavailable.cooldown}"});
  if(this.m.BVSkillKey=="si_dragon")out.push({id=7,type="text",icon="ui/icons/vision.png",text="$bv{si.dragon.target}"});
  return out;
 }
});
