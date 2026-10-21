this.trails_duo_state <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create(){
  this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.trails_state";
  this.m.Name="$bv{trails.state}";this.m.Description="$bv{trails.state_description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/renne_annihilation_mark.png";this.m.IconMini="status_effect_34_mini";this.m.IsStacking=false;
 }
 function f(){return ::$bvvar{namespace}.TrailsDuo;}
 function actor(){return this.getContainer().getActor();}
 function onUpdate(p){local f=this.f(),a=this.actor();if(f.read(a,"step.active")>0)p.MeleeDefense+=10;if(f.read(a,"gift.active")>0){p.MeleeDefense+=8;p.RangedDefense+=8;}}
 function isHidden(){
  local f=this.f(),a=this.actor();foreach(id in f.owners(a))if(f.read(a,"mark."+id+".count")>0&&f.read(a,"mark."+id+".until")>f.round())return false;
  return f.read(a,"radiance")==0&&f.read(a,"burn.ticks")==0&&f.read(a,"gift.active")==0&&f.read(a,"step.active")==0;
 }
 function getTooltip(){
  local out=this.skill.getTooltip(),f=this.f(),a=this.actor();
  foreach(id in f.owners(a)){local n=f.read(a,"mark."+id+".count"),rounds=f.read(a,"mark."+id+".until")-f.round();if(n>0&&rounds>0)out.push({id=10+out.len(),type="text",icon="skills/$bvvar{iconPrefix}/renne_annihilation_mark.png",text="$bv{trails.mark}: "+n+" | $bv{orbment.rounds} "+rounds});}
  if(f.read(a,"radiance")>0)out.push({id=30,type="text",icon="skills/$bvvar{iconPrefix}/alisa_radiant_resonance.png",text="$bv{trails.radiance}: 1"});
  if(f.read(a,"burn.ticks")>0)out.push({id=31,type="text",text="$bv{trails.burn}: 8 HP | $bv{trails.turns} "+f.read(a,"burn.ticks")});
  if(f.read(a,"gift.active")>0)out.push({id=32,type="text",text="$bv{trails.gift}: +8 / +8 | $bv{trails.turns} "+f.read(a,"gift.ticks")});
  if(f.read(a,"step.active")>0)out.push({id=33,type="text",text="$bv{trails.step}: +10"});return out;
 }
 function onCombatFinished(){this.f().reset(this.actor());this.removeSelf();}
});
