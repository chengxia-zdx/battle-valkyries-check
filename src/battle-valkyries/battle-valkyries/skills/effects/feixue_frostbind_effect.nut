this.feixue_frostbind_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={TurnsLeft=1,Applied=false},
	function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.feixue_frostbind";this.m.Name="$bv{effect.feixue_frostbind.name}";this.m.Description="$bv{effect.feixue_frostbind.description}";this.m.Icon="skills/$bvvar{iconPrefix}/feixue_frostbind_effect.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/feixue_frostbind_effect_sw.png";this.m.IconMini<-"status_effect_111_mini";this.m.Overlay<-"status_effect_111";this.m.IsStacking=false;this.m.TurnsLeft=1;this.m.Applied=false;}
	function onAdded(){if(this.m.Applied)return;local a=this.getContainer()==null?null:this.getContainer().getActor();if(a==null)return;try{a.setActionPoints(this.Math.max(0,a.getActionPoints()-4));}catch(e){}this.m.Applied=true;}
	function onUpdate(_properties){_properties.Initiative-=30;}
	function onTurnEnd(){if(--this.m.TurnsLeft<=0)this.removeSelf();}
	function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/action_points.png",text="$bv{effect.feixue_frostbind.tooltip.ap}"}];}
});
