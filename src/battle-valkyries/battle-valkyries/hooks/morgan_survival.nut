::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local passive = ::$bvvar{namespace}.getRuntimeSkillByKey(this, "morgan_from_worlds_end");
		local huTao = "HuTao" in ::$bvvar{namespace} && ::$bvvar{namespace}.HuTao.hasSurvival(this);
		local cc = "hasCCSurvival" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasCCSurvival(this);
		local celestial = "BlackBeast" in ::$bvvar{namespace} && ::$bvvar{namespace}.BlackBeast.hasSurvival(this);
		local ryzaTrait = this.getSkills().getSkillByID("$bvvar{modId}.trait.ryza_augmentation");
		local ryzaLife = ryzaTrait != null && ryzaTrait.m.InCombat && !ryzaTrait.m.LifeSpent && ryzaTrait.has("life");
		if ((!huTao && !ryzaLife && !cc && !celestial && (passive == null || !passive.m.InCombat || passive.m.GutsSpent)) || ::$bvvar{namespace}.isActorDeadOrDying(this))
			return __original(_attacker, _skill, _hitInfo);
		// One frame: C.C. oath/life, Celestine seal, Morgan, then vanilla.
		// Vanilla's HP clamp occurs before Nine Lives/Lorekeeper and keeps them unspent.
		local previous = passive == null ? null : passive.m.DamageFrame;
		local previousShared = "BVSurvivalFrame" in this.m ? this.m.BVSurvivalFrame : null;
		local frame = { CouldDie = this.isAbleToDie(), Triggered = false, Kind = null, RestoreHP = 0, OwnerRef = null, BeforeHP = this.getHitpoints() };
		this.m.BVSurvivalFrame <- frame;
		if (passive != null) passive.m.DamageFrame = frame;
		local ret = null;
		try { ret = __original(_attacker, _skill, _hitInfo); }
		catch (e)
		{
			if (frame.Triggered) this.setIsAbleToDie(frame.CouldDie);
			if (passive != null) passive.m.DamageFrame = previous;
			this.m.BVSurvivalFrame = previousShared;
			throw e;
		}
		if (passive != null) passive.m.DamageFrame = previous;
		this.m.BVSurvivalFrame = previousShared;
		if (frame.Triggered)
		{
			this.setIsAbleToDie(frame.CouldDie);
			if (this.isAlive() && !this.isDying())
			{
				this.setHitpoints(::Math.min(frame.Kind == null ? 30 : frame.RestoreHP, this.getHitpointsMax()));
				this.setDirty(true);
				if (frame.Kind == null)
				{
					::$bvvar{namespace}.playValkyrieVisual(passive, this, "morgan_rebirth");
					if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(this, "morgan_from_worlds_end_guts");
				}
				else if (frame.Kind == "hu_tao_lingering_fragrance")
				{
					::$bvvar{namespace}.HuTao.update(this);
				}
				else if (frame.Kind == "ryza_second_heart")
				{
					foreach (id in ["effects.bleeding", "effects.goblin_poison", "effects.spider_poison", "effects.poison"]) this.getSkills().removeByID(id);
					::$bvvar{namespace}.playValkyrieVisual(ryzaTrait, this, "ryza_elixir");
				}
				else if (frame.Kind == "celestine_resurrection")
				{
					this.setFatigue(::Math.floor(this.getFatigueMax() * 0.5)); this.setActionPoints(0); this.m.IsTurnDone = true;
					foreach (id in ["effects.bleeding", "effects.goblin_poison", "effects.spider_poison", "effects.poison"]) this.getSkills().removeByID(id);
					local owner=::$bvvar{namespace}.readValkyrieCombatWeakRef(frame.OwnerRef);
					::$bvvar{namespace}.playValkyrieVisual(owner,this,"black_beast_celestine_impact");
					::$bvvar{namespace}.playValkyrieSkillAudio(owner,"celestine_resurrection",::$bvvar{namespace}.captureValkyrieSkillAudioPosition(this));
				}
				else
				{
					local owner=::$bvvar{namespace}.readValkyrieCombatWeakRef(frame.OwnerRef);
					local source=owner == null ? null : ::$bvvar{namespace}.getRuntimeSkillByKey(owner,"c_c_immortal_witch");
					::$bvvar{namespace}.playValkyrieVisual(source,this,frame.Kind=="c_c_pact_rescue"?"c_c_oath_ward":"c_c_rebirth");
					::$bvvar{namespace}.playValkyrieSkillAudio(owner,frame.Kind,::$bvvar{namespace}.captureValkyrieSkillAudioPosition(this));
				}
			}
		}
		return ret;
	}
});
