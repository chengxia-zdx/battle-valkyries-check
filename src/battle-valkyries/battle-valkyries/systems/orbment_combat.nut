// Persistent actor flags carry combat cooldowns/effects through runtime skill rebuilding.
::$bvvar{namespace}.OrbalCombat <- {
 function api(){return ::$bvvar{namespace};},
 function read(a,k,v=0){local f=a.getFlags(),key="$bvvar{modId}.orbal."+k;return f.has(key)?f.get(key):v;},
 function write(a,k,v){a.getFlags().set("$bvvar{modId}.orbal."+k,v);},
 function round(){return ::Time.getRound();},
 function alive(a){return a!=null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap();},
 function normal(a){return this.api().FiveValkyries.normal(a);},
 function ally(a,b){return this.alive(b) && a.isAlliedWith(b) && b.isPlayerControlled();},
 function enemy(a,b){return this.alive(b) && !a.isAlliedWith(b);},
 function stacks(a,key)
 {
  if(a==null)return 0;
  local count=this.read(a,key+".count");if(count<=0)return 0;
  if(key=="analysis" || key=="chill" || key=="zero")return this.round()<this.read(a,key+".until")?count:0;
  return count;
 },
 function ensure(a)
 {
  if(a==null || a.getSkills()==null)return;
  if(a.getSkills().getSkillByID("$bvvar{modId}.effects.orbal_state")==null)
   a.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/orbment_status_effect"));
 },
 function apply(a,key,count,duration=0)
 {
  this.ensure(a);this.write(a,key+".count",this.stacks(a,key)+count);
  if(duration>0)this.write(a,key+".until",this.round()+duration);
  else this.write(a,key+".turn",this.read(a,"turns")+1);
  a.getSkills().update();a.setDirty(true);
 },
 function reset(a)
 {
  foreach(key in ["analysis","chill","zero","guard","boost","disrupt","veil","bulwark","haste"]) {
   this.write(a,key+".count",0);this.write(a,key+".until",0);this.write(a,key+".turn",0);
  }
  foreach(key,d in this.api().ValkyrieSkillCatalog)if(key.find("orbment_")==0 || key.find("tio_")==0) {
   this.write(a,"cd."+key,0);this.write(a,"uses."+key,0);this.write(a,"last_action."+key,"");
  }
  this.write(a,"turns",0);this.write(a,"last_round",-1);this.write(a,"kill_round",-1);
  this.write(a,"haste.used",0);this.write(a,"haste.active",0);
 },
 function startTurn(a)
 {
  if(!this.alive(a) || !this.normal(a) || this.read(a,"last_round",-1)==this.round())return false;
  this.write(a,"last_round",this.round());this.write(a,"turns",this.read(a,"turns")+1);
  if(this.stacks(a,"haste")>0){this.write(a,"haste.active",this.stacks(a,"haste"));this.write(a,"haste.count",0);}
  return true;
 },
 function endTurn(a)
 {
  if(!this.normal(a))return;
  foreach(key in ["guard","boost","disrupt","veil","bulwark"])
   if(this.read(a,"turns")>=this.read(a,key+".turn"))this.write(a,key+".count",0);
  this.write(a,"haste.active",0);a.getSkills().update();
 },
 function heal(a,b,amount)
 {
  if(!this.ally(a,b))return false;
  local scale=this.api().getActorValkyrieID(a)=="tio"?1.0+this.api().Orbments.total(a).water*0.02:1.0;
  local hp=b.getHitpoints(),maxHP=b.getHitpointsMax();
  b.setHitpoints(::Math.min(maxHP,hp+::Math.floor(amount*scale)));b.setDirty(true);return true;
 },
 function recover(a,n){if(!this.alive(a))return;a.setFatigue(::Math.max(0,a.getFatigue()-n));a.setDirty(true);},
 function cleanse(a)
 {
  foreach(id in ["effects.bleeding","effects.spider_poison","effects.goblin_poison"]) {
   local s=a.getSkills().getSkillByID(id);
   if(s!=null){s.removeSelf();a.getSkills().update();return true;}
  }
  return false;
 },
 function presentation(skill,a,key,target=null)
 {
  this.api().playValkyrieVisual(skill,a,"orbment_cast");
  this.api().playValkyrieSkillAudio(a,key);
  if(target!=null)this.api().playValkyrieVisual(skill,target,key);
 },
 function line(a,tile,maxRange)
 {
  local origin=a.getTile(),out=[],direction=-1;
  // Accept only one of the six actual hex rays, not an approximate angular cone.
  for(local d=0;d<6;d++) {
   local t=origin;
   for(local n=1;n<=maxRange;n++){if(!t.hasNextTile(d))break;t=t.getNextTile(d);if(t.ID==tile.ID){direction=d;break;}}
   if(direction>=0)break;
  }
  if(direction<0)return out;
  local previous=origin;
  for(local n=1;n<=maxRange;n++) {
   if(!previous.hasNextTile(direction))break;local t=previous.getNextTile(direction);
   if(::Math.abs(previous.Level-t.Level)>1 || (!t.IsEmpty && !t.IsOccupiedByActor) || !t.IsVisibleForEntity)break;
   out.push(t);previous=t;
  }
  return out;
 },
 function available(skill,a)
 {
  if(!this.alive(a) || !this.api().EightValkyries.able(a))return "$bv{orbment.error.unavailable}";
  local key=skill.m.BVSkillKey,d=skill.m.Spec;
  if(key.find("tio_")==0 && this.api().getActorValkyrieID(a)!="tio")return "$bv{orbment.error.unavailable}";
  if(key.find("orbment_")==0) {
   local it=this.api().Orbments.item(a);
   if(it==null || this.api().Orbments.readItem(it).Active.find(key)==null)return "$bv{orbment.error.unavailable}";
  }
  if(this.read(a,"cd."+key)>this.round())return "$bv{orbment.cooldown} "+(this.read(a,"cd."+key)-this.round());
  if(d.Limit>0 && this.read(a,"uses."+key)>=d.Limit)return "$bv{orbment.limit}";
  if(d.Mode=="weapon") {local w=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);if(w==null || w.isItemType(::Const.Items.ItemType.RangedWeapon) || w.getCondition()<=0)return "$bv{orbment.melee_required}";}
  return null;
 },
 function properties(a,skill,target,p)
 {
  if(a==null || !this.api().isDirectAttack(skill))return p;
  local spell="BVOrbalSpell" in skill.m && skill.m.BVOrbalSpell;
  local bonuses=this.api().Orbments.bonuses(a),analysis=this.stacks(target,"analysis");
  if(!a.isPlayerControlled())analysis=0;
  if(!spell && this.api().Orbments.item(a)==null && analysis==0)return p;
  if("isValkyrieOpaqueCombatSkill" in this.api() && this.api().isValkyrieOpaqueCombatSkill(skill))return p;
  local damage="Damage" in bonuses?bonuses.Damage:0.0,armor="Armor" in bonuses?bonuses.Armor:0.0,pierce="Pierce" in bonuses?bonuses.Pierce:0.0;
  if(spell && skill.m.Spec.Mode!="weapon") {
   local d=skill.m.Spec,r=a.getCurrentProperties().getRangedSkill();
   if("TrailsDuo" in this.api() && this.api().TrailsDuo.owns(a,"renne") && this.api().TrailsDuo.has(a,"renne_genius_executor"))r=this.api().TrailsDuo.aim(a);
   p.DamageRegularMin=d.DamageMin+::Math.floor(d.Scale*r);p.DamageRegularMax=d.DamageMax+::Math.floor(d.Scale*r);
   p.DamageRegularMult=1.0;p.DamageArmorMult=d.Armor;p.DamageDirectMult=1.0;
   p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
   p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
   p.HitChance[::Const.BodyPart.Head]=0;p.HitChance[::Const.BodyPart.Body]=100;
   p.HitChanceMult[::Const.BodyPart.Head]=1.0;p.HitChanceMult[::Const.BodyPart.Body]=1.0;
   p.RangedSkill+=d.Accuracy;
   if(this.api().getActorValkyrieID(a)=="tio")damage+=this.api().Orbments.total(a).fire*0.02;
   if(d.Mode=="buster")damage+=analysis*0.1;
  } else if(spell)damage+=0.2;
  p.MeleeSkill+=analysis*5;p.RangedSkill+=analysis*5;armor+=analysis*0.1;pierce+=analysis*0.05;
  p.DamageDirectAdd+=pierce;
  local total=p.DamageDirectMult*(skill.m.DirectDamageMult+p.DamageDirectAdd+(skill.isRanged()?p.DamageDirectRangedAdd:p.DamageDirectMeleeAdd));
  // Engine clamps only the physical split. Overflow is a single additive direct damage bonus.
  p.BVOrbalPenetration <- total;
  damage+=::Math.maxf(0.0,total-1.0);
  p.DamageTotalMult*=1.0+damage;p.DamageArmorMult*=1.0+armor;
  return p;
 }
};
::$bvvar{namespace}.finalizeOrbalProperties <- function(a,skill,target,p){return this.OrbalCombat.properties(a,skill,target,p);};

