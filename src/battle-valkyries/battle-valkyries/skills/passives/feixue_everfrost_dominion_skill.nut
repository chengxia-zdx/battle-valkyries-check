this.feixue_everfrost_dominion_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m={GainsThisRound=0,HitActions=null},
	function create(){this.valkyrie_passive_skill.create();this.m.GainsThisRound=0;this.m.HitActions={};}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function getEffect(_id){local c=this.getContainer();return c==null?null:c.getSkillByID("$bvvar{modId}.effects."+_id);}
	function ensure(_id,_script){local effect=this.getEffect(_id);if(effect!=null)return effect;local c=this.getContainer();if(c==null)return null;effect=::new("$bvvar{privateFolder}/skills/effects/"+_script);if(effect!=null)c.add(effect);return effect;}
	function dedication(){return this.ensure("feixue_dedication","feixue_dedication_effect");} function foreclaimed(){return this.getEffect("feixue_foreclaimed_self");} function frost(){return this.ensure("feixue_frostharden_iai","feixue_frostharden_iai_effect");} function snow(){return this.ensure("feixue_snowforged_blade","feixue_snowforged_blade_effect");} function mushin(){return this.ensure("feixue_mushin","feixue_mushin_effect");}
	function isOwnActiveMeleeWeaponAttack( _event )
	{
		local actor = this.owner();
		if (_event == null || actor == null || !("Attacker" in _event) || _event.Attacker == null
			|| !("Skill" in _event) || !::$bvvar{namespace}.isActiveWeaponAttack(_event.Skill)) return false;
		if (::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Attacker) != ::$bvvar{namespace}.getValkyrieCombatObjectID(actor)) return false;
		local isRanged = false;
		try { isRanged = _event.Skill.isRanged(); }
		catch (e)
		{
			try { isRanged = _event.Skill.m.IsRanged; }
			catch (ignored) { return false; }
		}
		if (isRanged) return false;
		local source = ("Source" in _event) ? _event.Source : null;
		return source != "aoo" && source != "riposte" && source != "counter" && source != "followup"
			&& source != "fixed_damage" && source != "damage_over_time";
	}
	function enterForeclaimed(){local d=this.dedication();if(d!=null)d.clear();if(this.foreclaimed()==null)this.ensure("feixue_foreclaimed_self","feixue_foreclaimed_self_effect");local f=this.frost();if(f!=null)f.setCount(3);local s=this.snow();if(s!=null)s.clear();}
	function leaveForeclaimed(){local c=this.getContainer();if(c==null)return;local state=this.foreclaimed();if(state!=null)c.remove(state);local f=this.getEffect("feixue_frostharden_iai");if(f!=null)f.clear();local s=this.getEffect("feixue_snowforged_blade");if(s!=null)s.clear();local d=this.getEffect("feixue_dedication");if(d!=null)d.clear();}
	function grantIaiResolution(_target, _hit)
	{
		local snow = this.snow();
		if (snow != null) snow.addCount(1);
		local mushin = this.mushin();
		if (mushin != null) mushin.addCount(1);
		if (!_hit || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return;
		local glacio = _target.getSkills().getSkillByID("$bvvar{modId}.effects.feixue_glacio_bite");
		if (glacio == null)
		{
			glacio = ::new("$bvvar{privateFolder}/skills/effects/feixue_glacio_bite_effect");
			if (glacio != null) _target.getSkills().add(glacio);
		}
		if (glacio == null || glacio.addCount(1) < 3) return;
		glacio.clear();
		local frostbind = _target.getSkills().getSkillByID("$bvvar{modId}.effects.feixue_frostbind");
		if (frostbind == null)
		{
			frostbind = ::new("$bvvar{privateFolder}/skills/effects/feixue_frostbind_effect");
			if (frostbind != null) _target.getSkills().add(frostbind);
		}
		try { ::$bvvar{namespace}.addOrRefreshStatus(this.owner(), _target, { Type = "dazed", Turns = 1 }); } catch (e) {}
	}
	function resetRound(){this.m.GainsThisRound=0;this.m.HitActions={};}
	function resetCombat(){this.resetRound();this.leaveForeclaimed();local m=this.getEffect("feixue_mushin");if(m!=null)m.clear();local d=this.getEffect("feixue_dedication");if(d==null)d=this.dedication();if(d!=null)d.setCount(1);}
	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event)) return;
		if (_event.Type == "TargetResolved" && this.foreclaimed() == null && this.isOwnActiveMeleeWeaponAttack(_event)
			&& ("Hit" in _event) && _event.Hit)
		{
			local token = ("ActionToken" in _event) ? _event.ActionToken : null;
			if (token != null) this.m.HitActions[token] <- true;
			return;
		}
		if (_event.Type != "ActionResolved" || !("Actor" in _event) || _event.Actor == null || this.foreclaimed() != null) return;
		if (::$bvvar{namespace}.getValkyrieCombatObjectID(_event.Actor) != ::$bvvar{namespace}.getValkyrieCombatObjectID(this.owner())) return;
		local token = ("ActionToken" in _event) ? _event.ActionToken : null;
		if (token == null || !(token in this.m.HitActions)) return;
		delete this.m.HitActions[token];
		if (this.m.GainsThisRound >= 2) return;
		local dedication = this.dedication();
		if (dedication == null) return;
		this.m.GainsThisRound++;
		if (dedication.addCount(1) >= 3) this.enterForeclaimed();
	}
	function onTurnStart(){this.resetRound();local m=this.mushin();if(m!=null)m.clear();}
	function onCombatStarted(){this.resetCombat();} function onCombatFinished(){this.leaveForeclaimed();local m=this.mushin();if(m!=null)m.clear();local d=this.dedication();if(d!=null)d.clear();this.resetRound();this.skill.onCombatFinished();} function onDeath(_fatalityType){this.onCombatFinished();}
	function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{skill.feixue_everfrost_dominion.tooltip.dedication}"},{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.feixue_everfrost_dominion.tooltip.iai}"}];}
});
