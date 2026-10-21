this.jeanne_holy_banner_aura_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner = null, OwnerID = 0, LastRecoveryRound = -2, MoraleRescueUsed = false },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_holy_banner_aura";
		this.m.Name = "$bv{effect.jeanne_holy_banner_aura.name}";
		this.m.Description = "$bv{effect.jeanne_holy_banner_aura.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_revelation_holy_banner.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_revelation_holy_banner_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
	}

	function setupOwner( _owner ) { this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner); this.m.OwnerID = _owner == null ? 0 : _owner.getID(); }
	function getOwner()
	{
		if (this.m.Owner == null || this.m.Owner.isNull()) return null;
		local owner = this.m.Owner;
		return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner;
	}
	function isOwnedBy( _owner ) { return _owner != null && this.m.OwnerID != 0 && this.m.OwnerID == _owner.getID(); }
	function getRecoveryAmount() { return ::$bvvar{namespace}.getJeanneAuraFatigueRecovery(this.getOwner()); }

	function isInAura()
	{
		local owner = this.getOwner();
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null || actor == null || !::$bvvar{namespace}.hasJeanneLegalBannerWeapon(owner)
			|| !::$bvvar{namespace}.isEligibleRosterAlly(owner, actor)
			|| !owner.isPlacedOnMap() || !actor.isPlacedOnMap()) return false;
		local passive = ::$bvvar{namespace}.getJeanneHolyBannerSkill(owner);
		local range = passive == null ? 4 : passive.getAuraRange();
		return owner.getTile().getDistanceTo(actor.getTile()) <= range;
	}

	function onUpdate( _properties )
	{
		if (!this.isInAura()) return;
		local bonus = ("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getOwner())) ? 15 : 10;
		_properties.Bravery += bonus;
		_properties.MeleeSkill += bonus;
		_properties.RangedSkill += bonus;
		_properties.MeleeDefense += bonus;
		_properties.RangedDefense += bonus;
	}

	function onTurnStart()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (!this.isInAura() || !::$bvvar{namespace}.isJeanneNormalTurnStart(actor)) return;
		local round = -1;
		try { round = this.Time.getRound(); } catch (e) { round = -1; }
		if (this.m.LastRecoveryRound == round) return;
		this.m.LastRecoveryRound = round;
		actor.setFatigue(this.Math.max(0, actor.getFatigue() - this.getRecoveryAmount()));
		local owner = this.getOwner();
		if (!this.m.MoraleRescueUsed && ::$bvvar{namespace}.hasJeanneBondUpgrade(owner, 20) && ::$bvvar{namespace}.improveJeanneMoraleOneStep(actor))
		{
			this.m.MoraleRescueUsed = true;
		}
		actor.setDirty(true);
	}

	function isHidden() { return !this.isInAura(); }
	function getTooltip()
	{
		local owner = this.getOwner();
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_holy_banner_aura.tooltip.owner}" + (owner == null ? "$bv{effect.jeanne.owner_missing}" : owner.getName()) },
			{ id=4, type="text", icon="ui/icons/bravery.png", text="$bv{effect.jeanne_holy_banner_aura.tooltip.stats}" },
			{ id=5, type="text", icon="ui/icons/fatigue.png", text="$bv{effect.jeanne_holy_banner_aura.tooltip.fatigue_prefix}" + this.getRecoveryAmount() + "$bv{effect.jeanne_holy_banner_aura.tooltip.fatigue_suffix}" }
		];
	}
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
});
