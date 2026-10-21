this.jeanne_holy_flag_protection_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner = null, OwnerID = 0, TurnsLeft = 2, ConsumedThisTurn = false, LastTickRound = -2 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_holy_flag_protection";
		this.m.Name = "$bv{effect.jeanne_holy_flag_protection.name}";
		this.m.Description = "$bv{effect.jeanne_holy_flag_protection.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.Overlay <- "status_effect_34";
		this.m.IsStacking = false;
		this.m.LastTickRound = -2;
		::$bvvar{namespace}.resetJeanneHolyBuffDuration(this);
	}

	function setupOwner( _owner ) { this.m.Owner = _owner == null ? null : this.WeakTableRef(_owner); this.m.OwnerID = _owner == null ? 0 : _owner.getID(); }
	function getOwner() { if (this.m.Owner == null || this.m.Owner.isNull()) return null; local owner=this.m.Owner; return ::$bvvar{namespace}.isActorDeadOrDying(owner) ? null : owner; }
	function isOwnedBy( _owner ) { return _owner != null && this.m.OwnerID != 0 && this.m.OwnerID == _owner.getID(); }
	function onRefresh() { ::$bvvar{namespace}.resetJeanneHolyBuffDuration(this); }
	function onTurnStart() { ::$bvvar{namespace}.beginJeanneHolyBuffTurn(this); }
	function onTurnEnd() { ::$bvvar{namespace}.endJeanneHolyBuffTurn(this); }
	function getValkyrieAttackNullificationPolicy( _usedSkill, _attacker )
	{
		return this.getOwner() == null || _usedSkill == null || this.m.TurnsLeft <= 0 ? null : { NullifyDirectAttack=true };
	}
	function isHidden() { return this.getOwner() == null; }
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_holy_flag_protection.tooltip.block}" },
			{ id=4, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_holy_flag_protection.tooltip.duration_prefix}" + this.m.TurnsLeft + "$bv{effect.jeanne_holy_flag_protection.tooltip.duration_suffix}" },
			{ id=5, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_holy_flag_protection.tooltip.exceptions}" }
		];
	}
});
