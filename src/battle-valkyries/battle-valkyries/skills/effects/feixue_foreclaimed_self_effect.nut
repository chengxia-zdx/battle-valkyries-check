this.feixue_foreclaimed_self_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create() { this.valkyrie_effect_skill.create(); this.m.ID="$bvvar{modId}.effects.feixue_foreclaimed_self"; this.m.Name="$bv{effect.feixue_foreclaimed_self.name}"; this.m.Description="$bv{effect.feixue_foreclaimed_self.description}"; this.m.Icon="skills/$bvvar{iconPrefix}/feixue_foreclaimed_self_effect.png"; this.m.IconDisabled="skills/$bvvar{iconPrefix}/feixue_foreclaimed_self_effect_sw.png"; this.m.IconMini<-"status_effect_34_mini"; this.m.Overlay<-"status_effect_34"; this.m.IsStacking=false; }
	function isForeclaimedSelf() { return true; }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{effect.feixue_foreclaimed_self.tooltip}"}]; }
});
