// Fixed starting equipment. Ownership flags are durable; guard/cooldown live on the actor for this combat.
::$bvvar{namespace}.RachelEquipment <- {
 SkillKey = "rachel_alucard_parasol_guard",
 SkillOwner = "rachel_nago_parasol",
 GuardEffectKey = "rachel_alucard_parasol_guard_effect",
 BackSprite = "bv_rachel_parasol_back",
 ParasolBrush = "icon_bv_rachel_nago_parasol",
 function hideAppearance(a)
 {
  if(a.hasSprite(this.BackSprite))
  {
   local back=a.getSprite(this.BackSprite);
   if(back.Visible||back.HasBrush){back.Visible=false;back.setBrush("");a.setDirty(true);}
  }
 },
 function syncAppearance(a)
 {
  if(!a.hasSprite("arms_icon"))return;
  local bv=::$bvvar{namespace},front=a.getSprite("arms_icon");
  // Retain the native main-hand brush as the source of rotation and appearance.
  // Visible cannot be used here: we deliberately suppress that foreground copy.
  if(!front.HasBrush||front.getBrush().Name!=this.ParasolBrush)
  {this.hideAppearance(a);return;}
  local item=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
  if(bv.isActorDeadOrDying(a)||bv.getSettingValue("HideWeapons")
   ||!a.getCurrentProperties().IsAbleToUseWeaponSkills||item==null||item.getID()!=this.Items[0].ID)
  {front.Visible=false;this.hideAppearance(a);return;}
  // Native insect_swarm_effect uses insertSprite for sprites behind the pawn.
  local back=a.hasSprite(this.BackSprite)?a.getSprite(this.BackSprite):a.insertSprite(this.BackSprite);
  if(!back.HasBrush||back.getBrush().Name!=this.ParasolBrush)back.setBrush(this.ParasolBrush);
  back.Visible=true;back.Rotation=front.Rotation;back.Scale=front.Scale;
  back.Alpha=front.Alpha;back.Color=front.Color;
  back.setHorizontalFlipping(!a.isAlliedWithPlayer());
  a.setSpriteOffset(this.BackSprite,a.getSpriteOffset("arms_icon"));
  front.Visible=false;a.setDirty(true);
 },
 Items = [
  {Key="parasol", Script="scripts/items/weapons/battle_valkyries/rachel_nago_parasol", ID="$bvvar{modId}.weapon.rachel_nago_parasol", Slot=::Const.ItemSlot.Mainhand},
  {Key="dress", Script="scripts/items/armor/battle_valkyries/rachel_crimson_dress", ID="$bvvar{modId}.armor.rachel_crimson_dress", Slot=::Const.ItemSlot.Body},
  {Key="ribbons", Script="scripts/items/helmets/battle_valkyries/rachel_black_ribbons", ID="$bvvar{modId}.helmet.rachel_black_ribbons", Slot=::Const.ItemSlot.Head}
 ],
 function hasParasol(a)
 {
  if(!::$bvvar{namespace}.Rachel.owns(a))return false;
  local item=a.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
  return item!=null&&item.getID()==this.Items[0].ID;
 },
 function sync(a)
 {
  local bv=::$bvvar{namespace};
  if(this.hasParasol(a))
  {
   local result=bv.attachTransientSkill(a,this.SkillKey,this.SkillOwner);
   if(!result.Success)throw "[Battle Valkyries] Rachel parasol skill attach failed: "+result.Code;
  }
  else
  {
   bv.detachTransientSkill(a,this.SkillKey,this.SkillOwner);
   this.clearGuard(a);
  }
  local s=bv.Rachel.state(a);
  if(s!=null&&s.Active&&s.ParasolGuard)this.showGuard(a);
  else bv.detachTransientSkill(a,this.GuardEffectKey,this.SkillOwner);
 },
 function showGuard(a)
 {
  local result=::$bvvar{namespace}.attachTransientSkill(a,this.GuardEffectKey,this.SkillOwner);
  if(!result.Success)throw "[Battle Valkyries] Rachel guard status attach failed: "+result.Code;
 },
 function clearGuard(a)
 {
  local s=::$bvvar{namespace}.Rachel.state(a);
  if(s!=null){s.ParasolGuard=false;s.ParasolPending=null;}
  ::$bvvar{namespace}.detachTransientSkill(a,this.GuardEffectKey,this.SkillOwner);
 },
 function ready(a)
 {
  local f=::$bvvar{namespace}.Rachel,s=f.state(a);
  return this.hasParasol(a)&&f.able(a)&&s!=null&&s.Active&&!s.ParasolGuard&&s.Turn>=s.ParasolReady;
 },
 function protect(a)
 {
  if(!this.ready(a))return false;
  local s=::$bvvar{namespace}.Rachel.state(a);
  this.showGuard(a);
  s.ParasolGuard=true;s.ParasolReady=s.Turn+2;s.ParasolPending=null;a.setDirty(true);return true;
 },
 function beforeDamage(a,attacker,skill,hit,p)
 {
  local bv=::$bvvar{namespace},s=bv.Rachel.state(a);
  if(s==null||!s.Active||!s.ParasolGuard||!this.hasParasol(a)||attacker==null
   ||a.isAlliedWith(attacker)||!bv.isDirectAttack(skill)||hit==null
   ||(hit.DamageRegular<=0&&hit.DamageArmor<=0))return;
  // A live attempt distinguishes native damage delivery from property/tooltip previews.
  local attempt=bv.findValkyrieTargetAttempt(attacker,skill,a);
  if(attempt==null||bv.getValkyrieFixedDamageFrameForHit(hit,a,attacker,skill)!=null)return;
  local source=bv.getCurrentValkyrieCombatSource(attacker,skill);
  if(source!=null&&(source.Source=="dot"||source.Source=="damage_over_time"||source.Source=="terrain"||source.Source=="reflection"))return;
  p.DamageReceivedRegularMult*=0.5;p.DamageReceivedArmorMult*=0.5;
  s.ParasolPending={Attempt=attempt.AttemptID,Attacker=attacker.getID(),Skill=skill};
 },
 function resolveDamage(a,e)
 {
  local s=::$bvvar{namespace}.Rachel.state(a);
  if(s==null||s.ParasolPending==null||e==null||e.Type!="DamageResolved"
   ||e.Victim==null||e.Victim.getID()!=a.getID())return false;
  local pending=s.ParasolPending;
  if(e.AttemptToken!=pending.Attempt||e.Attacker==null||e.Attacker.getID()!=pending.Attacker||e.Skill!=pending.Skill)return false;
  s.ParasolPending=null;
  if(e.HitpointDamage+e.ArmorDamage<=0)return false;
  this.clearGuard(a);a.setDirty(true);return true;
 },
 function grantFlag(d){return "BVRachelStartingEquipment."+d.Key;},
 function ownerKey(a)
 {
  local key=::$bvvar{namespace}.getActorFlagString(a,"BVRachelEquipmentOwner");
  if(key==null){key="rachel:"+a.getID();a.getFlags().set("BVRachelEquipmentOwner",key);}
  return key;
 },
 function create(a,d)
 {
  local item=::new(d.Script);item.m.RachelOwner=this.ownerKey(a);return item;
 },
 function equipStarter(a)
 {
  foreach(d in this.Items)
  {
   if(!a.getItems().equip(this.create(a,d)))throw "[Battle Valkyries] Rachel starter equip failed: "+d.Key;
   a.getFlags().set(this.grantFlag(d),true);
  }
 },
 // After world loading only: old saves get one set in the stash, without replacing worn gear.
 function backfill()
 {
  local bv=::$bvvar{namespace};
  if(!("World" in getroottable())||::World==null||::World.Assets==null)return;
  local roster=::World.getPlayerRoster(),stash=::World.Assets.getStash();
  if(roster==null||stash==null)return;
  local all=clone stash.getItems();
  foreach(a in roster.getAll())foreach(item in a.getItems().getAllItems())if(item!=null)all.push(item);
  foreach(a in roster.getAll())
  {
   if(!bv.Rachel.owns(a)||bv.isActorDeadOrDying(a))continue;
   foreach(d in this.Items)
   {
    if(a.getFlags().get(this.grantFlag(d))==true)continue;
    local exists=false,key=this.ownerKey(a);
    foreach(item in all)if(item!=null&&item.getID()==d.ID&&"RachelOwner" in item.m&&item.m.RachelOwner==key){exists=true;break;}
    if(exists){a.getFlags().set(this.grantFlag(d),true);continue;}
    if(!stash.isResizable()&&stash.getNumberOfEmptySlots()<=0)continue;
    local item=this.create(a,d),slot=stash.add(item);
    if(slot==null||slot==-1)continue;
    all.push(item);a.getFlags().set(this.grantFlag(d),true);
   }
  }
 }
};
