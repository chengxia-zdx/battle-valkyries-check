this.ye_shunguang_return_to_dust_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 25;
	}

	function getStance() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.ye_shunguang_qingming_stance"); }
	function getState() { local c = this.getContainer(); return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.ye_shunguang_enlightened_state"); }
	function hasMeleeWeapon()
	{
		local owner = this.getContainer() == null ? null : this.getContainer().getActor();
		if (owner == null) return false;
		local weapon = null;
		try { weapon = owner.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}
	function getTargets( _user ) { return _user == null ? [] : ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(), 2, true)); }
	function isUsable() { local owner = this.getContainer() == null ? null : this.getContainer().getActor(); return this.skill.isUsable() && this.hasMeleeWeapon() && this.getState() != null && this.getTargets(owner).len() > 0; }
	function getTooltip()
	{
		local state = this.getState();
		local spent = state == null ? 0 : state.getSpent();
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.damage_prefix}" + (120 + spent * 15) + "$bv{skill.ye_shunguang_return_to_dust.tooltip.damage_suffix}" },
			{ id = 6, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.fixed_prefix}" + (spent * 5) + "$bv{skill.ye_shunguang_return_to_dust.tooltip.fixed_suffix}" }
		];
		if (!this.isUsable()) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.ye_shunguang_return_to_dust.tooltip.not_ready}" });
		return ret;
	}
	function onUse( _user, _targetTile )
	{
		local state = this.getState();
		if (_user == null || state == null || !this.isUsable()) return false;
		local spent = state.getSpent();
		local targets = this.getTargets(_user);
		if (targets.len() == 0) return false;
		local context = ::$bvvar{namespace}.getCurrentValkyrieActionContext(_user, this);
		local actionToken = context != null && "ActionToken" in context ? context.ActionToken : null;
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "ye_shunguang_reflection_cast");
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "ye_dust_cast");
		local impactPlayed = false;
		foreach (target in targets)
		{
			local hitPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "ye_shunguang_dust");
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, {
				WeaponDamageMult = 1.20 + spent * 0.15, ArmorDamageMult = 1.25, DirectDamageAdd = spent * 0.05,
				HitChance = 25, IgnoreDistance = true, IgnoreShield = true, ParentActionToken = actionToken
			});
			if (!impactPlayed && result != null && "Hit" in result && result.Hit && hitPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.playValkyrieSkillAudio(_user, "ye_slash_impact", hitPosition);
				impactPlayed = true;
			}
			if (result != null && "Applied" in result && result.Applied && "Hit" in result && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target) && spent > 0)
			{
				::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, spent * 5, { ActionToken = actionToken, Source = "ye_shunguang_return_to_dust_fixed" });
			}
		}
		local stance = this.getStance();
		if (stance != null) stance.clear();
		this.getContainer().remove(state);
		return true;
	}
});
