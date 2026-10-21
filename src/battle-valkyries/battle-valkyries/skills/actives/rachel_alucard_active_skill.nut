this.rachel_alucard_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,Committed=false},
 function f(){return ::$bvvar{namespace}.Rachel;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function syncCosts()
 {
  if(this.m.Spec==null)return;
  local t=this.f().tuning(this.actor()),k=this.m.Spec.Key;
  this.m.ActionPointCost=this.m.Spec.AP;this.m.FatigueCost=this.m.Spec.Fatigue;
  if(k=="tiny_lobelia"){this.m.ActionPointCost=t.SeedAP;this.m.FatigueCost=t.SeedFatigue;}
  else if(k=="sword_iris")this.m.FatigueCost=t.IrisFatigue;
  else if(k=="baden_baden_lily"){this.m.ActionPointCost=t.SuperAP;this.m.FatigueCost=t.LilyFatigue;}
  else if(k=="tempest_dahlia"){this.m.ActionPointCost=t.SuperAP;this.m.FatigueCost=t.DahliaFatigue;}
 },
 function getActionPointCost(){this.syncCosts();return this.skill.getActionPointCost();},
 function getFatigueCost(){this.syncCosts();return this.skill.getFatigueCost();},
 function number(n){return n==n.tointeger()?n.tointeger().tostring(): ::format("%.1f",n);},
 function getDescription()
 {
  if(this.m.Spec==null)return this.m.Description;
  local f=this.f(),a=this.actor(),t=f.tuning(a),k=this.m.Spec.Key,m=f.od(a)?t.OD:1.0;
  if(k=="tiny_lobelia")return ::format("$bv{rachel.tip.seed}",t.SeedDamage,t.Needles);
  if(k=="sword_iris")return ::format("$bv{rachel.tip.iris}",t.IrisDamage,(t.AttachedBonus*100).tointeger());
  if(k=="george_xiii")return ::format("$bv{rachel.tip.george}",t.GeorgeHP,t.GeorgeDamage,(t.ChargeBonus*100).tointeger());
  if(k=="lotus_barrel")return ::format("$bv{rachel.tip.lotus}",t.BatDamage,(t.AttachedBonus*100).tointeger());
  if(k=="ivy_blossom")return ::format("$bv{rachel.tip.ivy}",t.IvyDamage,t.IvyDamage);
  if(k=="baden_baden_lily")return ::format("$bv{rachel.tip.lily}",this.number(t.LilyBody*m),this.number(t.LilySource*m));
  if(k=="tempest_dahlia")return ::format("$bv{rachel.tip.dahlia}",this.number(t.DahliaDamage*m));
  if(k=="clownish_calendula")return ::format("$bv{rachel.tip.astral}",t.AstralDamage);
  if(k=="elfried")return ::format("$bv{rachel.tip.od}",((t.OD-1)*100).tointeger());
  return this.m.Description;
 },
 function create(){this.valkyrie_active_skill.create();this.m.IsShowingProjectile=false;this.m.IsDoingAttackMove=false;this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;},
 function onValkyrieSkillBound(d){this.m.Spec=clone d.Spec;local s=this.m.Spec;this.m.Order=::$bvvar{namespace}.getValkyrieActiveSkillOrder()+s.Order;this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.Min;this.m.MaxRange=s.Range;this.m.MaxLevelDifference=1;this.m.IsAttack=false;this.m.IsWeaponSkill=false;this.m.IsUsingHitchance=false;this.m.IsTargeted=s.Range>0;this.m.IsTargetingActor=false;},
 function reason(){local f=this.f(),a=this.actor(),s=f.state(a),key=this.m.Spec.Key;if(!f.able(a)||s==null||!s.Active||s.Move!=null)return "$bv{rachel.unavailable}";if(s.Heat<this.m.Spec.Heat)return "$bv{rachel.need_heat}";if(key=="sword_iris"&&s.Rods.len()==0)return "$bv{rachel.need_rod}";if(key=="lotus_barrel"&&!this.hasRod())return "$bv{rachel.ground_required}";if(key=="gerbera_lute"&&!f.od(a))return "$bv{rachel.need_od}";if(key=="elfried"&&s.ODUsed||key=="clownish_calendula"&&s.AstralUsed)return "$bv{rachel.used}";if(key=="silpheed"&&(s.Wind<1||a.getFatigue()+2>a.getFatigueMax()))return "$bv{rachel.need_wind}";return null;},
 function hasRod(){local s=this.f().state(this.actor());if(s!=null){foreach(r in s.Rods){if(r.Kind=="rod")return true;}}
 return false;},
 function isUsable(){return this.reason()==null&&this.skill.isUsable();},
 function selection(tile){local f=this.f(),a=this.actor(),s=f.state(a);if(tile.ID==a.getTile().ID&&s.WindRound!=s.Turn&&!a.getCurrentProperties().IsRooted)return {Kind="actor",Ref=f.api().makeValkyrieCombatWeakRef(a),Tile=tile};local g=f.api().readValkyrieCombatWeakRef(s.George);if(f.alive(g)&&g.getTile().ID==tile.ID&&!g.getCurrentProperties().IsRooted)return {Kind="actor",Ref=s.George,Tile=tile};foreach(r in s.Rods)if(r.Kind=="bat"&&r.Host==null&&r.Tile.ID==tile.ID)return {Kind="bat",Object=r,Tile=tile};if(s.Ivy!=null&&s.Ivy.Tile.ID==tile.ID)return {Kind="ivy",Object=s.Ivy,Tile=tile};return null;},
 function windPath(tile){local f=this.f(),s=f.state(this.actor()),x=s.Selection;if(x==null)return null;local from=x.Tile;if(x.Kind=="actor"){local a=f.api().readValkyrieCombatWeakRef(x.Ref);if(!f.alive(a)||a.getCurrentProperties().IsRooted)return null;from=a.getTile();}
else if(x.Kind=="bat"){if(s.Rods.find(x.Object)==null||x.Object.Host!=null)return null;from=x.Object.Tile;}
else {if(s.Ivy!=x.Object)return null;from=x.Object.Tile;}
 return f.path(from,tile,x.Kind=="ivy"?1:2,x.Kind!="actor");},
 function onVerifyTarget(origin,tile){local f=this.f(),a=this.actor(),d=this.m.Spec,s=f.state(a);if(!f.able(a)||s==null||tile==null||!tile.IsVisibleForEntity)return false;if(d.Key=="silpheed")return s.Selection==null?this.selection(tile)!=null:this.windPath(tile)!=null||this.selection(tile)!=null;local range=origin.getDistanceTo(tile);if(range<d.Min||range>d.Range||::Math.abs(origin.Level-tile.Level)>1)return false;if(d.Range==0)return true;if(d.Key=="george_xiii")return tile.IsEmpty;if(d.Key=="ivy_blossom")return tile.IsEmpty||tile.ID==origin.ID;if(d.Key=="tiny_lobelia"||d.Key=="tempest_dahlia")return origin.hasLineOfSightTo(tile,2)&&(tile.IsEmpty||tile.IsOccupiedByActor&&f.enemy(a,tile.getEntity()));if(!tile.IsOccupiedByActor||!f.enemy(a,tile.getEntity())||tile.getEntity().isHiddenToPlayer())return false;if(d.Key=="clownish_calendula")return origin.hasLineOfSightTo(tile,2);return true;},
 function use(tile,free=false){local a=this.actor();if(a==null||free||!this.isUsable()||!this.isAffordable()||!this.onVerifyTarget(a.getTile(),tile))return false;local ap=a.getActionPoints(),fat=a.getFatigue();this.m.Committed=false;try{local ok=this.skill.use(tile,false);if(!ok&&!this.m.Committed){a.setActionPoints(ap);a.setFatigue(fat);}
 return ok;}
catch(e){if(!this.m.Committed&&this.f().alive(a)){a.setActionPoints(ap);a.setFatigue(fat);}
throw e;}},
 function windUse(a,tile,c){local f=this.f(),s=f.state(a);if(s.Selection==null){s.Selection=this.selection(tile);return s.Selection!=null;}
if(tile.ID==s.Selection.Tile.ID){s.Selection=null;return true;}
local path=this.windPath(tile);if(path==null){s.Selection=this.selection(tile);return s.Selection!=null;}
local x=s.Selection;s.Selection=null;if(x.Kind=="actor"){local mover=f.api().readValkyrieCombatWeakRef(x.Ref);if(!f.move(a,mover,path,c))return false;if(mover.getID()==a.getID())s.WindRound=s.Turn;}
else if(x.Kind=="bat"){foreach(t in path){if(!f.alive(a)||x.Object.Host!=null)break;f.batStep(a,x.Object,t);}
f.expire(a,false);}
else {f.hide(s.Ivy);s.Ivy.Tile=tile;s.Ivy.Mark=tile.spawnDetail("effect_bv_rachel_alucard_bat_cloud",::Const.Tactical.DetailFlag.None,false,true);f.ivy(a,null,true);}
f.wind(a,-1);a.setFatigue(a.getFatigue()+2);return true;},
 function line(a,tile){local tiles=[],t=a.getTile(),dir=t.getDirectionTo(tile),seen={};for(local i=0;i<6;++i){if(!t.hasNextTile(dir))break;t=t.getNextTile(dir);if(!t.IsVisibleForEntity||::Math.abs(t.Level-a.getTile().Level)>1||!t.IsEmpty&&!t.IsOccupiedByActor)break;foreach(d in [-1,(dir+2)%6,(dir+4)%6]){local n=d==-1?t:(t.hasNextTile(d)?t.getNextTile(d):null);if(n!=null&&n.IsVisibleForEntity&&::Math.abs(n.Level-t.Level)<=1&&!(n.ID in seen)){seen[n.ID]<-true;tiles.push(n);}}}
 return tiles;},
 function previewTiles(tile)
 {
  local f=this.f(),a=this.actor(),s=f.state(a),k=this.m.Spec.Key,tiles=[],seen={};
  if(a==null||tile==null||s==null)return tiles;
  if(k=="tempest_dahlia")return this.line(a,tile);
  if(k=="sword_iris"||k=="baden_baden_lily")
  {
   if(k=="baden_baden_lily")foreach(t in f.api().getValkyrieRadiusTiles(a.getTile(),1,true))tiles.push(t);
   foreach(r in s.Rods){local p=f.rodTile(r);if(p==null)continue;foreach(t in r.Host!=null?[p]:f.api().getValkyrieRadiusTiles(p,1,true))tiles.push(t);}
  }
  else if(k=="silpheed"&&s.Selection!=null){local path=this.windPath(tile);if(path!=null)tiles=path;else tiles=[tile];}
  else if(k=="ivy_blossom"||k=="george_xiii")tiles=f.api().getValkyrieRadiusTiles(tile,1,true);
  else tiles=[tile];
  local out=[];
  foreach(t in tiles)if(t.IsVisibleForEntity&&!(t.ID in seen)){seen[t.ID]<-true;out.push(t);}
  return out;
 },
 function onTargetSelected(tile){this.skill.onTargetSelected(tile);foreach(t in this.previewTiles(tile))::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);},
 function onUse(a,tile){local f=this.f(),s=f.state(a),d=this.m.Spec,api=f.api();if(this.reason()!=null||!this.onVerifyTarget(a.getTile(),tile))return false;local c=api.getCurrentValkyrieActionContext(a,this);if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active"||c.ActionToken in s.Actions)return false;
  if(d.Key=="silpheed"){local ok=this.windUse(a,tile,c);if(ok){s.Actions[c.ActionToken]<-true;this.m.Committed=true;}
 return ok;}
  this.m.Committed=true;s.Actions[c.ActionToken]<-true;s.Heat-=d.Heat;
  local tuning=f.tuning(a);
  if(d.Key=="nago_attack"||d.Key=="tiny_lobelia"){local shot=d.Key=="tiny_lobelia";f.visual(tile,shot?"lobelia_seed":"nago_slash");if(tile.IsOccupiedByActor&&f.strike(a,tile.getEntity(),this,shot?tuning.SeedDamage:45,shot?"shot":"melee").Damaged)f.gain(a,10);if(shot)for(local i=0;i<tuning.Needles;i++)f.plant(a,tile);}
  else if(d.Key=="sword_iris"||d.Key=="baden_baden_lily")f.detonate(a,this,d.Key=="baden_baden_lily");
  else if(d.Key=="lotus_barrel")f.lotus(a,tile.getEntity());
  else if(d.Key=="ivy_blossom"){f.hide(s.Ivy);s.Ivy={Tile=tile,Until=s.Turn+1,Hits={},Mark=tile.spawnDetail("effect_bv_rachel_alucard_bat_cloud",::Const.Tactical.DetailFlag.None,false,true)};f.ivy(a);}
  else if(d.Key=="george_xiii"){f.clearGeorge(a);local g=::Tactical.spawnEntity("scripts/entity/tactical/battle_valkyries/rachel_george",tile.Coords);g.setFaction(a.getFaction());g.getBaseProperties().Hitpoints=tuning.GeorgeHP;g.getSkills().update();g.setHitpoints(tuning.GeorgeHP);s.George=api.makeValkyrieCombatWeakRef(g);s.GeorgeUntil=s.Turn+1;s.GeorgePaid=false;f.george(a);}
  else if(d.Key=="elfried"){s.ODUsed=true;s.ODUntil=s.Turn+2;f.wind(a,2);f.gain(a,30);f.visual(a.getTile(),"elfried_aura");}
  else if(d.Key=="tempest_dahlia"){foreach(b in api.getValkyrieEnemyTargetsOnTiles(a,this.line(a,tile))){if(!f.alive(a))break;f.visual(b.getTile(),"dahlia");f.strike(a,b,this,tuning.DahliaDamage*(f.od(a)?tuning.OD:1.0),"shot");}
f.wind(a,2);}
  else if(d.Key=="gerbera_lute"){local b=tile.getEntity();f.visual(tile,"gerbera_wave");local hit=f.strike(a,b,this,120,"gerbera").Hit;s.ODUntil=0;if(hit&&f.alive(a)&&f.enemy(a,b)&&!b.getCurrentProperties().IsImmuneToKnockBackAndGrab){local dir=a.getTile().getDirectionTo(b.getTile());if(b.getTile().hasNextTile(dir)){local to=b.getTile().getNextTile(dir);if(f.passable(b.getTile(),to))f.move(a,b,[to],c);}}}
  else if(d.Key=="clownish_calendula"){s.AstralUsed=true;f.visual(tile,"calendula");f.strike(a,tile.getEntity(),this,tuning.AstralDamage,"astral");}
  a.setDirty(true);return true;
 },
 function getTooltip()
 {
  local f=this.f(),a=this.actor(),s=f.state(a),t=f.tuning(a),k=this.m.Spec.Key,r=this.reason();
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
   {id=3,type="text",icon="ui/icons/action_points.png",text=::format("$bv{rachel.tip.cost}",this.getActionPointCost(),k=="silpheed"?2:this.getFatigueCost())}];
  if(this.m.Spec.Heat>0)out.push({id=4,type="text",icon="skills/$bvvar{iconPrefix}/rachel_alucard_heat.png",text=::format("$bv{rachel.tip.heat}",this.m.Spec.Heat,s==null?0:s.Heat)});
  if(k=="silpheed")out.push({id=5,type="text",icon="skills/$bvvar{iconPrefix}/rachel_alucard_wind.png",text=s!=null&&s.Selection!=null?"$bv{rachel.wind_destination}":"$bv{rachel.wind_select}"});
  else if(this.m.Spec.Range>0)out.push({id=6,type="text",icon="ui/icons/vision.png",text=::format("$bv{rachel.tip.range}",this.m.Spec.Min,this.m.Spec.Range)});
  if(k=="sword_iris"||k=="baden_baden_lily")out.push({id=7,type="text",icon="ui/icons/special.png",text=::format("$bv{rachel.tip.combo}",(t.ChargeBonus*100).tointeger(),(t.AttachedBonus*100).tointeger())});
  if(k=="lotus_barrel"||k=="george_xiii"||k=="ivy_blossom")out.push({id=8,type="text",icon="ui/icons/time.png",text="$bv{rachel.tip.familiar}"});
  if(r!=null)out.push({id=9,type="text",icon="ui/tooltips/warning.png",text=r});return out;
 }
});
