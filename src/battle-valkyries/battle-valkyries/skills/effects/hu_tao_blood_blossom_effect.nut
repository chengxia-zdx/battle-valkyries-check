this.hu_tao_blood_blossom_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={Owner=null,Damage=0,Remaining=2,LastRound=-1},
 function create()
 {
  this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effect.hu_tao_blood_blossom";this.m.Name="$bv{hu_tao.blood_blossom.name}";this.m.Description="$bv{hu_tao.blood_blossom.description}";
  this.m.Icon="skills/$bvvar{iconPrefix}/hu_tao_blood_blossom.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_blood_blossom_sw.png";this.m.IconMini="status_effect_111_mini";this.m.Type=this.Const.SkillType.StatusEffect|this.Const.SkillType.DamageOverTime;this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;
 },
 function onTurnEnd()
 {
  local f=::$bvvar{namespace}.HuTao,a=this.getContainer().getActor(),owner=f.api().readValkyrieCombatWeakRef(this.m.Owner),state=f.state(owner);
  if(!f.enemy(owner,a)||state==null||!state.Active){this.removeSelf();return;}
  if(!f.normal(a)||this.m.LastRound==::Time.getRound())return;this.m.LastRound=::Time.getRound();
  if(!a.getCurrentProperties().IsImmuneToFire)
  {
   local hit=clone ::Const.Tactical.HitInfo;hit.DamageRegular=this.m.Damage;hit.DamageArmor=0.0;hit.DamageDirect=1.0;hit.BodyPart=::Const.BodyPart.Body;hit.BodyDamageMult=1.0;hit.DamageFatigue=0;hit.DamageMinimum=0;hit.Injuries=[];
   local source=f.api().pushValkyrieCombatSource("hu_tao_blood_blossom",owner);
   try{f.visual(a.getTile(),"blood_blossom");a.onDamageReceived(owner,this,hit);}
 catch(e){f.api().popValkyrieCombatSource(source);throw e;}
   f.api().popValkyrieCombatSource(source);
  }
  if(--this.m.Remaining<=0)this.removeSelf();
 },
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/regular_damage.png",text=::format("$bv{hu_tao.blossom.tick}",this.m.Damage,this.m.Remaining)}];}
});
