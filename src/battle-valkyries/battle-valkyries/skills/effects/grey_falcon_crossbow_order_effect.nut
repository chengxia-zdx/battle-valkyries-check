this.grey_falcon_crossbow_order_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.grey_falcon_crossbow_order";
		this.m.Name = "$bv{enemy.grey_falcon.focus.name}"; this.m.Description = "$bv{enemy.grey_falcon.focus.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/m4a1_focus_target.png";
	},
	function onAnySkillUsed(skill, target, properties)
	{
		local actor = this.getContainer().getActor();
		if (target == null || skill == null || !skill.isAttack() || !skill.isRanged()
			|| ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || actor.isAlliedWith(target)) return;
		local mark = target.getSkills().getSkillByID("$bvvar{modId}.effects.grey_falcon_focus");
		if (mark == null || !mark.isOrderActive()) return;
		local commander = mark.getOwner();
		if (actor.isAlliedWith(commander) && actor.getTile().getDistanceTo(commander.getTile()) <= 6) properties.RangedSkill += 10;
	},
	function getTooltip() { return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}]; }
});
