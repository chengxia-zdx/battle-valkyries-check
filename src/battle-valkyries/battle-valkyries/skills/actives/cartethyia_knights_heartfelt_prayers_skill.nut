this.cartethyia_knights_heartfelt_prayers_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create() { this.valkyrie_active_skill.create(); this.m.IsTargeted=false; this.m.IsTargetingActor=false; this.m.IsAttack=false; this.m.IsWeaponSkill=false; this.m.ActionPointCost=0; this.m.FatigueCost=0; this.m.IsSpent<-false; }
	function getManifest() { local c=this.getContainer(); return c==null?null:c.getSkillByID("$bvvar{modId}.effects.cartethyia_fleurdelys_manifest"); }
	function isUsable() { return this.skill.isUsable() && !this.m.IsSpent && this.getManifest()==null; }
	function onUse( _user, _targetTile ) { if(_user==null||!this.isUsable())return false; local half=::Math.max(1,::Math.floor(_user.getHitpointsMax()*0.5)); if(_user.getHitpoints()>half)_user.setHitpoints(half); local e=::new("$bvvar{privateFolder}/skills/effects/cartethyia_fleurdelys_manifest_effect"); this.getContainer().add(e); this.m.IsSpent=true; return true; }
	function onCombatStarted() { this.m.IsSpent=false; }
	function onCombatFinished() { this.m.IsSpent=false; this.skill.onCombatFinished(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/health.png",text="$bv{skill.cartethyia_knights_heartfelt_prayers.tooltip}"}]; }
});
