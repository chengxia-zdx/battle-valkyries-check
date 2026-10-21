this.morgan_from_worlds_end_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Mana = 0, LastNormalRound = -2, LanceRound = -2, LanceGains = 0, GutsSpent = false, Protected = false, DamageFrame = null, InCombat = false },
	function create() { this.valkyrie_passive_skill.create(); }
	function getMana() { return this.m.Mana; }
	function addMana( _amount )
	{
		local before = this.m.Mana;
		this.m.Mana = this.Math.min(6, this.Math.max(0, before + _amount));
		if (before < 6 && this.m.Mana == 6)
		{
			::$bvvar{namespace}.playValkyrieVisual(this, this.getContainer().getActor(), "morgan_ready");
			if (this.m.InCombat && "playValkyrieSkillAudio" in ::$bvvar{namespace})
				::$bvvar{namespace}.playValkyrieSkillAudio(this.getContainer().getActor(), "morgan_from_worlds_end_ready");
		}
	}
	function consumeMana()
	{
		if (this.m.Mana < 6) return false;
		this.m.Mana = 0;
		return true;
	}
	function onLanceHit()
	{
		local round = ::$bvvar{namespace}.getMorganRound();
		if (this.m.LanceRound != round) { this.m.LanceRound = round; this.m.LanceGains = 0; }
		if (this.m.LanceGains >= 2) return;
		this.m.LanceGains++;
		this.addMana(1);
	}
	function onTurnStart()
	{
		local owner = this.getContainer().getActor();
		if (!this.m.InCombat || !::$bvvar{namespace}.isMorganNormalTurn(owner)) return;
		local round = ::$bvvar{namespace}.getMorganRound();
		if (this.m.LastNormalRound == round) return;
		this.m.LastNormalRound = round;
		this.m.Protected = false;
		this.addMana(1);
	}
	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.Protected && _skill != null && _skill.isAttack()) _properties.DamageReceivedTotalMult *= 0.5;
	}
	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		local frame = this.m.DamageFrame;
		local owner = this.getContainer().getActor();
		local beforeHP = frame != null && "BeforeHP" in frame ? frame.BeforeHP : owner.getHitpoints();
		if (!this.m.InCombat || this.m.GutsSpent || frame == null || frame.Triggered || !frame.CouldDie
			|| _damageHitpoints <= 0 || _damageHitpoints < beforeHP) return;
		// Called by the engine after armor/reduction, but BEFORE HP and death.
		this.m.GutsSpent = true;
		this.m.Protected = true;
		frame.Triggered = true;
		owner.setIsAbleToDie(false);
	}
	function resetCombat( _active )
	{
		this.m.Mana = _active ? (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 4 : 2) : 0;
		this.m.InCombat = _active;
		this.m.LastNormalRound = -2; this.m.LanceRound = -2; this.m.LanceGains = 0;
		this.m.GutsSpent = false; this.m.Protected = false; this.m.DamageFrame = null;
	}
	function onCombatStarted() { this.resetCombat(true); }
	function onCombatFinished() { this.resetCombat(false); this.skill.onCombatFinished(); }
	function onDeath( _fatalityType ) { this.resetCombat(false); }
	function getTooltip()
	{
		local ret = [
			{id=1,type="title",text=this.getName()+" ["+this.m.Mana+"/6]"},
			{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text="$bv{skill.morgan_from_worlds_end.tooltip.mana}"},
			{id=4,type="text",icon="ui/icons/health.png",text="$bv{skill.morgan_from_worlds_end.tooltip.guts}"}
		];
		if (this.m.GutsSpent) ret.push({id=5,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.morgan_from_worlds_end.tooltip.spent}"});
		if (this.m.Protected) ret.push({id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.morgan_from_worlds_end.tooltip.protected}"});
		return ret;
	}
});
