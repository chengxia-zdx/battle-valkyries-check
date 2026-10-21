this.jeanne_holy_maiden_blessing_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner = null, OwnerID = 0, TurnsLeft = 2, ConsumedThisTurn = false, LastTickRound = -2 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_holy_maiden_blessing";
		this.m.Name = "$bv{effect.jeanne_holy_maiden_blessing.name}";
		this.m.Description = "$bv{effect.jeanne_holy_maiden_blessing.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle_sw.png";
		this.m.IconMini <- "status_effect_56_mini";
		this.m.IsStacking = false;
		this.m.LastTickRound = -2;
		::$bvvar{namespace}.resetJeanneHolyBuffDuration(this);
	}

	function setupOwner( _owner ) { this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner); this.m.OwnerID = _owner == null ? 0 : _owner.getID(); }
	function getOwner() { if (this.m.Owner == null || this.m.Owner.isNull()) return null; local owner=this.m.Owner; return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner; }
	function isOwnedBy( _owner ) { return _owner != null && this.m.OwnerID != 0 && this.m.OwnerID == _owner.getID(); }
	function getHealingPerTurn() { return ::$bvvar{namespace}.getJeanneBlessingHealing(this.getOwner()); }
	function onRefresh() { ::$bvvar{namespace}.resetJeanneHolyBuffDuration(this); }

	function onUpdate( _properties )
	{
		if (this.getOwner() == null) return;
		_properties.MeleeDefense += 10;
		_properties.RangedDefense += 10;
	}

	function onTurnStart()
	{
		if (!::$bvvar{namespace}.beginJeanneHolyBuffTurn(this)) return;
		local actor = this.getContainer().getActor();
		actor.setHitpoints(this.Math.min(actor.getHitpointsMax(), actor.getHitpoints() + this.getHealingPerTurn()));
		actor.setDirty(true);
		try { if (actor.isPlacedOnMap()) this.spawnIcon("status_effect_56", actor.getTile()); } catch (e) {}
	}

	function onTurnEnd()
	{
		::$bvvar{namespace}.endJeanneHolyBuffTurn(this);
	}
	function isHidden() { return this.getOwner() == null; }
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/melee_defense.png", text="$bv{effect.jeanne_holy_maiden_blessing.tooltip.defense}" },
			{ id=4, type="text", icon="ui/icons/health.png", text="$bv{effect.jeanne_holy_maiden_blessing.tooltip.heal_prefix}" + this.getHealingPerTurn() + "$bv{effect.jeanne_holy_maiden_blessing.tooltip.heal_middle}" + this.Math.max(0, this.m.TurnsLeft - (this.m.ConsumedThisTurn ? 1 : 0)) + "$bv{effect.jeanne_holy_maiden_blessing.tooltip.heal_suffix}" },
			{ id=5, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_holy_maiden_blessing.tooltip.duration}" }
		];
	}
});
