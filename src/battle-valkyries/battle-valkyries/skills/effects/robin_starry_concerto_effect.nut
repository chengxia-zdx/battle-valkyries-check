this.robin_starry_concerto_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner = null, OwnerID = 0, Triggered = false, Finished = false },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.robin_starry_concerto";
		this.m.Name = "$bv{effect.robin_starry_concerto.name}";
		this.m.Description = "$bv{effect.robin_starry_concerto.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/robin_myriad_tones_starry_fugue.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/robin_myriad_tones_starry_fugue_sw.png";
		this.m.IconMini <- "status_effect_56_mini";
	}
	function setupOwner( _owner ) { this.m.Owner=_owner==null?null:this.WeakTableRef(_owner); this.m.OwnerID=_owner==null?0:_owner.getID(); }
	function owner() { return this.m.Owner==null||this.m.Owner.isNull()?null:this.m.Owner; }
	function actor() { local c=this.getContainer(); return c==null?null:c.getActor(); }
	function onUpdate( _properties )
	{
		_properties.MeleeSkill += 15; _properties.RangedSkill += 15;
		_properties.MeleeDefense += 10; _properties.RangedDefense += 10;
		_properties.DamageTotalMult *= 1.30;
		_properties.MovementAPCostAdditional -= 1;
	}
	function isExcluded( _event )
	{
		local source="Source" in _event?_event.Source:null;
		return source=="aoo"||source=="riposte"||source=="counter"||source=="followup"||source=="fixed_damage"||source=="dot"||source=="damage_over_time"||source=="reflection"||source=="scenery";
	}
	function onValkyrieCombatEvent( _event )
	{
		local attacker=this.actor(); local robin=this.owner();
		if(this.m.Triggered||attacker==null||robin==null||_event==null||!("Type" in _event)||_event.Type!="TargetResolved"||this.isExcluded(_event))return;
		if(!("Attacker" in _event)||::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker)!=::$bvvar{namespace}.getValkyrieCombatObjectID(attacker))return;
		if(!("Hit" in _event)||!_event.Hit||!("Target" in _event)||_event.Target==null||!("Skill" in _event)||!::$bvvar{namespace}.isDirectAttack(_event.Skill))return;
		local damage=("HitpointDamage" in _event?_event.HitpointDamage:0)+("ArmorDamage" in _event?_event.ArmorDamage:0); if(damage<=0)return;
		this.m.Triggered=true;
		::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(robin,this,_event.Target,25,{ActionToken="ActionToken" in _event?_event.ActionToken:null,Source="robin_starry_concerto_echo"});
		if(!::$bvvar{namespace}.isActorDeadOrDying(attacker))
		{
			attacker.setHitpoints(this.Math.min(attacker.getHitpointsMax(),attacker.getHitpoints()+15));
			attacker.setFatigue(this.Math.max(0,attacker.getFatigue()-10)); attacker.setDirty(true);
		}
	}
	function onTurnStart() { this.m.Triggered=false; }
	function finish()
	{
		if(this.m.Finished)return; this.m.Finished=true;
		local passive=::$bvvar{namespace}.getRobinPassive(this.owner()); if(passive!=null)passive.finishConcertoRecipient();
		this.removeSelf();
	}
	function onTurnEnd() { this.finish(); }
	function onDeath( _fatalityType ) { this.finish(); }
	function onCombatFinished() { this.finish(); this.skill.onCombatFinished(); }
});
