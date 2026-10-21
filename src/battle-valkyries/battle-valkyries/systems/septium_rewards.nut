// Finite item deliveries have individual world ledgers. Full stashes defer, never discard.
local bv=::$bvvar{namespace},c=bv.Chapters;
bv.TrailsOrbmentGrants <- {shizuna="twinwing",renne="renne_aster",alisa="alisa_blazing_wing"};
bv.Orbments.storyBusy <- false;
bv.Orbments.make <- function(form){return ::new("scripts/items/accessory/battle_valkyries/orbment_item").configure(form);};
bv.Orbments.makeTrailsStarter <- function(id){
 local it=this.make(this.api().TrailsOrbmentGrants[id]);
 if("TrailsStarterConfigs" in this.api() && id in this.api().TrailsStarterConfigs){
  local d=this.api().TrailsStarterConfigs[id],config=this.blank();
  config.Slots=clone d.Slots;config.Active=clone d.Active;config.Passive=clone d.Passive;
  if(!this.validConfig(d.Form,config))throw "Invalid Trails starter circuit: "+id;
  this.writeItem(it,config);
 }
 return it;
};
// Called inside roster construction: failure removes the incomplete actor, without spending the world grant.
bv.Orbments.prepareTrailsRecruit <- function(actor){
 local id=this.api().getActorValkyrieID(actor),flag="$bvvar{modId}.orbment.trails."+id;
 if(::World.Flags.has(flag) && ::World.Flags.get(flag)==1)return;
 if(!actor.getItems().equip(this.makeTrailsStarter(id)))throw "Failed to equip Trails starter orbment";
 actor.getFlags().set("$bvvar{modId}.orbment.trails_pending",true);
};
bv.Orbments.starReader <- function(){
 local it=this.make("star_reader"),config=this.blank();
 config.Slots=["clearflow:1","clearflow:1","brightsky:1","brightsky:1","phantomeye:1","phantomeye:1","starcut:1"];
 config.Active=["orbment_healing_drop","orbment_space_barrier","orbment_phantom_noise"];
 config.Passive=["orbment_vitality","orbment_far_guard","orbment_composure"];
 this.writeItem(it,config);return it;
};
bv.Orbments.trailsAward <- function(actor){
 if(actor==null || !this.safe())return;
 local id=this.api().getActorValkyrieID(actor);
 if(!(id in this.api().TrailsOrbmentGrants))return;
 local flag="$bvvar{modId}.orbment.trails."+id;
 if(::World.Flags.has(flag) && ::World.Flags.get(flag)==1)return;
 // Finalize only after successful recruitment. A retry recognizes the already delivered item.
 if(actor.getFlags().has("$bvvar{modId}.orbment.trails_pending") && actor.getFlags().get("$bvvar{modId}.orbment.trails_pending")){
  ::World.Flags.set(flag,1);actor.getFlags().set("$bvvar{modId}.orbment.trails_pending",false);return;
 }
 local it=this.makeTrailsStarter(id),equipped=false,added=false;
 try {
  if(actor.getItems().getItemAtSlot(::Const.ItemSlot.Accessory)==null)equipped=actor.getItems().equip(it);
  if(!equipped)added=this.stash().add(it)!=null;
  if(!equipped&&!added)return;
  ::World.Flags.set(flag,1);
 }catch(e){if(equipped)actor.getItems().unequip(it);if(added)this.stash().remove(it);throw e;}
};
bv.Orbments.syncTrails <- function(){
 if(!this.safe())return;
 foreach(a in ::World.getPlayerRoster().getAll())if(a!=null && !this.api().isActorDeadOrDying(a))this.trailsAward(a);
};
bv.Orbments.storyRewards <- function(){
 local c=this.api().Chapters,id="septium_workshop";
 if(this.storyBusy || !this.safe() || c.completed(id)<8)return;
 this.storyBusy=true;
 try {
  if(c.read(id,"recruit_delivered.tio")!=1){
   local actor=c.actor("tio"),created=false;
   if(actor==null){
    if(this.api().isValkyrieSummonRosterFull()){this.storyBusy=false;return;}
    local result=this.api().createValkyrieRosterActor("tio",getroottable(),{ChargeCrowns=false,HireReason="chapter:septium_workshop",FormationPolicy="summon"});
    if(!result.Success || result.Actor==null)throw "Tio construction failed";
    actor=result.Actor;created=true;
   }
   local items=[],stashItems=[];
   try {
    foreach(it in [this.starReader(),::new("scripts/items/weapons/battle_valkyries/tio_orbal_staff"),::new("scripts/items/armor/padded_surcoat")]){
     if(actor.getItems().getItemAtSlot(it.getSlotType())==null && actor.getItems().equip(it))items.push(it);
     else {if(this.stash().add(it)==null)throw "Tio starter equipment pending";stashItems.push(it);}
    }
    local synced=this.api().syncActorSkills(actor,"septium.recruit");
    if(synced==null || !synced.Success)throw "Tio skill initialization pending";
    c.write(id,"recruit_delivered.tio",1);
   }catch(e){
    foreach(it in items)actor.getItems().unequip(it);foreach(it in stashItems)this.stash().remove(it);
    if(created)::World.getPlayerRoster().remove(actor);throw e;
   }
  }
  local rewards=["form:starrail","form:twinwing","form:triskelion"];
  foreach(key in ["rockheart","clearflow","redblade","swiftwind","timesand","brightsky","phantomeye"])for(local n=0;n<3;n++)rewards.push(key+":1");
  foreach(index,code in rewards){
   local key="item_delivered."+index;if(c.read(id,key)==1)continue;
   if(!this.stash().isResizable() && this.stash().getNumberOfEmptySlots()<=0)break;
   local it=code.find("form:")==0?this.make(code.slice(5)):this.quartz(code);
   if(this.stash().add(it)==null)break;
   try {c.write(id,key,1);}catch(e){this.stash().remove(it);throw e;}
  }
 }catch(e){::logWarning("[Battle Valkyries] Septium rewards pending: "+e);}
 this.storyBusy=false;
};
local originalRewards=c.syncRewards;
c.syncRewards=function(id){originalRewards.call(this,id);if(id=="septium_workshop")::$bvvar{namespace}.Orbments.storyRewards();};
local originalDTO=c.dto;
c.dto=function(id){
 local result=originalDTO.call(this,id);if(id!="septium_workshop" || result==null)return result;
 local pending=this.completed(id)>=8 && this.read(id,"recruit_delivered.tio")!=1;
 local count=0;if(this.completed(id)>=8)for(local n=0;n<24;n++)if(this.read(id,"item_delivered."+n)!=1)count++;
 result.PendingRecruit<-pending||count>0;
 result.PendingRecruitMessage<-"$bv{orbment.pending_reward}"+" "+count;
 return result;
};
local originalCards=c.cards;
c.cards=function(){::$bvvar{namespace}.Orbments.syncTrails();return originalCards.call(this);};
