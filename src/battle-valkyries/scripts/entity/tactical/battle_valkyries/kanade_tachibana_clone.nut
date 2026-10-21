// A tactical-only actor: no roster entry, persistent identity, equipment or learned perks.
this.kanade_tachibana_clone <- this.inherit("scripts/entity/tactical/actor", {
 m={KanadeClone=true,KanadeOwnerRef=null,KanadeExpire=0,KanadeDismissed=false,KanadeWeapon=null,KanadePierceUpgrade=false,KanadeTurnRound=-1,KanadeBrush="bust_bv_kanade_tachibana_skin"},
 function create()
 {
  this.m.Type=this.Const.EntityType.Warhound;this.m.Name="$bv{kanade.clone.name}";this.m.BloodType=this.Const.BloodType.None;this.m.XP=0;
  this.m.IsActingImmediately=true;this.m.IsControlledByPlayer=true;this.actor.create();
  this.m.AIAgent=this.new("scripts/ai/tactical/player_agent");this.m.AIAgent.setActor(this);
 },
 function onInit()
 {
  this.actor.onInit();this.m.ActionPointCosts=this.Const.DefaultMovementAPCost;this.m.FatigueCosts=this.Const.DefaultMovementFatigueCost;
  this.addSprite("socket").setBrush("bust_base_player");this.addSprite("body").setBrush(this.m.KanadeBrush);
  foreach(name in ["armor","head","helmet","injury","closed_eyes"])this.addSprite(name).Visible=false;
  this.addDefaultStatusSprites();this.m.BaseProperties.IsAffectedByDyingAllies=false;this.m.BaseProperties.IsAffectedByLosingHitpoints=false;
  this.m.BaseProperties.IsAffectedByInjuries=false;this.m.BaseProperties.IsAffectedByFreshInjuries=false;
 },
 function configure(owner,expires)
 {
  local k=::$bvvar{namespace}.Kanade,p=owner.getCurrentProperties(),b=this.m.BaseProperties;
  this.m.KanadeOwnerRef=k.api().makeValkyrieCombatWeakRef(owner);this.m.KanadeExpire=expires;
  this.m.KanadeWeapon={};this.m.KanadePierceUpgrade=k.gear(owner,"hand_sonic",true)!=null;
  b.MeleeSkill=p.getMeleeSkill();b.RangedSkill=p.getRangedSkill();b.MeleeDefense=p.getMeleeDefense();b.RangedDefense=p.getRangedDefense();
  b.Bravery=p.getBravery();b.Stamina=owner.getFatigueMax();b.Initiative=p.getInitiative();
  b.ActionPoints=6;b.Hitpoints=::Math.max(1,::Math.floor(owner.getHitpointsMax()*0.60));
  b.DamageRegularMin=p.DamageRegularMin;b.DamageRegularMax=p.DamageRegularMax;
  b.DamageRegularMult=p.DamageRegularMult;b.DamageArmorMult=p.DamageArmorMult;
  b.DamageTotalMult=p.DamageTotalMult*p.MeleeDamageMult*0.60;b.MeleeDamageMult=1.0;
  b.DamageDirectMult=p.DamageDirectMult;b.DamageDirectAdd=p.DamageDirectAdd;b.DamageDirectMeleeAdd=p.DamageDirectMeleeAdd;
  foreach(part in [this.Const.BodyPart.Head,this.Const.BodyPart.Body]){b.Armor[part]=::Math.floor(owner.getArmor(part)*0.60);b.ArmorMax[part]=b.Armor[part];}
  this.m.CurrentProperties=clone b;this.m.Hitpoints=b.Hitpoints;this.m.ActionPoints=6;this.m.Fatigue=0;
  this.setFaction(this.Const.Faction.Player);this.m.IsControlledByPlayer=true;
  local skin=k.api().getSkin(owner.getFlags().get(k.api().ValkyrieSkinIDFlag));if(skin!=null)this.m.KanadeBrush=skin.Brush;
  foreach(key in ["kanade_overdrive","kanade_hand_sonic_slash","kanade_hand_sonic_pierce","kanade_hand_sonic_sweep","kanade_delay"])
  {
   local result=k.api().createValkyrieRuntimeSkill(this,key);if(!result.Success)throw "Cannot bind clone skill "+key;this.getSkills().add(result.RuntimeSkill);
  }
  k.start(this);this.applyAppearance();this.getSkills().update();this.setDirty(true);
 },
 function applyAppearance()
 {
  if(!this.hasSprite("body"))return;local body=this.getSprite("body");body.setBrush(this.m.KanadeBrush);body.Alpha=190;body.Visible=true;body.setHorizontalFlipping(false);
  this.Tactical.addResource(body.getBrush().TextureName);this.m.Items.getAppearance().Body=this.m.KanadeBrush;
  foreach(name in ["armor","head","helmet","injury","closed_eyes","shield_icon","quiver"])if(this.hasSprite(name))this.getSprite(name).Visible=false;
  // A visual copy only: the tactical clone never receives a serialized item.
  if(this.hasSprite("arms_icon"))
  {
   local arms=this.getSprite("arms_icon"),visible=this.m.KanadeWeapon!=null&&!::$bvvar{namespace}.getSettingValue("HideWeapons");
   arms.setBrush(visible?"icon_bv_kanade_hand_sonic":"");arms.Visible=visible;arms.Alpha=190;arms.setHorizontalFlipping(false);
   if(visible)this.Tactical.addResource(arms.getBrush().TextureName);
  }
 },
 function onAppearanceChanged(appearance,dirty=true){this.actor.onAppearanceChanged(appearance,false);this.applyAppearance();if(dirty)this.setDirty(true);},
 function onPlacedOnMap(){this.actor.onPlacedOnMap();this.applyAppearance();},
 // Quick-swap UI mods query every controlled actor, including equipment-free summons.
 function querySwitchableItems(){return [];},
 function onTurnStart()
 {
  local k=::$bvvar{namespace}.Kanade;if(!k.alive(k.owner(this))){k.dismiss(this,false);return;}
  local round=::Time.getRound();if(this.m.KanadeTurnRound==round||!k.api().EightValkyries.normal(this)){this.m.ActionPoints=0;this.m.IsTurnDone=true;return;}
  this.m.KanadeTurnRound=round;this.actor.onTurnStart();
 },
 function addXP(amount,scale=true){local a=::$bvvar{namespace}.Kanade.owner(this);if(a!=null&&!::$bvvar{namespace}.isActorDeadOrDying(a))a.addXP(amount,scale);},
 function onActorKilled(victim,tile,skill)
 {
  // Credit experience without invoking the owner's kill perks or bond counters.
  local xp=victim.getXPValue();this.addXP(::Math.floor(xp*this.Const.XP.XPForKillerPct));
  local allies=[];foreach(a in this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player))if(a.isAlive()&&!a.isDying()&&!("KanadeMissionUnit" in a.m))allies.push(a);
  if(allies.len()>0)foreach(a in allies)a.addXP(::Math.max(1,::Math.floor(xp*(1.0-this.Const.XP.XPForKillerPct)/allies.len())));
 },
 function kill(killer=null,skill=null,fatalityType=this.Const.FatalityType.None){::$bvvar{namespace}.Kanade.dismiss(this,false);},
 function retreat(){::$bvvar{namespace}.Kanade.dismiss(this,false);},
 function onDeath(killer,skill,tile,fatalityType){::$bvvar{namespace}.Kanade.dismiss(this,false);},
 function onSerialize(out){throw "[Battle Valkyries] Tactical Harmonics clone must not enter a roster save";}
});
