this.si_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Source=null,SiKind="",Kind="",Until=0,Amount=0,TargetEnd=0,ActionToken=null,Consumed=false},
 function create(){this.valkyrie_effect_skill.create();this.m.IsStacking=false;this.m.IsHidden=false;this.m.IconMini="status_effect_34_mini";},
 function source(){return ::$bvvar{namespace}.Si.read(this.m.Source);},
 function configure(a,kind,id)
 {
  this.m.Source=::$bvvar{namespace}.Si.ref(a);this.m.SiKind=kind;this.m.Kind=kind=="ward"?"shield":"si_"+kind;this.m.ID=id;
  local names={mark="$bv{si.effect.mark}",root="$bv{si.effect.root}",ward="$bv{si.effect.ward}",echo="$bv{si.effect.echo}"};
  local desc={mark="$bv{si.effect.mark.description}",root="$bv{si.effect.root.description}",ward="$bv{si.effect.ward.description}",echo="$bv{si.effect.echo.description}"};
  local icons={mark="si_myriad",root="si_landscape",ward="si_sanctuary",echo="si_dragon"};
  this.m.Name=names[kind];this.m.Description=desc[kind];this.m.Icon="skills/$bvvar{iconPrefix}/"+icons[kind]+".png";
 },
 function valid()
 {
  local f=::$bvvar{namespace}.Si,a=this.source(),s=f.state(a),b=this.getContainer()==null?null:this.getContainer().getActor();
  if(!f.owner(a)||s==null||!s.Active||!f.alive(b))return false;
  if(this.m.SiKind=="root")return f.enemy(a,b)&&(!("BVEightNormalEnds" in b.m)||b.m.BVEightNormalEnds<this.m.TargetEnd);
  if(s.Turn>=this.m.Until)return false;
  if(this.m.SiKind=="mark")return f.marked(a,b);
  return f.ally(a,b)&&!this.m.Consumed;
 },
 function onUpdate(p)
 {
  if(!this.valid())return;
  if(this.m.SiKind=="ward"&&this.m.Amount>0){p.MeleeDefense+=10;p.RangedDefense+=10;}
  if(this.m.SiKind=="root"){if(!p.IsImmuneToRoot)p.IsRooted=true;}
 },
 function onAnySkillUsed(skill,target,p)
 {
  if(this.m.SiKind!="echo"||!this.valid()||skill==null||!skill.isAttack()||this.m.ActionToken==null)return;
  local c=::$bvvar{namespace}.getCurrentValkyrieActionContext(this.getContainer().getActor(),skill);
  if(c!=null&&c.ActionToken==this.m.ActionToken)p.DamageTotalMult*=1.2;
 },
 function removeSelf()
 {
  if(!this.m.IsGarbage&&this.m.SiKind=="ward"&&this.m.Amount<=0&&this.valid())
  {
   local f=::$bvvar{namespace}.Si,b=this.getContainer().getActor();
   f.visual(this.source(),b.getTile(),"si_ward_break");f.sound(this.source(),"si_ward_break",f.api().captureValkyrieSkillAudioPosition(b));
  }
  this.valkyrie_effect_skill.removeSelf();
 },
 function getTooltip()
 {
  local s=::$bvvar{namespace}.Si.state(this.source()),out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
  if(this.m.SiKind=="ward")out.push({id=3,type="text",icon="ui/icons/health.png",text="$bv{si.ward_remaining}"+this.m.Amount});
  if(this.m.SiKind!="root")out.push({id=4,type="text",icon="ui/icons/time.png",text="$bv{si.turns}"+(s==null ? 0 : ::Math.max(0,this.m.Until-s.Turn))});
  return out;
 },
 function onTurnStart(){if(!this.valid())this.removeSelf();}
});
