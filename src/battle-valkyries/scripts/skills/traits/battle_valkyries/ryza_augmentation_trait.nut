// Persistent public skill path. Permanent choices/cooldown live in actor flags.
// Runtime turn counters deliberately reset at combat start, never on update.
this.ryza_augmentation_trait <- this.inherit("scripts/skills/traits/character_trait", {
 m = { Round=-1, InCombat=false, LifeSpent=false, Moved=true, MoveUndo=null, BloodHealed=0, MissUsed=false, MissTarget=null },
 function f() { return ::$bvvar{namespace}.RyzaTransmutation; },
 function owner() { return this.getContainer().getActor(); },
 function has(k) { return this.f().has(this.owner(),k); },
 function weapon(s) { return s!=null && s.isAttack() && s.m.IsWeaponSkill; },
 function create()
 {
  this.character_trait.create();this.m.ID="$bvvar{modId}.trait.ryza_augmentation";this.m.Name="$bv{ryza.ext.trait_summary}";
  this.m.Description="$bv{ryza.ext.trait_summary_desc}";this.m.Icon="skills/$bvvar{iconPrefix}/ryza_core_crystal.png";
  this.m.IsSerialized=true;this.m.IsStacking=false;this.m.IsRemovedAfterBattle=false;
 },
 function getTooltip()
 {
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}],a=this.owner();
  foreach(k in this.f().keys(a)) {local d=this.f().api().RyzaAugments[k];out.push({id=10+out.len(),type="text",icon="ui/items/$bvvar{iconPrefix}/ryza_pets/"+d.Species+".png",text=d.Name+": "+d.Description});}
  if(this.f().remaining(a)>0)out.push({id=90,type="text",icon="ui/icons/special.png",text="$bv{ryza.ext.cooldown}"+::Math.ceil(this.f().remaining(a)*24)+" $bv{ryza.ext.hours}"});
  return out;
 },
 function onCombatStarted() {this.m.InCombat=true;this.m.Round=-1;this.m.LifeSpent=false;this.m.Moved=true;this.m.MoveUndo=null;this.m.BloodHealed=0;this.m.MissUsed=false;this.m.MissTarget=null;},
 function onCombatFinished() {this.m.InCombat=false;this.m.Moved=true;this.m.MoveUndo=null;this.m.MissTarget=null;},
 function onTurnStart()
 {
  local a=this.owner(),bv=this.f().api();
  if(!this.m.InCombat || !bv.EightValkyries.alive(a) || !bv.EightValkyries.normal(a) || this.m.Round==::Time.getRound())return;
  this.m.Round=::Time.getRound();this.m.Moved=false;this.m.MoveUndo=null;this.m.BloodHealed=0;this.m.MissUsed=false;this.m.MissTarget=null;
  if(this.has("regen") && !a.getSkills().hasSkill("effects.unhold_potion"))a.setHitpoints(::Math.min(a.getHitpointsMax(),a.getHitpoints()+5));
 },
 function adjacentMercenary()
 {
  local a=this.owner();if(!a.isPlacedOnMap())return false;
  for(local d=0;d<6;d++)if(a.getTile().hasNextTile(d))
  {local t=a.getTile().getNextTile(d);if(t.IsOccupiedByActor){local b=t.getEntity();if("getLevel" in b && this.f().api().EightValkyries.alive(b) && a.isAlliedWith(b))return true;}}
  return false;
 },
 function onUpdate(p)
 {
  if(this.has("bone"))p.DamageReceivedRegularMult*=0.9;
  if(this.has("eagle"))p.RangedSkill+=6;
  if(this.has("giant"))p.HitpointsMult*=1.35;
  if(this.m.InCombat && !this.m.Moved && this.has("wall"))p.MeleeDefense+=8;
  if(this.has("guard") && this.adjacentMercenary()){p.MeleeDefense+=5;p.RangedDefense+=5;}
 },
 function onBeforeDamageReceived(attacker,skill,hit,p)
 { if(this.has("wing") && skill!=null && skill.isRanged())p.DamageReceivedRegularMult*=0.85; },
 function onAnySkillUsed(skill,target,p)
 {
  if(!this.weapon(skill))return;
  if(this.has("scale"))p.DamageArmorMult*=1.2;
  if(this.has("fury"))p.DamageRegularMult*=1.15;
  if(this.has("hunt") && target!=null && target.getHitpoints()<target.getHitpointsMax()*0.5)p.DamageRegularMult*=1.15;
  if(this.has("pierce"))p.DamageDirectAdd+=0.10;
  if(this.has("three") && target!=null && this.m.MissTarget==target.getID()){p.MeleeSkill+=10;p.RangedSkill+=10;}
 },
 function onTargetMissed(skill,target)
 {
  if(!this.m.InCombat || !this.weapon(skill) || target==null)return;
  if(this.m.MissTarget==target.getID())this.m.MissTarget=null;
  if(this.has("three") && !this.m.MissUsed){this.m.MissUsed=true;this.m.MissTarget=target.getID();}
 },
 function onTargetHit(skill,target,body,hp,armor)
 {
  if(!this.m.InCombat || !this.weapon(skill) || target==null)return;
  if(this.m.MissTarget==target.getID())this.m.MissTarget=null;
  local a=this.owner();
  if(!this.has("blood") || a.getSkills().hasSkill("effects.necrosavant_potion") || !this.f().api().EightValkyries.alive(a) || a.isAlliedWith(target) || target.getCurrentProperties().IsImmuneToBleeding || a.getTile().getDistanceTo(target.getTile())!=1 || hp<=0)return;
  local heal=::Math.min(12-this.m.BloodHealed,::Math.min(a.getHitpointsMax()-a.getHitpoints(),::Math.floor(hp*0.10)));
  if(heal>0){this.m.BloodHealed+=heal;a.setHitpoints(a.getHitpoints()+heal);}
 },
 function onDamageReceived(attacker,hp,armor)
 {
  local a=this.owner();if(!this.m.InCombat || this.m.LifeSpent || !this.has("life") || !("BVSurvivalFrame" in a.m) || a.m.BVSurvivalFrame==null)return;
  local frame=a.m.BVSurvivalFrame;
  if(frame.Triggered || !frame.CouldDie || hp<=0 || hp<frame.BeforeHP || !this.f().api().EightValkyries.alive(a))return;
  foreach(id in ["perk.nine_lives","effects.lorekeeper_potion"]){local s=a.getSkills().getSkillByID(id);if(s!=null && (!s.isSpent() || s.getLastFrameUsed()==::Time.getFrame()))return;}
  local m=this.f().api().getRuntimeSkillByKey(a,"morgan_from_worlds_end");if(m!=null && m.m.InCombat && !m.m.GutsSpent)return;
  this.m.LifeSpent=true;frame.Triggered=true;frame.Kind="ryza_second_heart";frame.RestoreHP=::Math.max(1,::Math.floor(a.getHitpointsMax()*0.25));a.setIsAbleToDie(false);
 }
});
