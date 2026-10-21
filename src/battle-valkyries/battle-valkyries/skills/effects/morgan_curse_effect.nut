this.morgan_curse_effect <- this.inherit("$bvvar{privateFolder}/skills/core/morgan_timed_effect", {
	function create()
	{
		this.morgan_timed_effect.create();
		this.m.ID = "$bvvar{modId}.effects.morgan_curse";
		this.m.Name = "$bv{effect.morgan_curse.name}"; this.m.Description = "$bv{effect.morgan_curse.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/morgan_roadless_camelot.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/morgan_roadless_camelot_sw.png";
		this.m.IconMini = "status_effect_111_mini";
		this.m.Overlay = "status_effect_111";
	}
	function onTurnStart()
	{
		if (!this.beginNormalTurn()) return;
		local owner = this.getMorganOwner();
		local target = this.getContainer().getActor();
		if (owner == null) { this.removeSelf(); return; }
		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, target, 15, { Source = "morgan_curse" });
	}
});
