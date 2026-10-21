this.hu_tao_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
 m={Spec=null,HuTaoAttack=false,Snapshot=null,Committed=false,Executing=false,Effective=false},
 function f(){return ::$bvvar{namespace}.HuTao;},
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function create(){this.valkyrie_active_skill.create();this.m.IsDoingAttackMove=false;this.m.IsShowingProjectile=false;this.m.IsIgnoredAsAOO=true;this.m.MaxRangeBonus=0;this.m.IsVisibleTileNeeded=true;},
 function onValkyrieSkillBound(d)
 {
  this.m.Spec=clone d.Spec;local k=d.Spec.Key;
  this.m.ActionPointCost=d.Spec.AP;this.m.FatigueCost=d.Spec.Fatigue;
  this.m.MinRange=k=="guide_to_afterlife"||k=="spirit_soother"?0:1;this.m.MaxRange=k=="wangsheng_dash"?3:k=="basic_thrust"?2:0;
  this.m.IsTargeted=k!="guide_to_afterlife";this.m.IsTargetingActor=k=="basic_thrust";
  this.m.HuTaoAttack=k!="guide_to_afterlife";this.m.IsAttack=this.m.HuTaoAttack;this.m.IsWeaponSkill=k=="wangsheng_dash"||k=="basic_thrust";
  this.m.IsUsingHitchance=this.m.HuTaoAttack;this.m.IsShieldRelevant=this.m.HuTaoAttack;this.m.DirectDamageMult=k=="basic_thrust"?0.25:0.35;
 },
 function onAfterUpdate(p)
 {
  if(this.m.Spec.Key!="wangsheng_dash")return;local f=this.f(),a=this.actor(),dance=f.dance(a);
  this.m.ActionPointCost=dance?2:4;this.m.FatigueCost=dance?(f.upgraded(a,20)?6:8):16;this.m.MaxRange=dance?4:3;
 },
 function isUsable(){return !this.m.Executing&&this.f().reason(this.actor(),this.m.Spec.Key)==null&&this.skill.isUsable();},
 function onVerifyTarget(origin,tile)
 {
  local f=this.f(),a=this.actor(),k=this.m.Spec.Key;if(!f.able(a)||origin==null)return false;
  if(k=="guide_to_afterlife")return true;
  if(k=="spirit_soother")return tile!=null&&tile.ID==origin.ID;
  if(k=="wangsheng_dash")return f.path(a,tile)!=null;
  return tile!=null&&tile.IsVisibleForEntity&&tile.IsOccupiedByActor&&f.enemy(a,tile.getEntity())&&!tile.getEntity().isHiddenToPlayer()&&origin.getDistanceTo(tile)>=1&&origin.getDistanceTo(tile)<=2&&::Math.abs(origin.Level-tile.Level)<=1&&origin.hasLineOfSightTo(tile,2);
 },
 function onTargetSelected(tile)
 {
  if(this.m.Spec.Key=="spirit_soother"){this.previewArea();return;}
  this.skill.onTargetSelected(tile);local a=this.actor(),f=this.f(),out=[];
  if(this.m.Spec.Key=="wangsheng_dash"){local path=f.path(a,tile);if(path!=null)out=path;}
  foreach(t in out)::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 function previewArea()
 {
  local a=this.actor();if(!this.f().able(a))return;
  local highlighter=::Tactical.getHighlighter();highlighter.clearOverlayIcons();
  foreach(t in this.f().areaTiles(a))highlighter.addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
 },
 function use(tile,free=false)
 {
  local a=this.actor();if(a==null||free||!this.isUsable()||!this.isAffordable()||!this.onVerifyTarget(a.getTile(),tile))return false;
  local ap=a.getActionPoints(),fat=a.getFatigue();this.m.Committed=false;
  try{local result=this.skill.use(tile,false);if(!result&&!this.m.Committed){a.setActionPoints(ap);a.setFatigue(fat);}
 return result;}
  catch(e){if(!this.m.Committed&&this.f().alive(a)){a.setActionPoints(ap);a.setFatigue(fat);}
 throw e;}
 },
 function onUse(a,tile)
 {
  local f=this.f(),api=f.api(),s=f.state(a),k=this.m.Spec.Key;
  if(this.m.Executing||f.reason(a,k)!=null||!this.onVerifyTarget(a.getTile(),tile))return false;
  local c=api.getCurrentValkyrieActionContext(a,this);
  if(c==null||c.IsFree||c.IsImplicit||c.Source!="managed_active"||c.ActionToken in s.Actions)return false;
  local path=k=="wangsheng_dash"?f.path(a,tile):null;if(k=="wangsheng_dash"&&path==null)return false;
  this.m.Committed=true;s.Actions[c.ActionToken]<-true;
  if(k=="guide_to_afterlife"){f.activate(a);return true;}
  local snap=f.snapshot(a,k);
  if(k=="wangsheng_dash")
  {
   if(s.DashRound!=::Time.getRound()){s.DashRound=::Time.getRound();s.Dashes=0;}
 s.Dashes++;
   f.move(a,path,this,snap,c);
  }
  else if(k=="spirit_soother")
  {
   s.QReady=s.Turn+2;local targets=f.area(a),effective=0;f.visual(a.getTile(),"spirit_soother");
   foreach(b in targets){if(!f.able(a))break;if(this.strike(a,b,snap))effective++;}
   f.heal(a,effective,snap);
  }
  else this.strike(a,tile.getEntity(),snap);
  f.update(a);return true;
 },
 function strike(a,b,snap)
 {
  local f=this.f();if(!f.able(a)||!f.enemy(a,b))return false;
  this.m.Snapshot=snap;this.m.Effective=false;this.m.Executing=true;
  local result=false;
  try{f.visual(b.getTile(),"dash_impact");this.attackEntity(a,b,false);result=this.m.Effective;if(result&&snap.Key!="basic_thrust")f.mark(a,b,snap);}
  catch(e){this.m.Snapshot=null;this.m.Executing=false;throw e;}
  this.m.Snapshot=null;this.m.Executing=false;return result;
 },
 function onTargetHit(skill,b,part,hp,armor){if(skill==this&&(hp>0||armor>0))this.m.Effective=true;},
 function getTooltip()
 {
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()}];
  local f=this.f(),a=this.actor(),s=f.state(a);
  if(this.m.Spec.Key=="spirit_soother")out.push({id=6,type="text",icon="ui/icons/special.png",text="$bv{hu_tao.spirit_soother.confirm}"});
  if(s!=null)out.push({id=4,type="text",icon="ui/icons/special.png",text=::format("$bv{hu_tao.state.counts}",::Math.max(0,s.QReady-s.Turn),s.DashRound==::Time.getRound()?2-s.Dashes:2)});
  local reason=f.reason(a,this.m.Spec.Key);if(reason!=null)out.push({id=5,type="text",icon="ui/tooltips/warning.png",text=reason});return out;
 }
});
