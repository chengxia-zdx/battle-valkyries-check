// Character-only synchronous runner: one paid use / SkillCounter for every burst or blast.
// No borrowed weapon active, secondary use(), projectile callback or fixed HP damage.
this.m4a1_fire_control_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Spec = null, Cast = null, Splash = false },
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsWeaponSkill = true; this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = false; this.m.IsDoingAttackMove = false;
		this.m.IsVisibleTileNeeded = true; this.m.MaxRangeBonus = 0;
		this.m.MaxLevelDifference = 99;
	}
	function onValkyrieSkillBound(_definition)
	{
		this.m.Spec = _definition.Spec;
		local s = this.m.Spec;
		this.m.ActionPointCost = s.AP; this.m.FatigueCost = s.Fatigue;
		this.m.IsAttack = s.Mode == "shot" || s.Mode == "burst" || s.Mode == "cannon";
		this.m.IsRanged = this.m.IsAttack; this.m.IsTargeted = this.m.IsAttack;
		this.m.IsTargetingActor = this.m.IsAttack; this.m.IsUsingHitchance = this.m.IsAttack;
		this.m.IsShieldRelevant = s.Mode != "cannon";
		this.m.IsAOE = s.Mode == "cannon";
		this.m.MinRange = !this.m.IsAttack ? 0 : (s.Mode == "cannon" ? 2 : 1);
		this.m.MaxRange = this.m.IsAttack ? 7 : 0;
		this.m.DirectDamageMult = s.Mode == "cannon" ? 0.65 : 0.45;
	}
	function owner() { return this.getContainer().getActor(); }
	function state() { return ::$bvvar{namespace}.getM4A1State(this.owner()); }
	function getActionPointCost()
	{
		local cost = this.skill.getActionPointCost();
		return this.m.Spec != null && this.m.Spec.Mode == "reload"
			&& ::$bvvar{namespace}.greyFalconMemoryAvailable(this.owner(), "grey_falcon_cover_reload") ? ::Math.max(0, cost - 1) : cost;
	}
	function playRifleFeedback(_user, _rounds)
	{
		if (_rounds <= 0) return;
		if ("playValkyrieSkillAudioSequence" in ::$bvvar{namespace})
			::$bvvar{namespace}.playValkyrieSkillAudioSequence(_user,
				this.m.Spec.Mode == "burst" ? "m4a1_three_round_burst_cast" : "m4a1_tactical_shot_cast", _rounds);
		// Cosmetics only. Do not enable engine projectile callbacks: burst/cannon
		// damage and the per-cast snapshot must still settle synchronously.
		try
		{
			if (!_user.isPlacedOnMap() || !_user.getTile().IsVisibleForPlayer) return;
			::$bvvar{namespace}.playValkyrieVisual(this, _user, "m4a1_muzzle", { Layers = _rounds });
		}
		catch (e) { try { ::logWarning("[Battle Valkyries] [M4A1] Rifle feedback failed: " + e); } catch (ignored) {} }
	}
	function logRifleResult(_user, _fired, _hits)
	{
		if (_fired <= 0) return;
		local result = this.getName() + "$bv{m4a1.fire_log.fired}" + _fired
			+ "$bv{m4a1.fire_log.hits}" + _hits + "$bv{m4a1.fire_log.misses}" + (_fired - _hits) + "$bv{m4a1.fire_log.end}";
		try { this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " — " + result); } catch (ignored) {}
		try { ::logInfo("[Battle Valkyries] [M4A1] " + result); } catch (ignored) {}
	}
	function isUsable()
	{
		return this.skill.isUsable() && this.hasFireControlResources();
	}
	function hasFireControlResources()
	{
		local actor = this.owner(), state = this.state();
		if (state == null || !state.Active || state.Busy || !actor.isPlacedOnMap() || !actor.isPlayerControlled()
			|| ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.getCurrentProperties().IsAbleToUseSkills
			|| actor.getMoraleState() == ::Const.MoraleState.Fleeing || !::$bvvar{namespace}.hasM4A1Rifle(actor)) return false;
		local mode = this.m.Spec.Mode;
		if (mode == "shot" || mode == "burst") return state.Ammo >= (mode == "burst" ? 3 : 1);
		if (mode == "reload") return ::$bvvar{namespace}.canM4A1Reload(state, this.m.Spec.AmmoType);
		if (mode == "focus") return state.Turn >= state.FocusReady;
		return state.Charge >= 3 && state.CannonRound != ::Time.getRound() && !::$bvvar{namespace}.hasM4A1AdjacentEnemy(actor);
	}
	function onAfterUpdate(_properties)
	{
		// Mastery changes fatigue; the earned chapter growth separately discounts the first reload.
		this.m.FatigueCostMult = this.m.Spec != null && this.m.Spec.Mode != "focus" && _properties.IsSpecializedInCrossbows ? 0.75 : 1.0;
	}
	function onVerifyTarget(_origin, _tile)
	{
		if (!this.m.IsAttack) return true;
		if (_tile == null || !_tile.IsOccupiedByActor || !this.skill.onVerifyTarget(_origin, _tile)) return false;
		if (_origin.getDistanceTo(_tile) < this.m.MinRange || !_origin.hasLineOfSightTo(_tile, 7)) return false;
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(), _tile.getEntity(), 7, true);
	}
	function makeSnapshot(_target)
	{
		local s = this.state(), cannon = this.m.Spec.Mode == "cannon";
		if (s == null) return { AP = false, Focus = false, Marked = false };
		return { AP = s.AmmoType == "ap", Focus = s.Turn <= s.FocusUntil,
			Marked = cannon && ::$bvvar{namespace}.readValkyrieCombatWeakRef(s.MarkRef) == _target };
	}
	function onAnySkillUsed(_skill, _target, _properties)
	{
		if (_skill != this || !this.m.IsAttack) return;
		local actor = this.owner(), state = this.state();
		local cast = this.m.Cast == null ? this.makeSnapshot(_target) : this.m.Cast;
		local cannon = this.m.Spec.Mode == "cannon", splash = cannon && this.m.Splash;
		local mult = cannon ? (splash ? 1.6 : 4.0) : (this.m.Spec.Mode == "burst" ? 0.7 : 1.0);
		if (cannon && !splash && cast.Marked) mult *= 1.25;
		if (!cannon) { if (cast.AP) mult *= 0.8; if (cast.Focus) mult *= 1.5; }
		_properties.DamageRegularMin = 65; _properties.DamageRegularMax = 85;
		_properties.DamageTotalMult *= mult;
		_properties.DamageArmorMult = cannon ? (splash ? 2.0 : 2.5) : (cast.AP ? 2.2 : 1.6);
		this.m.DirectDamageMult = cannon ? (splash ? 0.35 : 0.65) : (cast.AP ? 0.70 : 0.45);
		_properties.DamageDirectMult = 1.0; _properties.DamageDirectAdd = 0.0;
		_properties.DamageDirectRangedAdd = 0.0;
		_properties.DamageAdditionalWithEachTile = 0; _properties.HitChanceAdditionalWithEachTile = 0;
		local hit = cannon ? 25 : (this.m.Spec.Mode == "burst" ? 5 : 20);
		if (!cannon)
		{
			if (cast.Focus) hit += 10;
			if (::$bvvar{namespace}.hasM4A1AdjacentEnemy(actor)) hit -= 15;
			if (_target != null) hit -= this.Math.max(0, actor.getTile().getDistanceTo(_target.getTile()) - 3) * 4;
		}
		_properties.RangedSkill += hit;
	}
	function onUse(_user, _targetTile)
	{
		// Affordability was checked and paid by native skill.use; recheck only execution conditions.
		if (_user == null || !this.hasFireControlResources() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		local state = this.state(), mode = this.m.Spec.Mode;
		if (mode == "reload")
		{
			local success = ::$bvvar{namespace}.reloadM4A1(state, this.m.Spec.AmmoType);
			if (success) ::$bvvar{namespace}.consumeGreyFalconMemory(_user, "grey_falcon_cover_reload");
			if (success && "playValkyrieSkillAudio" in ::$bvvar{namespace})
				::$bvvar{namespace}.playValkyrieSkillAudio(_user, this.m.Spec.AmmoType == "ap" ? "m4a1_reload_ap_cast" : "m4a1_tactical_reload_cast");
			return success;
		}
		if (mode == "focus")
		{
			state.FocusUntil = state.Turn + 1; state.FocusReady = state.Turn + 4;
			::$bvvar{namespace}.addM4A1Charge(_user, 1);
			if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "m4a1_firepower_focus_cast");
			return true;
		}
		local target = _targetTile.getEntity();
		this.m.Cast = this.makeSnapshot(target); this.m.Splash = false; state.Busy = true;
		try
		{
			if (mode == "cannon")
			{
				state.Charge -= 3; state.CannonRound = ::Time.getRound();
				local audio = "playValkyrieSkillAudio" in ::$bvvar{namespace};
				if (audio) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "m4a1_mark_of_vengeance_cast");
				// Snapshot targets before the central hit can kill/move its victim.
				local targets = ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true));
				local position = audio ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target) : null;
				local hit = this.attackEntity(_user, target, false);
				local impactPlayed = hit && position != null && ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "m4a1_mark_of_vengeance_impact", position);
				this.m.Splash = true;
				foreach (victim in targets)
				{
					if (::$bvvar{namespace}.isActorDeadOrDying(_user)) break;
					if (victim == target || ::$bvvar{namespace}.isActorDeadOrDying(victim) || !victim.isPlacedOnMap() || victim.isAlliedWith(_user)) continue;
					if (_targetTile.hasLineOfSightTo(victim.getTile(), 1))
					{
						position = audio && !impactPlayed ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(victim) : null;
						hit = this.attackEntity(_user, victim, false);
						if (hit && position != null && !impactPlayed)
							impactPlayed = ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "m4a1_mark_of_vengeance_impact", position);
					}
				}
			}
			else
			{
				local shots = mode == "burst" ? 3 : 1;
				local fired = 0, hits = 0;
				for (local i = 0; i < shots; i++)
				{
					if (::$bvvar{namespace}.isActorDeadOrDying(_user) || ::$bvvar{namespace}.isActorDeadOrDying(target)
						|| !::$bvvar{namespace}.hasM4A1Rifle(_user) || !this.onVerifyTarget(_user.getTile(), target.getTile())) break;
					state.Ammo--;
					fired++;
					// True retains BB's intervening actor/obstacle diversion and cover rules.
					if (this.attackEntity(_user, target, true)) hits++;
				}
				this.playRifleFeedback(_user, fired);
				this.logRifleResult(_user, fired, hits);
			}
		}
		catch (e) { state.Busy = false; this.m.Cast = null; this.m.Splash = false; throw e; }
		state.Busy = false; this.m.Cast = null; this.m.Splash = false;
		return true;
	}
	function getTooltip()
	{
		local state = this.state();
		local ret = [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()},
			{id=4,type="text",icon="skills/$bvvar{iconPrefix}/m4a1_magazine.png",text=::$bvvar{namespace}.getM4A1AmmoText(state)}];
		if (state != null && state.Active && this.m.Spec.Mode == "focus")
			ret.push({id=5,type="text",icon="ui/icons/special.png",text="$bv{m4a1.state.cooldown}"+this.Math.max(0,state.FocusReady-state.Turn)});
		if (!::$bvvar{namespace}.hasM4A1Rifle(this.owner())) ret.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{m4a1.requires_rifle}"});
		return ret;
	}
});
