this.kanade_tachibana_howling_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
 m={StartedRound=-1},
 function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effect.kanade_howling";this.m.Name="$bv{kanade.state.howling.name}";this.m.Description="$bv{kanade.howling.weakened}";this.m.Icon="skills/$bvvar{iconPrefix}/kanade_tachibana_howling.png";this.m.IconMini="status_effect_34_mini";this.m.IsHidden=false;this.m.IsStacking=false;},
 function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];},
 function onUpdate(p){p.DamageTotalMult*=0.80;p.Initiative-=20;},
 function onTurnStart(){if(::$bvvar{namespace}.EightValkyries.normal(this.getContainer().getActor()))this.m.StartedRound=::Time.getRound();},
 function onTurnEnd(){if(this.m.StartedRound>=0&&::$bvvar{namespace}.EightValkyries.normal(this.getContainer().getActor()))this.removeSelf();}
});
