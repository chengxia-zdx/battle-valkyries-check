this.nahida_seed_of_skandha_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { OwnerRef = null, OwnerID = null, NetworkToken = null, ExpireRound = 0 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.nahida_seed_of_skandha";
		this.m.Name = "$bv{effect.nahida_seed_of_skandha.name}";
		this.m.Description = "$bv{effect.nahida_seed_of_skandha.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/nahida_seed_of_skandha.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/nahida_seed_of_skandha_sw.png";
		this.m.IsHidden = false;
		this.m.IsStacking = false;
	}

	function getRound()
	{
		try { return this.Time.getRound(); } catch (e) { return 0; }
	}

	function setup( _owner, _networkToken, _duration )
	{
		this.m.OwnerRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_owner);
		this.m.OwnerID = ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner);
		this.m.NetworkToken = _networkToken;
		this.m.ExpireRound = this.getRound() + this.Math.max(1, _duration);
		return this;
	}

	function getOwner()
	{
		return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef);
	}

	function isOwnedBy( _owner )
	{
		return _owner != null && this.m.OwnerID != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(_owner) == this.m.OwnerID;
	}

	function belongsToNetwork( _token )
	{
		return typeof _token == "string" && _token == this.m.NetworkToken;
	}

	function addRounds( _rounds )
	{
		this.m.ExpireRound += this.Math.max(0, _rounds);
	}

	function getRemainingRounds()
	{
		return this.Math.max(0, this.m.ExpireRound - this.getRound());
	}

	function isValid()
	{
		local owner = this.getOwner();
		return owner != null && !::$bvvar{namespace}.isActorDeadOrDying(owner) && this.getRemainingRounds() > 0;
	}

	function onNewRound()
	{
		if (!this.isValid()) this.removeSelf();
	}

	function onDeath( _fatalityType )
	{
		this.removeSelf();
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.nahida_seed_of_skandha.tooltip.rounds_prefix}" + this.getRemainingRounds() + "$bv{effect.nahida_seed_of_skandha.tooltip.rounds_suffix}" }
		];
	}
});
