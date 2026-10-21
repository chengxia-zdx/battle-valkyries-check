::$bvvar{namespace}.KanadeMissions <- {
 Battle=null,Initializing=false,
 function k(){return ::$bvvar{namespace}.Kanade;},
 function reset(){this.Battle=null;this.Initializing=false;},
 function alive(a){return this.k().alive(a);},
 function units(kind=null)
 {
  local out=[];if(this.Battle==null)return out;
  foreach(ref in this.Battle.Units){local a=this.k().api().readValkyrieCombatWeakRef(ref);if(this.alive(a)&&(kind==null||a.m.KanadeKind==kind))out.push(a);}
 return out;
 },
 function freeTiles(origin,minRange,maxRange)
 {
  local size=::Tactical.getMapSize(),out=[];
  for(local x=0;x<size.X;x++)for(local y=0;y<size.Y;y++)if(::Tactical.isValidTileSquare(x,y))
  {local t=::Tactical.getTileSquare(x,y),d=origin.getDistanceTo(t);if(t.IsEmpty&&d>=minRange&&d<=maxRange&&::Math.abs(t.Level-origin.Level)<=1)out.push(t);}
  out.sort(function(a,b){local da=origin.getDistanceTo(a),db=origin.getDistanceTo(b);return da==db?(a.ID<b.ID?-1:1):(da<db?-1:1);});return out;
 },
 function spawnUnit(kind,origin,faction)
 {
  local tiles=this.freeTiles(origin,1,7);if(tiles.len()==0)throw "No legal Kanade mission objective tile";
  local t=tiles[0],a=::Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/kanade_tachibana_mission_unit",t.Coords.X,t.Coords.Y);
  if(a==null)throw "Kanade objective spawn failed";a.configure(kind,faction);this.Battle.Units.push(this.k().api().makeValkyrieCombatWeakRef(a));return a;
 },
 function spawnEcho(origin,overload=false,terminal=false)
 {
  local tiles=this.freeTiles(origin,1,6);if(tiles.len()==0)return null;
  local t=tiles[0],a=::Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/kanade_tachibana_echo",t.Coords.X,t.Coords.Y);
  if(a==null)return null;a.configure(this.Battle.Faction,overload,terminal);return a;
 },
 function initialize()
 {
  if(this.Battle!=null||this.Initializing||!("Tactical" in getroottable())||::Tactical.State==null)return;
  local props=::Tactical.State.getStrategicProperties();if(props==null||!("Parties" in props))return;
  local location=null,entry=null;
  foreach(p in props.Parties)
  {
   local candidate=::$bvvar{namespace}.KanadeBond.campStage(p);
   if(candidate!=null){location=p;entry=candidate;break;}
  }
  if(location==null)return;
  local players=::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player),enemies=::Tactical.Entities.getAllHostilesAsArray();
  if(players.len()==0||enemies.len()==0)return;
  this.Initializing=true;
  this.Battle={Location=this.k().api().makeValkyrieCombatWeakRef(location),Stage=entry.Value,Faction=enemies[0].getFaction(),Units=[],StartRound=::Time.getRound(),LastRound=::Time.getRound(),Boss=false,Reinforcements=0,Failed=false,Done=false};
  location.getFlags().set("BVKanadeObjectiveWon",false);
  try
  {
   local stage=this.Battle.Stage,origin=players[0].getTile(),enemyOrigin=enemies[0].getTile();
   if(stage==20)for(local i=0;i<3;i++)this.spawnUnit("cart",origin,::Const.Faction.PlayerAnimals);
   // Stages 40 and 80 are elimination battles; rescues remain narrative-only.
   if(stage==60||stage==100)for(local i=0;i<3;i++)this.spawnUnit(stage==60?"node":"anchor",enemyOrigin,this.Battle.Faction);
   if(stage==100){if(this.spawnEcho(enemyOrigin,false,true)==null)throw "No terminal tile";this.Battle.Boss=true;}
   ::Tactical.EventLog.log("$bv{kanade.mission.started}"+::$bvvar{namespace}.KanadeBond.stage(stage).LocationDescription);
  }
  catch(e){this.Battle.Failed=true;::logWarning("[Battle Valkyries] Kanade mission setup failed: "+e);}
  this.Initializing=false;
 },
 function tick()
 {
  this.initialize();local b=this.Battle;if(b==null||b.Done||b.Failed)return;
  this.refresh();local round=::Time.getRound();if(round==b.LastRound)return;b.LastRound=round;
  if(b.Stage==60)foreach(node in this.units("node"))if(node.m.KanadeSpawned<2&&this.spawnEcho(node.getTile())!=null)node.m.KanadeSpawned++;
  if(b.Stage==100&&(round-b.StartRound)%3==0&&b.Reinforcements<6)
  {
   foreach(a in ::Tactical.Entities.getAllInstancesAsArray())if(this.alive(a)&&"KanadeTerminal" in a.m&&a.m.KanadeTerminal)
    for(local i=0;i<2&&b.Reinforcements<6;i++)if(this.spawnEcho(a.getTile())!=null)b.Reinforcements++;
  }
 },
 function refresh()
 {
  local b=this.Battle;if(b==null||b.Done||this.Initializing)return;
  if(b.Stage==20&&this.units("cart").len()<2)b.Failed=true;
  if(b.Stage==60&&this.units("node").len()==0&&!b.Boss)
  {
   local origin=null;foreach(a in ::Tactical.Entities.getAllInstancesAsArray())if(this.alive(a)){origin=a.getTile();break;}
   if(origin!=null&&this.spawnEcho(origin,true)!=null)b.Boss=true;
  }
 },
 function holdVictory()
 {
  local b=this.Battle;if(b==null||b.Done||b.Failed)return false;
  if(b.Stage==60)return !b.Boss;
  return false;
 },
 function won()
 {
  local b=this.Battle;if(b==null||b.Failed||this.holdVictory())return false;
  foreach(a in ::Tactical.Entities.getAllInstancesAsArray())if(this.alive(a)&&!a.isAlliedWithPlayer())return false;
  if(b.Stage==20)return this.units("cart").len()>=2;
  if(b.Stage==40||b.Stage==80)return true;
  if(b.Stage==60)return b.Boss&&this.units("node").len()==0;
  return b.Stage==100&&this.units("anchor").len()==0;
 },
 function finish()
 {
  local b=this.Battle;if(b==null||b.Done)return;this.refresh();
  local location=this.k().api().readValkyrieCombatWeakRef(b.Location),won=this.won()&&::Tactical.Entities.getCombatResult()==::Const.Tactical.CombatResult.EnemyDestroyed;
  if(location!=null)location.getFlags().set("BVKanadeObjectiveWon",won);
  b.Done=true;
  foreach(a in this.units())a.dismissMission();
 }
};
