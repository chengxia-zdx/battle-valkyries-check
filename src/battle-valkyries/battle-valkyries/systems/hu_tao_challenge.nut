// Personal bond encounters, not Hub chapters. Retried camps create a fresh ledger.
::$bvvar{namespace}.HuTaoChallenge <- {
 Battle=null,
 function f(){return ::$bvvar{namespace}.HuTao;},
 function prepare(stage){this.Battle={Stage=stage,Initialized=false,Busy=false,Failed=false,Finished=false,ReminderShown=false,Nodes=[],Boss=null,Lamp=null,Wave=1,WaveDue=-1,SpawnTiles=[],Faction=0,Players=[]};},
 function all(){local out=[];foreach(group in ::Tactical.Entities.getAllInstances())foreach(a in group)if(this.f().alive(a))out.push(a);return out;},
 function enemies(){local out=[];foreach(a in this.all())if(!a.isAlliedWithPlayer()&&!a.isNonCombatant())out.push(a);return out;},
 function spots(center,radius)
 {
  local queue=[center],seen={},out=[];seen[center.ID]<-true;
  for(local i=0;i<queue.len();i++)for(local d=0;d<6;d++)if(queue[i].hasNextTile(d))
  {
   local t=queue[i].getNextTile(d);if(t.ID in seen||center.getDistanceTo(t)>radius)continue;
   seen[t.ID]<-true;
   if(::Math.abs(queue[i].Level-t.Level)>1||(!t.IsEmpty&&!t.IsOccupiedByActor))continue;
   queue.push(t);if(t.IsEmpty)out.push(t);
  }
  return out;
 },
 function initialize()
 {
  local b=this.Battle;if(b==null||b.Initialized||b.Busy)return;
  b.Busy=true;local players=::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player),enemies=this.enemies();
  if(players.len()==0||enemies.len()==0){b.Busy=false;return;}
  b.Initialized=true;b.Faction=enemies[0].getFaction();
  try
  {
   if(b.Stage==60||b.Stage==80)
   {
    // Prefer spread-out reachable empty tiles beside the hostile line.
    local candidates=this.spots(enemies[0].getTile(),7);
    foreach(t in candidates)
    {
     local separated=true;foreach(n in b.Nodes)if(n.Tile.getDistanceTo(t)<3)separated=false;
     if(!separated)continue;
     local mark=t.spawnDetail("effect_bv_hu_tao_blood_blossom",::Const.Tactical.DetailFlag.None,false,true);
     b.Nodes.push({Tile=t,Mark=mark,Released=false});if(b.Nodes.len()==3)break;
    }
    if(b.Nodes.len()!=3)throw "No three reachable Hu Tao ritual nodes";
    foreach(a in players)
    {
     if(!a.isPlayerControlled()||a.isNonCombatant())continue;
     local result=this.f().api().attachTransientSkill(a,"hu_tao_unbind","hu_tao.bond.challenge");
     if(!result.Success)throw "Hu Tao interaction binding failed";
     b.Players.push(this.f().api().makeValkyrieCombatWeakRef(a));
    }
    ::Tactical.EventLog.logEx("$bv{hu_tao.challenge.instructions}");
    ::Tactical.EventLog.logEx(this.progress());
    if(b.Stage==80)
    {
     local boss=enemies[0];foreach(a in enemies)if(a.getArmor(::Const.BodyPart.Body)>boss.getArmor(::Const.BodyPart.Body))boss=a;
     b.Boss=this.f().api().makeValkyrieCombatWeakRef(boss);
     boss.m.BaseProperties.Armor[::Const.BodyPart.Body]+=150;boss.m.BaseProperties.ArmorMax[::Const.BodyPart.Body]+=150;boss.getSkills().update();
    }
   }
   if(b.Stage==100)
   {
    local places=this.spots(players[0].getTile(),3);if(places.len()==0)throw "No legal homecoming lamp tile";
    local t=places[0],lamp=::Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/hu_tao_homecoming_lamp",t.Coords.X,t.Coords.Y);
    if(lamp==null)throw "Homecoming lamp creation failed";
    lamp.setFaction(::Const.Faction.PlayerAnimals);b.Lamp=this.f().api().makeValkyrieCombatWeakRef(lamp);
    local candidates=this.spots(enemies[0].getTile(),7);
    foreach(t in candidates)
    {
     b.SpawnTiles.push(t);t.spawnDetail("effect_bv_hu_tao_blood_blossom",::Const.Tactical.DetailFlag.None,false,true);
     if(b.SpawnTiles.len()>=12)break;
    }
    if(b.SpawnTiles.len()<6)throw "Insufficient reinforcement tiles";
   }
  }
  catch(e){b.Failed=true;::logWarning("[Battle Valkyries] Hu Tao encounter: "+e);}
  b.Busy=false;
 },
 function node(tile){local b=this.Battle;if(b==null||b.Failed||!b.Initialized)return null;foreach(n in b.Nodes)if(!n.Released&&n.Tile.ID==tile.ID)return n;return null;},
 function remaining()
 {
  local count=0;
  if(this.Battle!=null){foreach(n in this.Battle.Nodes){if(!n.Released)count++;}}
  return count;
 },
 function progress(){return ::format("$bv{hu_tao.challenge.progress}",this.Battle==null?0:this.Battle.Nodes.len()-this.remaining(),this.Battle==null?0:this.Battle.Nodes.len());},
 function tileInfo(tile)
 {
  if(tile==null||!tile.IsDiscovered||this.node(tile)==null)return [];
  return [{id=860,type="text",icon="skills/$bvvar{iconPrefix}/hu_tao_blood_blossom.png",text="$bv{hu_tao.challenge.node}"},
   {id=861,type="text",icon="ui/icons/special.png",text="$bv{hu_tao.challenge.instructions}"},
   {id=862,type="text",icon="ui/icons/special.png",text=this.progress()}];
 },
 function release(a,tile)
 {
  local n=this.node(tile),b=this.Battle;if(n==null||!this.f().api().EightValkyries.able(a)||a.getTile().getDistanceTo(tile)!=1||::Math.abs(a.getTile().Level-tile.Level)>1)return false;
  n.Released=true;if(n.Mark!=null){n.Mark.Visible=false;n.Mark.Alpha=0;}
  local boss=this.f().api().readValkyrieCombatWeakRef(b.Boss);
  if(b.Stage==80&&this.f().alive(boss))
  {
   local p=boss.m.BaseProperties,part=::Const.BodyPart.Body;
   p.Armor[part]=::Math.max(0,p.Armor[part]-50);p.ArmorMax[part]=::Math.max(0,p.ArmorMax[part]-50);boss.getSkills().update();boss.setDirty(true);
  }
  this.f().visual(tile,"spirit_soother");::Tactical.EventLog.logEx(this.progress());return true;
 },
 function round()
 {
  this.initialize();local b=this.Battle;if(b==null||!b.Initialized||b.Failed||b.Busy||b.Stage!=100||b.Wave!=1||b.WaveDue<0||::Time.getRound()<b.WaveDue)return;
  local free=[];foreach(t in b.SpawnTiles)if(t.IsEmpty)free.push(t);
  // Occupied warnings never overwrite an actor. Search nearby legal spaces.
  if(free.len()<6&&b.SpawnTiles.len()>0)foreach(t in this.spots(b.SpawnTiles[0],12))if(free.find(t)==null)free.push(t);
  if(free.len()<6)return;
  b.Busy=true;local created=[];
  try
  {
   foreach(i,key in ["ZombieYeoman","ZombieYeoman","ZombieYeoman","Ghost","Ghost","Necromancer"])
   {
    local d=::Const.World.Spawn.Troops[key],t=free[i],a=::Tactical.spawnEntity(d.Script,t.Coords.X,t.Coords.Y);
    if(a==null)throw "Reinforcement spawn failed";
    created.push(a);a.setFaction(b.Faction);a.assignRandomEquipment();
    if(key=="Necromancer"){a.m.BaseProperties.Hitpoints+=40;a.getSkills().update();a.setHitpoints(a.getHitpointsMax());}
    ::Tactical.TurnSequenceBar.addEntity(a);
   }
   b.Wave=2;
  }
  catch(e){b.Failed=true;::logWarning("[Battle Valkyries] Hu Tao reinforcement failure: "+e);}
  b.Busy=false;
 },
 function holdVictory(force)
 {
  local b=this.Battle;if(b==null||!b.Initialized||b.Failed||b.Finished||force||::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player).len()==0)return false;
  if(b.Stage==60&&this.remaining()>0&&this.enemies().len()==0)
  {
   if(!b.ReminderShown){b.ReminderShown=true;::Tactical.EventLog.logEx("$bv{hu_tao.challenge.enemies_cleared}");::Tactical.EventLog.logEx(this.progress());}
   return true;
  }
  if(b.Stage==100&&b.Wave==1&&this.enemies().len()==0)
  {
   if(b.WaveDue<0){b.WaveDue=::Time.getRound()+1;::Tactical.EventLog.logEx("$bv{hu_tao.challenge.wave}");}
   return true;
  }
  return false;
 },
 function objectivesMet(stage)
 {
  if(stage<60)return true;local b=this.Battle;if(b==null||b.Stage!=stage||!b.Initialized||b.Failed)return false;
  if(stage==60){foreach(n in b.Nodes)if(!n.Released)return false;return true;}
  if(stage==80||b.Finished)return true;
  local lamp=this.f().api().readValkyrieCombatWeakRef(b.Lamp);return b.Wave==2&&lamp!=null&&!this.f().api().isActorDeadOrDying(lamp);
 },
 function end()
 {
  local b=this.Battle;if(b==null)return;
  // Store the outcome before native removal of tactical-only actors.
  b.Failed=b.Failed||!this.objectivesMet(b.Stage);b.Finished=true;
  foreach(ref in b.Players){local a=this.f().api().readValkyrieCombatWeakRef(ref);if(a!=null)this.f().api().detachTransientSkill(a,"hu_tao_unbind","hu_tao.bond.challenge");}
 }
};
