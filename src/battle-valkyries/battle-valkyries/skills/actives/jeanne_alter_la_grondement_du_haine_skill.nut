this.jeanne_alter_la_grondement_du_haine_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { IsSpent = false, TargetSnapshot = null },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true; this.m.IsWeaponSkill = false;
		this.m.IsUsingHitchance = false; this.m.ActionPointCost = 5; this.m.FatigueCost = 30; this.m.MinRange = 2; this.m.MaxRange = 6; this.m.MaxLevelDifference = 99;
		this.m.IsSpent = false; this.m.TargetSnapshot = null;
	}
	function hasMeleeWeapon( _user )
	{
		local weapon = null;
		try { weapon = _user.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}
	function getCurse( _target )
	{
		if (_target == null) return null;
		try { return _target.getSkills().getSkillByID("$bvvar{modId}.effects.jeanne_alter_black_flame_curse"); } catch (e) { return null; }
	}
	function isValidTarget( _user, _target )
	{
		if (_user == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_user) || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return false;
		if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, _target, this.m.MaxRange, true)) return false;
		local distance = _user.getTile().getDistanceTo(_target.getTile());
		return distance >= this.m.MinRange && distance <= this.m.MaxRange;
	}
	function isUsable()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.skill.isUsable() && !this.m.IsSpent && owner != null && this.hasMeleeWeapon(owner);
	}
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		return this.isValidTarget(owner, _targetTile.getEntity());
	}
	function snapshotTargets( _user, _targetTile )
	{
		local ret = [];
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true)))
		{
			ret.push({ TargetRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(target), TargetID = ::$bvvar{namespace}.getValkyrieCombatObjectID(target), WasCursed = this.getCurse(target) != null });
		}
		return ret;
	}
	function resolveSnapshotTarget( _entry )
	{
		local target = _entry == null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(_entry.TargetRef);
		return target != null && ::$bvvar{namespace}.getValkyrieCombatObjectID(target) == _entry.TargetID ? target : null;
	}
	function applyBlackFlame( _user, _target )
	{
		local passive = _user == null ? null : _user.getSkills().getSkillByID("$bvvar{modId}.skill.jeanne_alter_dragon_witch");
		if (passive != null) return passive.applyBlackFlame(_target);
		return null;
	}
	function applyBuffBlock( _target )
	{
		local existing = null; try { existing = _target.getSkills().getSkillByID("$bvvar{modId}.effects.jeanne_alter_buff_block"); } catch (e) {}
		if (existing != null) { existing.onRefresh(); return existing; }
		local effect = this.new("$bvvar{privateFolder}/skills/effects/jeanne_alter_buff_block_effect"); if (effect != null) _target.getSkills().add(effect); return effect;
	}
	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		this.m.TargetSnapshot = this.snapshotTargets(_user, _targetTile);
		if (this.m.TargetSnapshot.len() == 0) { this.m.TargetSnapshot = null; return false; }
		this.m.IsSpent = true;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "jeanne_haine_cast");
		foreach (entry in this.m.TargetSnapshot)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user)) break;
			local target = this.resolveSnapshotTarget(entry);
			if (target == null || ::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "jeanne_noble_phantasm");
			local spec = { WeaponDamageMult = ("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? (entry.WasCursed ? 2.40 : 2.00) : (entry.WasCursed ? 1.80 : 1.50), ArmorDamageMult = 2.0, DirectDamageAdd = entry.WasCursed ? 0.10 : 0.0, HitChance = entry.WasCursed ? 45 : 30, IgnoreDistance = true, IgnoreShield = true, Source = "jeanne_alter_ruin" };
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, spec);
			if (result == null || !("Applied" in result) || !result.Applied || !("Hit" in result) || !result.Hit || ::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			if (entry.WasCursed)
			{
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, ("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 60 : 40, { Source = "jeanne_alter_noble_phantasm_fixed" });
			}
			if (::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			::$bvvar{namespace}.removeJeanneAlterPositiveEffects(target);
			this.applyBlackFlame(_user, target);
			this.applyBuffBlock(target);
		}
		this.m.TargetSnapshot = null;
		return true;
	}
	function onCombatStarted() { this.m.IsSpent = false; this.m.TargetSnapshot = null; }
	function onCombatFinished() { this.m.IsSpent = false; this.m.TargetSnapshot = null; this.skill.onCombatFinished(); }
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.jeanne_alter_la_grondement_du_haine.tooltip.attack}"},{id=5,type="text",icon="ui/icons/direct_damage.png",text="$bv{skill.jeanne_alter_la_grondement_du_haine.tooltip.curse}"}];if(this.m.IsSpent)ret.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.jeanne_alter_la_grondement_du_haine.tooltip.spent}"});return ret;
	}
});
