this.rachel_alucard_slow_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Started=false,Round=-1,Owners=null},
 function create()
 {
  this.valkyrie_effect_skill.create();
  this.m.ID="$bvvar{modId}.effect.rachel_slow";
  this.m.Name="$bv{rachel.slow.name}";this.m.Description="$bv{rachel.slow.description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/rachel_alucard_george_xiii.png";
  this.m.IconMini="status_effect_54_mini";
  this.m.Type=::Const.SkillType.StatusEffect;this.m.Order=::Const.SkillOrder.Any;this.m.IsSerialized=false;
 },
 function setOwner(a,bonus)
 {
  if(this.m.Owners==null)this.m.Owners={};
  this.m.Owners[a.getID()]<-{Ref=::$bvvar{namespace}.makeValkyrieCombatWeakRef(a),Bonus=bonus};
  this.m.Started=false;this.m.Round=-1;
 },
 function bonusFor(a)
 {
  if(this.m.Owners==null||!(a.getID() in this.m.Owners))return 0.0;
  local owner=this.m.Owners[a.getID()];
  return ::$bvvar{namespace}.readValkyrieCombatWeakRef(owner.Ref)==a?owner.Bonus:0.0;
 },
 function getTooltip()
 {
  local bonus=0.0;if(this.m.Owners!=null)foreach(owner in this.m.Owners)bonus=::Math.maxf(bonus,owner.Bonus);
  return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=::format("$bv{rachel.slow.description}",(bonus*100).tointeger())}];
 },
 function onUpdate(p){p.Initiative-=20;},
 function onTurnStart(){local a=this.getContainer().getActor();if(::$bvvar{namespace}.EightValkyries.normal(a)){this.m.Started=true;this.m.Round=::Time.getRound();}},
 function onTurnEnd(){if(this.m.Started&&this.m.Round==::Time.getRound()&&::$bvvar{namespace}.EightValkyries.normal(this.getContainer().getActor()))this.removeSelf();},
 function onCombatFinished(){this.removeSelf();}
});
