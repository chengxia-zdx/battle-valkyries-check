this.grey_falcon_focus_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, Round = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.grey_falcon_focus";
		this.m.Name = "$bv{enemy.grey_falcon.focus.name}"; this.m.Description = "$bv{enemy.grey_falcon.focus.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_focus_target.png"; this.m.IconMini = "status_effect_74_mini";
	},
	function getOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); },
	function isOrderActive()
	{
		local owner = this.getOwner(), target = this.getContainer().getActor();
		return !this.m.IsGarbage && this.m.Round == ::Time.getRound() && !::$bvvar{namespace}.isActorDeadOrDying(owner)
			&& !::$bvvar{namespace}.isActorDeadOrDying(target) && owner.isPlacedOnMap() && target.isPlacedOnMap()
			&& !owner.isAlliedWith(target);
	},
	function onUpdate(properties) { if (!this.isOrderActive()) this.removeSelf(); },
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
