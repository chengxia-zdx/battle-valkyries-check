this.morgan_holy_lance_skill <- this.inherit("$bvvar{privateFolder}/skills/core/morgan_spell_skill", {
	function create()
	{
		this.morgan_spell_skill.create();
		this.m.ActionPointCost = 4; this.m.FatigueCost = 18; this.m.MinRange = 1; this.m.MaxRange = 6;
	}
	function onUse( _user, _tile )
	{
		if (_user == null || !this.onVerifyTarget(_user.getTile(), _tile)) return false;
		this.m.CastResolve = _user.getCurrentProperties().getBravery();
		::$bvvar{namespace}.playValkyrieVisual(this, _user, "morgan_cast");
		local audio = "playValkyrieSkillAudio" in ::$bvvar{namespace};
		local position = audio ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(_tile.getEntity()) : null;
		if (audio) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "morgan_holy_lance_cast");
		local hit = this.strike(_user, _tile.getEntity(), 1.0);
		if (hit && position != null) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "morgan_holy_lance_impact", position);
		this.m.CastResolve = null;
		local passive = this.getPassive();
		if (hit && passive != null && !::$bvvar{namespace}.isActorDeadOrDying(_user)) passive.onLanceHit();
		return true;
	}
	function getTooltip()
	{
		return [ {id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.morgan_holy_lance.tooltip.damage}"},
			{id=5,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.morgan_holy_lance.tooltip.target}"},
			{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.morgan_holy_lance.tooltip.winter}"} ];
	}
});
