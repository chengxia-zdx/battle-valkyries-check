this.lily_accept_blight_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=false;this.m.IsAttack=false;this.m.ActionPointCost=0;this.m.FatigueCost=0;}
	function controller(){local c=this.getContainer();return c==null?null:c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));}
	function isHidden(){local c=this.controller();return c==null||c.isBlighted();}
	function isUsable(){local c=this.controller();return this.skill.isUsable()&&c!=null&&c.canTransform();}
	function onUse(_user,_targetTile){local c=this.controller();return c!=null&&c.transform(false);}
});
