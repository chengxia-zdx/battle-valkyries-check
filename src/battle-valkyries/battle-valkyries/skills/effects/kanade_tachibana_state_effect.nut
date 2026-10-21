// Read-only combat feedback. Actor state remains authoritative for all mechanics.
this.kanade_tachibana_state_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Kind=""},
 function create()
 {
  this.valkyrie_effect_skill.create();this.m.IsStacking=false;this.m.IsHidden=false;
  this.m.IconMini="status_effect_34_mini";
 },
 function configure(kind)
 {
  this.m.Kind=kind;this.m.ID="$bvvar{modId}.effect.kanade_state_"+kind;
  local names={distortion="$bv{kanade.state.distortion.name}",delay="$bv{kanade.state.delay.name}",harmonics="$bv{kanade.state.harmonics.name}",extra_delay="$bv{kanade.state.extra_delay.name}"};
  this.m.Name=names[kind];
  this.m.Icon="skills/$bvvar{iconPrefix}/kanade_tachibana_"+(kind=="extra_delay"?"delay":kind)+".png";
  if(kind=="distortion")this.m.IconMini="status_effect_03_mini";
 },
 function actor(){return this.getContainer()==null?null:this.getContainer().getActor();},
 function isHidden()
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor(),s=f.state(a);
  if(!f.alive(a)||!f.owns(a)||s==null||!s.Active)return true;
  if(this.m.Kind=="distortion")return !s.Distortion;
  if(this.m.Kind=="delay")return !s.Defense;
  if(this.m.Kind=="harmonics")return f.liveClones(a).len()==0;
  return !f.extraDelay(a);
 },
 function getDescription()
 {
  local f=::$bvvar{namespace}.Kanade,a=this.actor(),s=f.state(a);
  if(this.isHidden())return "$bv{kanade.state.inactive}";
  if(this.m.Kind=="distortion")return "$bv{kanade.state.distortion.description}"+(f.upgraded(a,60)?"$bv{kanade.state.distortion.upgraded}":"");
  if(this.m.Kind=="delay")return ::format("$bv{kanade.state.delay.description}",s.Charges);
  if(this.m.Kind=="extra_delay")return "$bv{kanade.state.extra_delay.description}";
  local clones=f.liveClones(a),turns=0;
  foreach(c in clones)turns=::Math.max(turns,c.m.KanadeExpire-s.Turn);
  return ::format("$bv{kanade.state.harmonics.description}",clones.len(),turns,f.upgraded(a,80)?12:8);
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];}
});
