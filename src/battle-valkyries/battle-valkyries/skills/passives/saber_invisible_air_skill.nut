this.saber_invisible_air_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { OffenseSpent = false, DefenseSpent = false },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.OffenseSpent = false;
		this.m.DefenseSpent = false;
	}

	function getManaEffect()
	{
		local container = this.getContainer();
		return container == null ? null : container.getSkillByID("$bvvar{modId}.effects.saber_mana");
	}

	function ensureManaEffect()
	{
		local effect = this.getManaEffect();
		if (effect != null) return effect;
		local container = this.getContainer();
		if (container == null) return null;
		effect = ::new("$bvvar{privateFolder}/skills/effects/saber_mana_effect");
		container.add(effect);
		return effect;
	}

	function isOwner( _actor )
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return owner != null && _actor != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
	}

	function isOrdinaryMeleeWeaponAttack( _skill )
	{
		return _skill != null && ::$bvvar{namespace}.isActiveWeaponAttack(_skill) && !_skill.isRanged();
	}

	function isExcludedSource( _source )
	{
		return _source == "aoo" || _source == "riposte" || _source == "followup" || _source == "fixed"
			|| _source == "dot" || _source == "terrain" || _source == "reflection" || _source == "saber_excalibur_fixed";
	}

	function isDirectActionSource( _source )
	{
		return _source == "direct" || _source == "free" || _source == "managed_active" || _source == "unknown/direct";
	}

	function isDefenseDamageSource( _source )
	{
		return _source != null && (
			!this.isExcludedSource(_source)
			|| _source == "aoo"
			|| _source == "riposte"
			|| _source == "followup"
		);
	}

	function ignoresShieldFor( _usedSkill )
	{
		return this.isOrdinaryMeleeWeaponAttack(_usedSkill);
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_properties == null || !this.isOrdinaryMeleeWeaponAttack(_skill)) return;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		local frame = owner == null ? null : ::$bvvar{namespace}.getCurrentValkyrieCombatSource(owner, _skill);
		local source = frame == null ? null : frame.Source;
		if (source == null || this.isDirectActionSource(source)) _properties.MeleeSkill += 10;
	}

	function bond(stage)
    {
        return "hasSaberBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberBondUpgrade(this.getContainer().getActor(),stage);
    }
    function onTurnStart()
    {
        local actor=this.getContainer()==null?null:this.getContainer().getActor();
        if (actor==null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !this.bond(40)) return;
        if (!::$bvvar{namespace}.isJeanneNormalTurnStart(actor)) return;
        local round=this.Time.getRound();
        local flags=actor.getFlags();
        if (round<=1 || flags.get("BVSaberManaRegenRound")==round) return;
        flags.set("BVSaberManaRegenRound",round);
        this.addMana(1);
    }
    function addMana( _amount = 1 )
	{
		local effect = this.ensureManaEffect();
		if (effect == null) return 0;
		local before = effect.getCount();
		local count = effect.addCount(_amount);
		if (before < 4 && count == 4 && "playValkyrieVisual" in ::$bvvar{namespace})
            ::$bvvar{namespace}.playValkyrieVisual(this,this.getContainer().getActor(),"saber_mana_ready");
		if (before < 4 && count == 4 && "playValkyrieSkillAudio" in ::$bvvar{namespace})
		{
			local ultimate = this.getContainer().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("saber_excalibur"));
			if (ultimate != null && !ultimate.m.IsSpent && ultimate.hasMeleeWeapon())
				::$bvvar{namespace}.playValkyrieSkillAudio(this.getContainer().getActor(), "saber_mana_ready");
		}
		return count;
	}

	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "TargetResolved")
		{
			if (this.m.OffenseSpent || !("Hit" in _event) || !_event.Hit || ("Nullified" in _event && _event.Nullified)
				|| !("ActionToken" in _event) || _event.ActionToken == null
				|| !this.isOwner("Attacker" in _event ? _event.Attacker : null)
				|| !this.isOrdinaryMeleeWeaponAttack("Skill" in _event ? _event.Skill : null)
				|| !this.isDirectActionSource("Source" in _event ? _event.Source : null)) return;
			this.m.OffenseSpent = true;
			local owner=this.getContainer().getActor();
            local extra="hasSaberOathSword" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberOathSword(owner);
            this.addMana(extra?2:1);
			return;
		}
		if (_event.Type != "DamageResolved" || this.m.DefenseSpent
			|| !this.isOwner("Victim" in _event ? _event.Victim : null)
			|| !("ActionToken" in _event) || _event.ActionToken == null
			|| !("Attacker" in _event) || _event.Attacker == null
			|| !("Skill" in _event) || !::$bvvar{namespace}.isDirectAttack(_event.Skill)
			|| !this.isDefenseDamageSource("Source" in _event ? _event.Source : null)
			|| (("HitpointDamage" in _event ? _event.HitpointDamage : 0) + ("ArmorDamage" in _event ? _event.ArmorDamage : 0) < 1)) return;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null || _event.Attacker.isAlliedWith(owner)) return;
		this.m.DefenseSpent = true;
		this.addMana(1);
	}

	function getTooltip()
	{
		local ret = [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/hitchance.png", text="$bv{skill.saber_invisible_air.tooltip.attack}" },
			{ id=4, type="text", icon="ui/icons/special.png", text="$bv{skill.saber_invisible_air.tooltip.shield}" },
			{ id=5, type="text", icon="ui/icons/fatigue.png", text="$bv{skill.saber_invisible_air.tooltip.mana}" }
		];
        if (this.bond(20)) ret.push({id=20,type="text",icon="ui/icons/special.png",text="$bv{skill.saber_invisible_air.bond_start}"});
        if (this.bond(40)) ret.push({id=21,type="text",icon="ui/icons/fatigue.png",text="$bv{skill.saber_invisible_air.bond_regen}"});
        if (this.bond(100)) ret.push({id=22,type="text",icon="ui/icons/special.png",text="$bv{skill.saber_invisible_air.bond_full}"});
        return ret;
	}

	function resetTurnState() { this.m.OffenseSpent = false; this.m.DefenseSpent = false; }
	function onNewRound() { this.resetTurnState(); }
	function onCombatStarted()
    {
        this.resetTurnState(); local e=this.ensureManaEffect(); local actor=this.getContainer().getActor();
        if ("getFlags" in actor) actor.getFlags().set("BVSaberManaRegenRound",-1);
        if(e!=null)e.setCount("getSaberStartingMana" in ::$bvvar{namespace} ? ::$bvvar{namespace}.getSaberStartingMana(actor) : (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(actor))?2:1));
    }
	function onCombatFinished() { this.resetTurnState(); local e=this.getManaEffect(); if(e!=null)e.clear(); this.skill.onCombatFinished(); }
});
