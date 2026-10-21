this.hu_tao_homecoming_lamp <- this.inherit("scripts/entity/tactical/actor", {
 function create()
 {
  this.m.Name="$bv{hu_tao.challenge.lamp}";this.m.Type=this.Const.EntityType.GreenskinCatapult;this.m.BloodType=this.Const.BloodType.None;
  this.m.IsActingEachTurn=false;this.m.IsNonCombatant=true;this.m.MoraleState=this.Const.MoraleState.Ignore;this.m.XP=0;
  this.actor.create();this.m.AIAgent=this.new("scripts/ai/tactical/agents/donkey_agent");this.m.AIAgent.setActor(this);
 },
 function onInit()
 {
  this.actor.onInit();local p=this.m.BaseProperties;p.setValues(this.Const.Tactical.Actor.GreenskinCatapult);
  p.Hitpoints=150;p.Armor[this.Const.BodyPart.Body]=150;p.ArmorMax[this.Const.BodyPart.Body]=150;
  p.IsMovable=false;p.IsImmuneToKnockBackAndGrab=true;p.IsImmuneToRoot=true;p.IsImmuneToStun=true;p.IsImmuneToHeadshots=true;
  p.IsAffectedByInjuries=false;p.IsAffectedByDyingAllies=false;p.TargetAttractionMult=2.0;
  this.m.Hitpoints=150;this.m.CurrentProperties=clone p;this.m.ActionPointCosts=this.Const.DefaultMovementAPCost;this.m.FatigueCosts=this.Const.DefaultMovementFatigueCost;
  this.addSprite("body").setBrush("effect_bv_hu_tao_lingering_fragrance");this.addDefaultStatusSprites();this.m.Skills.update();
 },
 function onDamageReceived(a,s,h){h.BodyPart=this.Const.BodyPart.Body;return this.actor.onDamageReceived(a,s,h);},
 function onDeath(killer,skill,tile,fatality){local b=::$bvvar{namespace}.HuTaoChallenge.Battle;if(b!=null)b.Failed=true;this.actor.onDeath(killer,skill,tile,fatality);},
 function onSerialize(out){throw "[Battle Valkyries] Homecoming lamp is tactical-only";}
});
