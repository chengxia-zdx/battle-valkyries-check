// All durable combat state lives in actor flags; skill rebuilding never refills it.
::$bvvar{namespace}.TrailsDuo <- {
 function api(){return ::$bvvar{namespace};}
 function combat(){return this.api().OrbalCombat;}
 function alive(a){return this.combat().alive(a);}
 function read(a,k,v=0){if(a==null)return v;local f=a.getFlags(),key="$bvvar{modId}.trails."+k;return f.has(key)?f.get(key):v;}
 function write(a,k,v){a.getFlags().set("$bvvar{modId}.trails."+k,v);}
 function owns(a,id){return a!=null && a.isPlayerControlled() && this.api().getActorValkyrieID(a)==id;}
 function has(a,key){return a!=null && a.getSkills().hasSkill(this.api().getValkyrieSkillRuntimeID(key));}
 function round(){return ::Time.getRound();}
 function ensure(a){
  if(a.getSkills().getSkillByID("$bvvar{modId}.effects.trails_state")==null)
   a.getSkills().add(::new("$bvvar{privateFolder}/skills/effects/trails_duo_state"));
 }
 function refresh(a){if(this.alive(a)){a.getSkills().update();a.setDirty(true);}}
 function owners(a){local s=this.read(a,"mark.owners","");return s==""?[]:split(s,",");}
 function marks(a,b){
  if(a==null || b==null)return 0;local key="mark."+a.getID();
  return this.read(b,key+".until")>this.round()?this.read(b,key+".count"):0;
 }
 function action(a,skill){local c=this.api().getCurrentValkyrieActionContext(a,skill);return c==null?null:c;}
 function token(a,skill){local c=this.action(a,skill);return c==null?"":c.ActionToken;}
 function addMark(a,skill,b){
  if(!this.alive(a)||!this.combat().enemy(a,b)||!this.owns(a,"renne")||!this.has(a,"renne_annihilation_mark")||!this.api().FiveValkyries.canDebuff(b))return;
  local token=this.token(a,skill),key="mark."+a.getID();if(token==""||this.read(b,key+".action","")==token)return;
  this.ensure(b);local id=a.getID().tostring(),owners=this.owners(b);
  if(owners.find(id)==null)this.write(b,"mark.owners",this.read(b,"mark.owners","")+(owners.len()==0?"":",")+id);
  this.write(b,key+".count",::Math.min(3,this.marks(a,b)+1));this.write(b,key+".until",this.round()+3);this.write(b,key+".action",token);this.refresh(b);
 }
 function detonate(a,skill,b,count){
  if(count<=0)return false;local key="mark."+a.getID(),token=this.token(a,skill);
  if(token==""||this.read(b,key+".detonation","")==token)return false;
  this.write(b,key+".count",0);this.write(b,key+".detonation",token);this.refresh(b);return true;
 }
 function support(a,b,changed){
  if(!changed || a==b || !this.owns(a,"alisa") || !this.has(a,"alisa_radiant_resonance") || !this.combat().ally(a,b))return;
  this.ensure(a);this.write(a,"radiance",1);this.refresh(a);
 }
 function bow(skill){return skill!=null && "BVOrbalBow" in skill.m && skill.m.BVOrbalBow;}
 function beginBow(a,skill){
  skill.m.BVRadiantAction=0;
  if(this.owns(a,"alisa")&&this.has(a,"alisa_radiant_resonance")&&this.read(a,"radiance")>0){skill.m.BVRadiantAction=1;this.write(a,"radiance",0);}
  return skill.m.BVRadiantAction==1;
 }
 function radiant(a,skill){return "BVRadiantAction" in skill.m && skill.m.BVRadiantAction!=null?skill.m.BVRadiantAction:this.read(a,"radiance");}
 function weapon(a,key){local w=a==null?null:a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);return w!=null&&w.getID()=="$bvvar{modId}.weapon."+key&&w.getCondition()>0;}
 function aim(a){local p=a.getCurrentProperties();return ::Math.max(p.getMeleeSkill(),p.getRangedSkill());}
 function available(skill,a){
  if(!this.alive(a)||!this.api().EightValkyries.able(a)||!this.owns(a,skill.m.BVSkillKey.find("renne_")==0?"renne":"alisa"))return "$bv{trails.unavailable}";
  local d=skill.m.Spec;if(d.Weapon!=""&&!this.weapon(a,d.Weapon))return "$bv{trails.weapon_required}";
  local cd=this.read(a,"cd."+skill.m.BVSkillKey)-this.round();if(cd>0)return "$bv{trails.cooldown} "+cd;
  if(d.Mode=="step"&&a.getCurrentProperties().IsRooted)return "$bv{trails.unavailable}";
  return null;
 }
 function properties(a,skill,b,p){
  if(a==null||!this.api().isDirectAttack(skill))return p;
  local innate="BVTrailsInnate" in skill.m && skill.m.BVTrailsInnate;
  local spell="BVOrbalSpell" in skill.m&&skill.m.BVOrbalSpell;
  local renne=this.owns(a,"renne"),alisa=this.owns(a,"alisa");
  if(renne&&(innate||spell)&&this.has(a,"renne_genius_executor")){
   local current=a.getCurrentProperties(),ranged=skill.isRanged(),stat=ranged?"RangedSkill":"MeleeSkill",mult=stat+"Mult";
   // Add only the difference between current actor stats: keep skill-specific bonuses and multipliers.
   local m=mult in p?p[mult]:1.0,baseline=ranged?current.getRangedSkill():current.getMeleeSkill();
   if(m>0)p[stat]+=(this.aim(a)-baseline)/m;
  }
  if(innate){
   local d=skill.m.Spec,scaling=renne?this.aim(a):a.getCurrentProperties().getRangedSkill();
   p.DamageRegularMin=d.DamageMin+::Math.floor(d.Scale*scaling);p.DamageRegularMax=d.DamageMax+::Math.floor(d.Scale*scaling);
   p.DamageRegularMult=1.0;p.DamageArmorMult=d.Armor;p.DamageDirectMult=1.0;
   p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
   p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
   if(renne&&(d.Mode=="scythe"||d.Mode=="angel")&&this.has(a,"renne_annihilation_mark"))p.DamageTotalMult*=1.0+this.marks(a,b)*(d.Mode=="angel"?0.25:0.15);
  }
  if(alisa&&this.bow(skill)&&this.weapon(a,"alisa_orbal_bow")){
   if(this.has(a,"alisa_orbal_bow_expert"))p.RangedSkill+=10;
   if(this.has(a,"alisa_radiant_resonance")&&this.radiant(a,skill)>0){p.DamageTotalMult*=1.25;p.DamageDirectAdd+=0.1;}
  }
  return p;
 }
 function canBurn(b){if(!this.alive(b)||!this.api().FiveValkyries.canDebuff(b))return false;local p=b.getCurrentProperties();foreach(k in ["IsImmuneToFire","IsImmuneToBurning","IsImmuneToBurn"])if(k in p&&p[k])return false;return true;}
 function burn(a,b){if(!this.canBurn(b))return;this.ensure(b);this.write(b,"burn.ticks",2);this.write(b,"burn.source",a.getID());this.refresh(b);}
 function heal(b,n){local hp=b.getHitpoints();b.setHitpoints(::Math.min(b.getHitpointsMax(),hp+n));this.refresh(b);return b.getHitpoints()>hp;}
 function recover(b,n){local before=b.getFatigue();this.combat().recover(b,n);return b.getFatigue()<before;}
 function bless(a,b){
  if(!this.combat().ally(a,b)||a==b)return false;
  local h=this.heal(b,25),r=this.recover(b,18),c=this.combat().cleanse(b);this.support(a,b,h||r||c);return true;
 }
 function gift(a,b){
  if(!this.combat().ally(a,b)||a==b)return false;
  this.ensure(b);this.write(b,"gift.ticks",2);this.write(b,"gift.active",1);this.support(a,b,true);this.refresh(b);return true;
 }
 function startTurn(a){
  if(!this.alive(a)||!this.api().FiveValkyries.normal(a)||this.read(a,"last_round",-1)==this.round())return;
  this.write(a,"last_round",this.round());this.write(a,"turns",this.read(a,"turns")+1);this.write(a,"turn_active",1);
  if(this.read(a,"burn.ticks")>0){
   this.write(a,"burn.ticks",this.read(a,"burn.ticks")-1);
   if(this.canBurn(a)){
    local source=::Tactical.getEntityByID(this.read(a,"burn.source")),effect=a.getSkills().getSkillByID("$bvvar{modId}.effects.trails_state");
    if(source!=null)this.api().applyValkyrieFixedHitpointDamage(source,effect,a,8);
    else {local hit=clone ::Const.Tactical.HitInfo;hit.DamageRegular=8;hit.DamageArmor=0;hit.DamageDirect=1.0;hit.DamageFatigue=0;hit.BodyPart=::Const.BodyPart.Body;a.onDamageReceived(null,effect,hit);}
   }else this.write(a,"burn.ticks",0);
  }
  if(!this.alive(a))return;
  if(this.read(a,"gift.ticks")>0){this.write(a,"gift.ticks",this.read(a,"gift.ticks")-1);this.heal(a,10);this.recover(a,6);}
  this.refresh(a);
 }
 function endTurn(a){
  if(!this.alive(a)||!this.api().FiveValkyries.normal(a)||this.read(a,"turn_active")==0)return;
  this.write(a,"turn_active",0);
  if(this.read(a,"gift.ticks")==0)this.write(a,"gift.active",0);
  if(this.read(a,"turns")>=this.read(a,"step.until"))this.write(a,"step.active",0);this.refresh(a);
 }
 function reset(a){
  foreach(id in this.owners(a))foreach(k in ["count","until","action","detonation"])this.write(a,"mark."+id+"."+k,k=="action"||k=="detonation"?"":0);
  this.write(a,"mark.owners","");
  foreach(k in ["radiance","burn.ticks","burn.source","gift.ticks","gift.active","step.active","step.until","turns","turn_active"])this.write(a,k,0);
  this.write(a,"last_round",-1);
  foreach(key,d in this.api().ValkyrieSkillCatalog)if(key.find("renne_")==0||key.find("alisa_")==0){this.write(a,"cd."+key,0);this.write(a,"action."+key,"");}
 }
 function restore(a){
  if(this.read(a,"mark.owners","")!=""||this.read(a,"radiance")>0||this.read(a,"burn.ticks")>0||this.read(a,"gift.active")>0||this.read(a,"step.active")>0)this.ensure(a);
 }
};
::$bvvar{namespace}.finalizeTrailsDuoProperties <- function(a,s,b,p){return this.TrailsDuo.properties(a,s,b,p);};
