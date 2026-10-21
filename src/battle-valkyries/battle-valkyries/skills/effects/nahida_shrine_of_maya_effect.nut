this.nahida_shrine_of_maya_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, OwnerID = null, ShrineToken = null },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.nahida_shrine_of_maya";
		this.m.Name = "$bv{effect.nahida_shrine_of_maya.name}";
		this.m.Description = "$bv{effect.nahida_shrine_of_maya.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/nahida_shrine_of_maya.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/nahida_shrine_of_maya_sw.png";
		this.m.IsHidden = false;
		this.m.IsStacking = false;
	}

	function setup( _owner, _token )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.ShrineToken = _token;
		return this;
	}

	function getOwner()
	{
		return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
	}

	function getPassive()
	{
		local owner = this.getOwner();
		return owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner, "nahida_tri_karma_purification");
	}

	function isActiveFor( _actor )
	{
		local passive = this.getPassive();
		return passive != null && passive.isShrineTokenActive(this.m.ShrineToken) && passive.isActorInsideShrine(_actor);
	}

	function onUpdate( _properties )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local passive = this.getPassive();
		if (actor == null || passive == null || !this.isActiveFor(actor)) return;
		_properties.Bravery += passive.getSharedResolve();
	}

	function onAnySkillUsed( _skill, _target, _properties )
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local passive = this.getPassive();
		if (actor == null || passive == null || _properties == null || _skill == null || !_skill.isAttack() || _target == null || !this.isActiveFor(actor) || !passive.hasOwnedSeed(_target)) return;
		_properties.DamageTotalMult *= 1.0 + passive.getShrineAllyDamageBonus();
	}

	function onNewRound()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		local passive = this.getPassive();
		if (actor == null || passive == null || !passive.isShrineTokenActive(this.m.ShrineToken)) this.removeSelf();
	}

	function onDeath( _fatalityType )
	{
		this.removeSelf();
	}

	function getTooltip()
	{
		local passive = this.getPassive();
		local resolve = passive == null ? 0 : passive.getSharedResolve();
		local damage = passive == null ? 0 : this.Math.floor(passive.getShrineAllyDamageBonus() * 100.0);
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/bravery.png", text = "$bv{effect.nahida_shrine_of_maya.tooltip.resolve_prefix}" + resolve },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.nahida_shrine_of_maya.tooltip.damage_prefix}" + damage + "%" }
		];
	}
});
