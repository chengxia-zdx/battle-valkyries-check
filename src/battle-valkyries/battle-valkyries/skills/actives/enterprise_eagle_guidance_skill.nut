this.enterprise_eagle_guidance_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {PrimaryRef=null, ImpactPosition=null, ImpactPlayed=false},
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true; this.m.IsRanged = true;
		this.m.IsWeaponSkill = true; this.m.IsUsingHitchance = true; this.m.IsIgnoredAsAOO = true;
		// Resolve synchronously; the custom arrow trail supplies the flight visual.
		this.m.IsShowingProjectile = false; this.m.ProjectileType = this.Const.ProjectileType.Arrow;
		this.m.IsDoingAttackMove = false; this.m.ActionPointCost = 3; this.m.FatigueCost = 8;
		this.m.MinRange = 2; this.m.MaxRange = 6; this.m.MaxLevelDifference = 4;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody; this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
	}
	function owner() { return this.getContainer().getActor(); }
	function getMaxRange() { return ::$bvvar{namespace}.hasEnterpriseSignatureBow(this.owner()) ? 7 : 6; }
	function bow()
	{
		local item = this.owner().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item == null || !item.isItemType(this.Const.Items.ItemType.RangedWeapon)) return null;
		try { return item.getAmmoID() == "ammo.arrows" ? item : null; } catch (e) { return null; }
	}
	function arrows()
	{
		local item = this.owner().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);
		return item != null && item.getAmmoType() == this.Const.Items.AmmoType.Arrows && item.getAmmo() > 0 ? item : null;
	}
	function isUsable() { return this.skill.isUsable() && ::$bvvar{namespace}.canEnterpriseCommand(this.owner()) && this.bow() != null && this.arrows() != null; }
	function onAfterUpdate(_properties)
	{
		local bow = this.bow(); this.setItem(bow);
		this.m.DirectDamageMult = bow == null ? 0.35 : bow.m.DirectDamageMult;
		this.m.FatigueCostMult = _properties.IsSpecializedInBows ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	function onVerifyTarget(_origin, _tile)
	{
		return _tile != null && _tile.IsOccupiedByActor && this.skill.onVerifyTarget(_origin, _tile)
			&& _origin.getDistanceTo(_tile) >= 2
			&& ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(), _tile.getEntity(), this.getMaxRange(), true)
			&& !_tile.getEntity().isHiddenToPlayer();
	}
	function onAnySkillUsed(_skill, _target, _properties)
	{
		if (_skill != this) return;
		local bow = this.bow();
		_properties.RangedSkill += 10 + (bow == null ? 0 : bow.getAdditionalAccuracy());
		_properties.HitChanceAdditionalWithEachTile -= 4;
		if (_properties.IsSharpshooter) _properties.DamageDirectMult += 0.05;
	}
	function onTargetHit(_skill, _target, _bodyPart, _hp, _armor)
	{
		if (_skill != this) return;
		if (!this.m.ImpactPlayed && this.m.ImpactPosition != null)
		{
			::$bvvar{namespace}.playValkyrieSkillAudio(this.owner(), "enterprise_eagle_guidance_impact", this.m.ImpactPosition);
			this.m.ImpactPlayed = true;
		}
		if (_target == ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.PrimaryRef))
			::$bvvar{namespace}.setEnterpriseMark(this.owner(), _target);
	}
	function onBeforeTargetHit(_skill, _target, _hitInfo)
	{
		if (_skill == this) this.m.ImpactPosition = ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(_target);
	}
	function onUse(_user, _tile)
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _tile)) return false;
		this.m.PrimaryRef = ::$bvvar{namespace}.makeValkyrieCombatWeakRef(_tile.getEntity());
		this.m.ImpactPosition = null; this.m.ImpactPlayed = false;
		this.arrows().consumeAmmo();
		::$bvvar{namespace}.playValkyrieSkillAudio(_user, "enterprise_eagle_guidance_cast");
		::$bvvar{namespace}.playValkyrieVisual(this, _tile.getEntity(), "enterprise_arrow_trail");
		try
		{
			this.attackEntity(_user, _tile.getEntity(), true);
		}
		catch (e) { this.m.PrimaryRef = null; this.m.ImpactPosition = null; throw e; }
		this.m.PrimaryRef = null; this.m.ImpactPosition = null;
		return true;
	}
	function getTooltip()
	{
		local ret = [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()}, {id=3,type="text",text=this.getCostString()}];
		if (this.bow() == null || this.arrows() == null) ret.push({id=4,type="text",icon="ui/tooltips/warning.png",text="$bv{enterprise.guidance.weapon_required}"});
		if (::$bvvar{namespace}.hasEnterpriseSignatureBow(this.owner())) ret.push({id=6,type="text",icon="ui/icons/special.png",text="$bv{enterprise.signature.active}"});
		if (!::$bvvar{namespace}.canEnterpriseCommand(this.owner())) ret.push({id=5,type="text",icon="ui/tooltips/warning.png",text="$bv{enterprise.command.blocked}"});
		return ret;
	}
});
