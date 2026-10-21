this.the_herta_optimal_solution_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { MaxInspiration = 4 },

	function create()
	{
		this.valkyrie_passive_skill.create();
		this.m.MaxInspiration = 4;
	}

	function state() { return ::$bvvar{namespace}.HertaCombat.state(this.getContainer() == null ? null : this.getContainer().getActor()); }
	function getInspiration() { local s=this.state(); return s==null?0:s.Inspiration; }
	function hasFullInspiration() { return this.getInspiration() >= this.m.MaxInspiration; }
	function addInspiration( _amount )
	{
		return ::$bvvar{namespace}.HertaCombat.add(this.getContainer().getActor(), _amount);
	}
	function consumeAllInspiration()
	{
		if (!this.hasFullInspiration()) return false;
		this.state().Inspiration = 0;
		return true;
	}

	function isOrdinaryWeaponAttack( _skill, _target )
	{
		if (_skill == null || !_skill.isAttack() || !_skill.isActive()) return false;
		// Vanilla has m.IsWeaponSkill, not an isWeaponSkill() method. Read through
		// the m-table delegate as ordinary weapon skills can inherit this flag.
		try { if (!_skill.m.IsWeaponSkill) return false; }
		catch (e) { return false; }
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (actor == null) return false;
		// All Valkyrie-generated special weapon attacks carry a policy. Only a normal
		// weapon active may produce the once-per-turn inspiration point.
		return ::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target) == null;
	}

	function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		local s=this.state();
		if (s==null || !s.Active || s.GainSpent || !this.isOrdinaryWeaponAttack(_skill, _targetEntity)) return;
		s.GainSpent = true;
		this.addInspiration(1);
	}

	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() + "  [" + this.getInspiration() + "/" + this.m.MaxInspiration + "]" },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.the_herta_optimal_solution.tooltip.inspiration}" },
			{ id = 4, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.the_herta_optimal_solution.tooltip.calculation}" }
		];
	}

	function onTurnStart() { ::$bvvar{namespace}.HertaCombat.turn(this.getContainer().getActor()); }
	function onCombatStarted() { local s=this.state(); if(s!=null && !s.Active) ::$bvvar{namespace}.HertaCombat.start(this.getContainer().getActor()); }
	function onCombatFinished() { ::$bvvar{namespace}.HertaCombat.finish(this.getContainer().getActor()); this.skill.onCombatFinished(); }
	function onDeath( _fatalityType )
	{
		// A same-battle resurrection retains spent limits; only combat end clears the ledger.
		::$bvvar{namespace}.HertaAstrolabe.release(this.getContainer().getActor());
	}
});
