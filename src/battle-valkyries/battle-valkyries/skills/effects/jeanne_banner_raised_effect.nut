this.jeanne_banner_raised_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { CastRound = -1 },

	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.jeanne_banner_raised";
		this.m.Name = "$bv{effect.jeanne_banner_raised.name}";
		this.m.Description = "$bv{effect.jeanne_banner_raised.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/jeanne_luminosite_eternelle_sw.png";
		this.m.IconMini <- "status_effect_34_mini";
		this.m.IsStacking = false;
		try { this.m.CastRound = this.Time.getRound(); } catch (e) { this.m.CastRound = -1; }
	}
	function onRefresh() { try { this.m.CastRound = this.Time.getRound(); } catch (e) { this.m.CastRound = -1; } }
	function blocksValkyrieSkillUse( _skill )
	{
		if (_skill == null) return false;
		try { return _skill.isAttack(); } catch (e) { return false; }
	}

	function onTurnStart()
	{
		local actor = this.getContainer() == null ? null : this.getContainer().getActor();
		if (!::$bvvar{namespace}.isJeanneNormalTurnStart(actor)) return;
		local round = -1;
		try { round = this.Time.getRound(); } catch (e) { round = -1; }
		if (this.m.CastRound < 0 || round > this.m.CastRound) this.removeSelf();
	}
	function onDeath( _fatalityType ) { this.removeSelf(); }
	function getTooltip()
	{
		return [
			{ id=1, type="title", text=this.getName() },
			{ id=2, type="description", text=this.getDescription() },
			{ id=3, type="text", icon="ui/icons/action_points.png", text="$bv{effect.jeanne_banner_raised.tooltip.attack}" },
			{ id=4, type="text", icon="ui/icons/special.png", text="$bv{effect.jeanne_banner_raised.tooltip.duration}" }
		];
	}
});
