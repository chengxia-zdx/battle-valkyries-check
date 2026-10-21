this.orbment_status_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 function create()
 {
  this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.orbal_state";
  this.m.Name="$bv{orbment.status.name}";this.m.Description="$bv{orbment.status.description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/tio_zero_field.png";this.m.IconMini="status_effect_34_mini";this.m.IsStacking=false;
 }
 function f(){return ::$bvvar{namespace}.OrbalCombat;}
 function actor(){return this.getContainer().getActor();}
 function isHidden()
 {
  foreach(k in ["analysis","chill","zero","guard","boost","disrupt","veil","bulwark","haste"])if(this.f().stacks(this.actor(),k)>0)return false;
  return true;
 }
 function getTooltip()
 {
  local out=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}],f=this.f(),a=this.actor();
  foreach(key in ["analysis","chill","zero","guard","boost","disrupt","veil","bulwark","haste"]) {
   local n=f.stacks(a,key);if(n<=0)continue;
   local text=f.api().OrbalStatusNames[key]+": "+n;
   if(key=="analysis" || key=="chill" || key=="zero")text+=" | $bv{orbment.rounds} "+(f.read(a,key+".until")-f.round());
   out.push({id=10+out.len(),type="text",text=text});
  }
  return out;
 }
 function onUpdate(p)
 {
  local f=this.f(),a=this.actor();
  p.Initiative-=f.stacks(a,"chill")*25;p.MovementAPCostAdditional+=f.stacks(a,"chill");
  p.Initiative+=f.stacks(a,"boost")*30;
  p.MeleeDefense+=f.stacks(a,"guard")*10;p.RangedDefense+=f.stacks(a,"guard")*10;
  p.MeleeSkill-=15*(f.stacks(a,"disrupt")+f.stacks(a,"veil"));p.RangedSkill-=15*(f.stacks(a,"disrupt")+f.stacks(a,"veil"));
  p.Bravery-=15*f.stacks(a,"veil");p.ActionPoints+=f.read(a,"haste.active")*2;
 }
 function onBeforeDamageReceived(attacker,skill,hit,p)
 {
  if(!::$bvvar{namespace}.isDirectAttack(skill))return;
  local n=this.f().stacks(this.actor(),"bulwark");for(local i=0;i<n;i++)p.DamageReceivedRegularMult*=0.9;
 }
 function getValkyrieAttackNullificationPolicy(skill,attacker)
 {
  local a=this.actor(),f=this.f();
  if(!f.api().isDirectAttack(skill) || attacker==null || a.isAlliedWith(attacker) || f.stacks(a,"zero")<=0)return null;
  return {NullifyDirectAttack=true,ConsumeToken="orbal_zero"};
 }
 function consumeValkyrieAttackNullificationPolicy(token,context)
 {
  if(token!="orbal_zero")return;
  local f=this.f(),a=this.actor();f.write(a,"zero.count",::Math.max(0,f.stacks(a,"zero")-1));
  f.api().playValkyrieVisual(this,a,"tio_zero_field");
 }
 function onCombatFinished(){this.f().reset(this.actor());this.removeSelf();}
});

