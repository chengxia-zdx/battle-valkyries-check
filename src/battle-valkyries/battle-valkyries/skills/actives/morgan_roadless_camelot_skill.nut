this.morgan_roadless_camelot_skill <- this.inherit("$bvvar{privateFolder}/skills/core/morgan_spell_skill", {
	m = { LastUsedRound = -2 },
	function create()
	{
		this.morgan_spell_skill.create();
		this.m.ActionPointCost = 6; this.m.FatigueCost = 40; this.m.MinRange = 2; this.m.MaxRange = 7;
		this.m.IsAOE = true;
		this.m.ImpactTheme = "morgan_camelot_impact";
		this.m.SpellBase = 160; this.m.ResolveFactor = 0.6; this.m.SpellArmor = 2.0;
		this.m.SpellPierce = 0.40; this.m.DirectDamageMult = 0.40; this.m.SpellHit = 40;
	}
	function hasResources()
	{
		local passive = this.getPassive();
		return passive != null && passive.getMana() >= 6 && this.m.LastUsedRound != ::$bvvar{namespace}.getMorganRound();
	}
	function isUsable() { return this.skill.isUsable() && this.hasResources(); }
	function onTargetSelected( _tile )
	{
		foreach (target in ::$bvvar{namespace}.getMorganBlastTargets(this.getContainer().getActor(), _tile))
		{
			local tile = target.getTile();
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}
	function onUse( _user, _tile )
	{
		if (_user == null || !this.hasResources() || !this.onVerifyTarget(_user.getTile(), _tile)) return false;
		local targets = ::$bvvar{namespace}.getMorganBlastTargets(_user, _tile);
		if (targets.len() == 0 || !this.getPassive().consumeMana()) return false;
		this.m.LastUsedRound = ::$bvvar{namespace}.getMorganRound();
		this.m.CastResolve = _user.getCurrentProperties().getBravery();
		::$bvvar{namespace}.playValkyrieVisual(this, _user, "morgan_camelot_cast");
		local audio = "playValkyrieSkillAudio" in ::$bvvar{namespace};
		local impactPlayed = false;
		if (audio) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "morgan_roadless_camelot_cast");
		foreach (target in targets)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user)) break;
			if (::$bvvar{namespace}.isActorDeadOrDying(target)) continue;
			local mult = target.getTile().getDistanceTo(_tile) <= 1 ? 1.0 : 0.7;
			local position = audio && !impactPlayed ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
			local hit = this.strike(_user, target, mult);
			if (hit && position != null && !impactPlayed)
				impactPlayed = ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "morgan_roadless_camelot_impact", position);
			if (hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
				::$bvvar{namespace}.applyMorganEffect(target, "morgan_curse", _user);
		}
		this.m.CastResolve = null;
		if (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) && !::$bvvar{namespace}.isActorDeadOrDying(_user)) this.getPassive().addMana(2);
		return true;
	}
	function onCombatStarted() { this.m.LastUsedRound = -2; this.m.CastResolve = null; this.m.AreaMultiplier = 1.0; }
	function onCombatFinished() { this.onCombatStarted(); this.skill.onCombatFinished(); }
	function getTooltip()
	{
		local p = this.getPassive();
		local ret = [ {id=1,type="title",text=this.getName()+" ["+(p==null?0:p.getMana())+"/6]"},
			{id=2,type="description",text=this.getDescription()}, {id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.morgan_roadless_camelot.tooltip.damage}"},
			{id=5,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.morgan_roadless_camelot.tooltip.target}"},
			{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.morgan_roadless_camelot.tooltip.curse}"} ];
		if (!this.hasResources()) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.morgan_roadless_camelot.tooltip.unready}"});
		return ret;
	}
});
