// Shared runner for Meltryllis only. Cooldowns use rounds, never wait/turn callbacks.
this.meltryllis_active_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Spec = null, ReadyRound = 0, AttackMultiplier = null },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsWeaponSkill = false; this.m.IsIgnoredAsAOO = true;
		this.m.IsRanged = false; this.m.MaxRangeBonus = 0;
	}
	function onValkyrieSkillBound(_definition)
	{
		this.m.Spec = _definition.Spec;
		local s = this.m.Spec;
		this.m.ActionPointCost = s.AP; this.m.FatigueCost = s.Fatigue;
		this.m.MinRange = s.MinRange; this.m.MaxRange = s.MaxRange;
		this.m.IsAttack = s.Attack; this.m.IsShieldRelevant = s.Attack && !s.Ultimate;
		this.m.IsUsingHitchance = s.Attack;
		this.m.DirectDamageMult = s.Ultimate ? 0.50 : 0.35;
		this.m.HitChanceBonus = s.Ultimate ? 25 : 0;
	}
	function owner() { return this.getContainer().getActor(); }
	function passive() { return this.getContainer().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("meltryllis_sadistic_constitution")); }
	function cooldown() { return this.Math.max(0, this.m.ReadyRound - this.Time.getRound()); }
	function isUsable() { return this.skill.isUsable() && this.cooldown() == 0; }
	function startCooldown() { this.m.ReadyRound = this.Time.getRound() + this.m.Spec.Cooldown; }
	function onVerifyTarget(_originTile, _targetTile)
	{
		if (_targetTile == null || !this.skill.onVerifyTarget(_originTile, _targetTile) || !_targetTile.IsOccupiedByActor) return false;
		if (!_originTile.hasLineOfSightTo(_targetTile, this.m.MaxRange)) return false;
		return _originTile.getDistanceTo(_targetTile) >= this.m.MinRange
			&& ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(), _targetTile.getEntity(), this.m.MaxRange, true);
	}
	function getAttackMultiplier()
	{
		if (this.m.AttackMultiplier != null) return this.m.AttackMultiplier;
		local p = this.passive(), absorb = this.getContainer().getSkillByID("$bvvar{modId}.effects.meltryllis_absorption");
		local mult = this.m.Spec.Ultimate ? (absorb != null ? 4.5 : 3.0) : 1.0;
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(this.owner(), this);
		if (context != null && (context.IsFree || context.Source != "managed_active")) return mult;
		return mult * (p == null ? 1.0 : p.getDamageMultiplier());
	}
	function onAnySkillUsed(_skill, _target, _properties)
	{
		if (_skill != this || !this.m.IsAttack) return;
		// Innate blades supply their own base; generic DamageTotalMult/perks remain intact.
		_properties.DamageRegularMin = 55; _properties.DamageRegularMax = 75;
		// BB rolls armor separately from DamageRegularMult. TotalMult scales both channels.
		_properties.DamageTotalMult *= this.getAttackMultiplier();
		_properties.DamageArmorMult = this.m.Spec.Ultimate ? 1.5 : 1.0;
		_properties.MeleeSkill += this.m.Spec.Ultimate ? 25 : 0;
		_properties.DamageAdditionalWithEachTile = 0;
		_properties.HitChanceAdditionalWithEachTile = 0;
	}
	function onUse(_user, _targetTile)
	{
		if (!this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local target = _targetTile.getEntity();
		this.m.AttackMultiplier = this.getAttackMultiplier();
		this.startCooldown();
		if (this.m.Spec.Ultimate)
		{
			this.getContainer().removeByID("$bvvar{modId}.effects.meltryllis_absorption");
			foreach (id in ["effects.shieldwall", "effects.spearwall", "effects.riposte"]) target.getSkills().removeByID(id);
		}
		local audio = "playValkyrieSkillAudio" in ::$bvvar{namespace};
		local position = audio && this.m.Spec.Ultimate ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
		if (audio) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, this.m.Spec.Ultimate ? "meltryllis_sarasvati_meltout_cast" : "meltryllis_blade_dance_cast");
		local hit = false;
		try { hit = this.attackEntity(_user, target, false); }
		catch (e) { this.m.AttackMultiplier = null; throw e; }
		this.m.AttackMultiplier = null;
		if (hit && position != null) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "meltryllis_sarasvati_meltout_impact", position);
		return true;
	}
	function reset() { this.m.ReadyRound = 0; this.m.AttackMultiplier = null; }
	function onCombatStarted() { this.reset(); }
	function onCombatFinished() { this.reset(); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/special.png",text="$bv{meltryllis.tooltip.cooldown}"+this.cooldown()}];
	}
});
