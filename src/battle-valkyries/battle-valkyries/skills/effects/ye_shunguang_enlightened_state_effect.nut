this.ye_shunguang_enlightened_state_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Spent = 0, BlockUsed = false },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.ye_shunguang_enlightened_state";
		this.m.Name = "$bv{effect.ye_shunguang_enlightened_state.name}";
		this.m.Description = "$bv{effect.ye_shunguang_enlightened_state.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/ye_shunguang_cut_filth.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/ye_shunguang_cut_filth_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		this.m.Spent = 0;
		this.m.BlockUsed = false;
	}

	function isActiveState() { return true; }
	function getOwner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function onAdded()
	{
		local actor = this.getOwner();
		if (actor != null && "setActorTemporaryValkyrieSkin" in ::$bvvar{namespace})
			::$bvvar{namespace}.setActorTemporaryValkyrieSkin(actor, "ye_shunguang_enlightened_skin");
	}
	function onRemoved()
	{
		local actor = this.getOwner();
		if (actor != null && "getActorTemporaryValkyrieSkinID" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.getActorTemporaryValkyrieSkinID(actor) == "ye_shunguang_enlightened_skin")
			::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(actor);
	}
	function getSpent() { return this.Math.max(0, this.m.Spent); }
	function addSpent( _amount = 1 ) { this.m.Spent = this.Math.min(6, this.getSpent() + _amount); return this.m.Spent; }
	function resetRoundBlock() { this.m.BlockUsed = false; }

	function getStance()
	{
		local c = this.getContainer();
		return c == null ? null : c.getSkillByID("$bvvar{modId}.effects.ye_shunguang_qingming_stance");
	}

	function consumeStance()
	{
		local stance = this.getStance();
		if (stance == null || !stance.consumeCount(1)) return false;
		this.addSpent(1);
		return true;
	}

	function getValkyrieAttackNullificationPolicy( _usedSkill, _attacker )
	{
		if (this.m.BlockUsed || _usedSkill == null || _attacker == null || !::$bvvar{namespace}.isDirectAttack(_usedSkill)) return null;
		local stance = this.getStance();
		if (stance == null || stance.getCount() <= 0) return null;
		return { NullifyDirectAttack = true, ConsumeToken = "ye_shunguang_enlightened_block" };
	}

	function consumeValkyrieAttackNullificationPolicy( _token, _context )
	{
		if (_token != "ye_shunguang_enlightened_block" || this.m.BlockUsed) return;
		if (this.consumeStance())
		{
			this.m.BlockUsed = true;
			if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(this.getOwner(), "ye_mirror_block");
			if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, this.getOwner(), "ye_shunguang_reflection_cast");
		}
	}

	function onValkyrieCombatEvent( _event ) { if (_event != null && "Type" in _event && _event.Type == "NewRound") this.resetRoundBlock(); }
	function getTooltip()
	{
		return [
			{ id = 1, type = "title", text = this.getName() },
			{ id = 2, type = "description", text = this.getDescription() },
			{ id = 3, type = "text", icon = "ui/icons/action_points.png", text = "$bv{effect.ye_shunguang_enlightened_state.tooltip.flow}" },
			{ id = 4, type = "text", icon = "ui/icons/special.png", text = "$bv{effect.ye_shunguang_enlightened_state.tooltip.block}" },
			{ id = 5, type = "text", icon = "ui/icons/regular_damage.png", text = "$bv{effect.ye_shunguang_enlightened_state.tooltip.spent_prefix}" + this.getSpent() + "$bv{effect.ye_shunguang_enlightened_state.tooltip.spent_suffix}" }
		];
	}

	function onCombatFinished() { this.onRemoved(); this.m.Spent = 0; this.resetRoundBlock(); this.skill.onCombatFinished(); }
});
