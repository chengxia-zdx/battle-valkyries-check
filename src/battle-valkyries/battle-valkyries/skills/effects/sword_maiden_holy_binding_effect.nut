this.sword_maiden_holy_binding_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef=null, OwnerID=null, TurnsLeft=2, RootTurnsLeft=0, DisarmTurnsLeft=0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID="$bvvar{modId}.effects.sword_maiden_holy_binding";
		this.m.Name="$bv{effect.sword_maiden_holy_binding.name}";
		this.m.Description="$bv{effect.sword_maiden_holy_binding.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/sword_maiden_holy_binding_judgment.png";
		this.m.IconDisabled="skills/$bvvar{iconPrefix}/sword_maiden_holy_binding_judgment_sw.png";
		this.m.IconMini <- "status_effect_111_mini";
		this.m.Overlay <- "status_effect_111";
		this.m.IsStacking=false;
	}

	function setup( _owner, _isGoblin, _canRoot )
	{
		this.m.OwnerRef=::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID=::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.TurnsLeft=2;
		this.m.RootTurnsLeft=_isGoblin && _canRoot ? 1 : 0;
		this.m.DisarmTurnsLeft=_isGoblin && _canRoot ? 1 : 0;
		return this;
	}

	function getOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); }
	function onRefresh() { this.m.TurnsLeft=2; }
	function onUpdate( _properties )
	{
		_properties.MeleeSkill-=15; _properties.RangedSkill-=15;
		_properties.MeleeDefense-=15; _properties.RangedDefense-=15;
		if (this.m.RootTurnsLeft>0) _properties.IsRooted=true;
	}

	function blocksValkyrieSkillUse( _skill )
	{
		if (_skill==null) return false;
		try { if (this.m.DisarmTurnsLeft>0 && _skill.m.IsWeaponSkill) return true; } catch (e) {}
		local id=""; try { id=_skill.getID().tolower(); } catch (e) {}
		foreach (token in ["footwork","rotation","leap","lunge","charge","sprint","teleport","warp","pirouette","quick_step"])
		{
			if (id.find(token)!=null) return true;
		}
		return false;
	}

	function onTurnEnd()
	{
		this.m.TurnsLeft--; this.m.RootTurnsLeft=this.Math.max(0,this.m.RootTurnsLeft-1); this.m.DisarmTurnsLeft=this.Math.max(0,this.m.DisarmTurnsLeft-1);
		if (this.m.TurnsLeft<=0) this.removeSelf();
	}

	function onDeath( _fatalityType )
	{
		local target=this.getContainer()==null?null:this.getContainer().getActor();
		local owner=this.getOwner();
		local trait=::$bvvar{namespace}.getSwordMaidenHuntTrait(owner);
		if (target!=null && trait!=null && ::$bvvar{namespace}.isSwordMaidenGoblin(target)) trait.recordMarkedAssist(target);
		this.removeSelf();
	}

	function getTooltip()
	{
		return [
			{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/hitchance.png",text="$bv{effect.sword_maiden_holy_binding.tooltip.debuff}"},
			{id=4,type="text",icon="ui/icons/action_points.png",text="$bv{effect.sword_maiden_holy_binding.tooltip.movement}"}
		];
	}
});
