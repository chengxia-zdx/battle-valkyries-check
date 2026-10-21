this.ye_shunguang_reflection_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = false;
		this.m.IsTargetingActor = false;
		this.m.IsAttack = false;
		this.m.IsRanged = false;
		this.m.IsWeaponSkill = false;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 10;
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
	function isUsable() { local stance = this.getStance(); return this.skill.isUsable() && this.hasMeleeWeapon() && this.getState() == null && stance != null && stance.isReady(); }
	function getAdjacentTargets( _user )
	{
		if (_user == null) return [];
		return ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_user.getTile(), 1, true));
	}
	function getTooltip()
	{
		local ret = [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", text = this.getCostString() },
			{ id = 4, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.ye_shunguang_reflection.tooltip.hit}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{skill.ye_shunguang_reflection.tooltip.damage}" },
			{ id = 6, type = "text", icon = "ui/icons/special.png", text = "$bv{skill.ye_shunguang_reflection.tooltip.state}" }
		];
		if (!this.isUsable()) ret.push({ id = 7, type = "text", icon = "ui/tooltips/warning.png", text = "$bv{skill.ye_shunguang_reflection.tooltip.not_ready}" });
		return ret;
	}
	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable()) return false;
		local targets = this.getAdjacentTargets(_user);
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "ye_shunguang_reflection_cast");
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "ye_reflection_cast");
		local impactPlayed = false;
		foreach (target in targets)
		{
			local hitPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, target, "ye_shunguang_slash");
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, { WeaponDamageMult = 0.80, ArmorDamageMult = 1.0, DirectDamageAdd = 0.0, HitChance = 20, IgnoreDistance = true, IgnoreShield = false });
			if (!impactPlayed && result != null && "Hit" in result && result.Hit && hitPosition != null && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			{
				::$bvvar{namespace}.playValkyrieSkillAudio(_user, "ye_slash_impact", hitPosition);
				impactPlayed = true;
			}
		}
		local c = this.getContainer();
		local state = ::new("$bvvar{privateFolder}/skills/effects/ye_shunguang_enlightened_state_effect");
		if (state == null || c == null) return false;
		c.add(state);
		return true;
	}
});
