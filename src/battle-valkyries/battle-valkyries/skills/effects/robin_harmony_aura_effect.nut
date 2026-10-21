this.robin_harmony_aura_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner = null, OwnerID = 0 },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.robin_harmony_aura";
		this.m.Name = "$bv{effect.robin_harmony_aura.name}";
		this.m.Description = "$bv{effect.robin_harmony_aura.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/robin_harmonic_resonance.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/robin_harmonic_resonance_sw.png";
		this.m.IsHidden = true;
	}
	function setupOwner( _owner ) { this.m.Owner=_owner==null?null:this.WeakTableRef(_owner); this.m.OwnerID=_owner==null?0:_owner.getID(); }
	function getOwner() { return this.m.Owner==null||this.m.Owner.isNull()?null:this.m.Owner; }
	function isOwnedBy( _owner ) { return _owner!=null && _owner.getID()==this.m.OwnerID; }
	function onUpdate( _properties )
	{
		local passive = ::$bvvar{namespace}.getRobinPassive(this.getOwner());
		if (passive == null) return;
		local bonus = passive.getAuraSkillBonus();
		_properties.MeleeSkill += bonus;
		_properties.RangedSkill += bonus;
		_properties.DamageTotalMult *= passive.getAuraDamageMult();
	}
	function onDeath( _fatalityType ) { this.removeSelf(); }
});
