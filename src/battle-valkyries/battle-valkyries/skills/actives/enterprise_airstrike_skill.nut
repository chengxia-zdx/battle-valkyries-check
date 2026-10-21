this.enterprise_airstrike_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {Spec=null, Cast=null},
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true;
		this.m.IsRanged = true; this.m.IsWeaponSkill = false; this.m.IsUsingHitchance = true;
		this.m.IsShieldRelevant = false; this.m.IsShowingProjectile = false; this.m.ProjectileType = 0;
		this.m.IsDoingAttackMove = false; this.m.IsIgnoredAsAOO = true; this.m.IsVisibleTileNeeded = true;
		this.m.MaxRangeBonus = 0; this.m.MaxLevelDifference = 99; this.m.MinRange = 2; this.m.MaxRange = 7;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody; this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
	}
	function onValkyrieSkillBound(_definition)
	{
		this.m.Spec = _definition.Spec;
		this.m.ActionPointCost = this.m.Spec.AP; this.m.FatigueCost = this.m.Spec.Fatigue;
		this.m.DirectDamageMult = this.m.Spec.Pierce;
		this.m.IsAOE = this.m.Spec.Mode != "dauntless_dive";
		this.m.IsTargetingActor = this.m.Spec.Mode != "carrier_strafe";
	}
	function owner() { return this.getContainer().getActor(); }
	function hasResources()
	{
		local s = ::$bvvar{namespace}.getEnterpriseState(this.owner());
		return s != null && s.Active && !s.Busy && s.Sorties >= this.m.Spec.Sorties && s.AirstrikeRound != ::Time.getRound()
			&& (this.m.Spec.Mode != "decisive_airwing" || !s.DecisiveUsed);
	}
	function isUsable() { return this.skill.isUsable() && ::$bvvar{namespace}.canEnterpriseCommand(this.owner()) && this.hasResources(); }
	function tiles(_origin, _center) { return ::$bvvar{namespace}.getEnterpriseAirstrikeTiles(_origin, _center, this.m.Spec.Mode); }
	function targets(_origin, _center)
	{
		local ret = [];
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(this.owner(), this.tiles(_origin, _center)))
			if (::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(), target, 7, true) && !target.isHiddenToPlayer()) ret.push(target);
		return ret;
	}
	function onVerifyTarget(_origin, _tile)
	{
		if (_origin == null || _tile == null || !this.skill.onVerifyTarget(_origin, _tile)
			|| _origin.getDistanceTo(_tile) < 2 || _origin.getDistanceTo(_tile) > 7 || !_tile.IsVisibleForEntity) return false;
		if (this.m.Spec.Mode != "carrier_strafe" && (!_tile.IsOccupiedByActor
			|| !::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(), _tile.getEntity(), 7, true)
			|| _tile.getEntity().isHiddenToPlayer())) return false;
		return this.targets(_origin, _tile).len() > 0;
	}
	function onTargetSelected(_tile)
	{
		foreach (tile in this.tiles(this.owner().getTile(), _tile))
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
	}
	function finalizeAirstrikeProperties(_target, _properties)
	{
		local cast = this.m.Cast, spec = this.m.Spec, actor = this.owner();
		local state = ::$bvvar{namespace}.getEnterpriseState(actor);
		local marked = cast == null ? (state == null ? null : ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef)) : cast.Marked;
		local signature = ::$bvvar{namespace}.hasEnterpriseSignatureBow(actor);
		local multiplier = (cast != null && cast.Lucky ? 2.0 : 1.0) * (_target != null && _target == marked ? (signature ? 1.35 : 1.2) : 1.0);
		local outer = cast != null && spec.Mode == "decisive_airwing" && _target != null && _target.getTile().ID != cast.CenterID;
		_properties.DamageRegularMin = ((outer ? spec.OuterMin : spec.DamageMin) * multiplier).tointeger();
		_properties.DamageRegularMax = ((outer ? spec.OuterMax : spec.DamageMax) * multiplier).tointeger();
		_properties.DamageRegularMult = 1.0; _properties.DamageArmorMult = spec.Armor;
		_properties.DamageDirectMult = 1.0; _properties.DamageDirectAdd = 0.0;
		_properties.DamageDirectMeleeAdd = 0.0; _properties.DamageDirectRangedAdd = 0.0;
		_properties.DamageAdditionalWithEachTile = 0.0; _properties.HitChanceAdditionalWithEachTile = 0.0;
		// The base attack applies elevation after skill * multiplier. Cancel exactly there,
		// without changing shared constants, tile levels or the target's ranged defenses.
		local elevation = 0.0;
		if (_target != null && actor.isPlacedOnMap() && _target.isPlacedOnMap())
		{
			local difference = _target.getTile().Level - actor.getTile().Level;
			elevation = difference < 0 ? ::Const.Combat.LevelDifferenceToHitBonus : ::Const.Combat.LevelDifferenceToHitMalus * difference;
		}
		local ranged = _properties.RangedSkill * _properties.RangedSkillMult;
		_properties.RangedSkill = ranged + spec.Hit + (_target != null && _target == marked ? (signature ? 15 : 10) : 0) - elevation;
		_properties.RangedSkillMult = 1.0;
	}
	function onUse(_user, _tile)
	{
		// Native skill.use already paid AP/fatigue before entering onUse.
		if (_user == null || !::$bvvar{namespace}.canEnterpriseCommand(_user) || !this.hasResources()
			|| !this.onVerifyTarget(_user.getTile(), _tile)) return false;
		local targets = this.targets(_user.getTile(), _tile), state = ::$bvvar{namespace}.getEnterpriseState(_user);
		if (targets.len() == 0) return false;
		local marked = ::$bvvar{namespace}.readValkyrieCombatWeakRef(state.MarkRef);
		local includesMark = false;
		foreach (target in targets) if (target == marked) includesMark = true;
		state.Sorties -= this.m.Spec.Sorties; state.AirstrikeRound = ::Time.getRound(); state.Busy = true;
		if (this.m.Spec.Mode == "decisive_airwing") state.DecisiveUsed = true;
		this.m.Cast = {CenterID=_tile.ID, Marked=includesMark ? marked : null, Lucky=false};
		if (includesMark) ::$bvvar{namespace}.clearEnterpriseMark(_user);
		local resolved = false;
		try
		{
			local lucky = ::$bvvar{namespace}.getRuntimeSkillByKey(_user, "enterprise_lucky_e");
			this.m.Cast.Lucky = lucky != null && lucky.rollForSortie();
			::$bvvar{namespace}.playValkyrieSkillAudio(_user, "enterprise_" + this.m.Spec.Mode + "_cast");
			local impactPlayed = false;
			foreach (target in targets)
			{
				if (::$bvvar{namespace}.isActorDeadOrDying(_user) || !_user.isPlacedOnMap()) break;
				if (!::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user, target, 7, true) || target.isHiddenToPlayer()) continue;
				local position = ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(target);
				::$bvvar{namespace}.playValkyrieVisual(this, target, this.m.Spec.Mode == "carrier_strafe" ? "enterprise_fighter" : "enterprise_dive_bomber");
				if (this.m.Spec.Mode == "decisive_airwing") ::$bvvar{namespace}.playValkyrieVisual(this, target, "enterprise_fighter");
				::$bvvar{namespace}.playValkyrieVisual(this, target, this.m.Spec.Mode == "carrier_strafe" ? "enterprise_strafe_impact" : "enterprise_bomb_impact");
				local hit = this.attackEntity(_user, target, false);
				resolved = true;
				if (hit && target == this.m.Cast.Marked) ::$bvvar{namespace}.recoverEnterpriseSortieFatigue(_user);
				if (hit && !impactPlayed && position != null)
				{
					::$bvvar{namespace}.playValkyrieSkillAudio(_user, "enterprise_" + this.m.Spec.Mode + "_impact", position);
					impactPlayed = true;
				}
			}
		}
		catch (e) { this.m.Cast = null; state.Busy = false; throw e; }
		this.m.Cast = null; state.Busy = false;
		if (resolved && ::$bvvar{namespace}.consumeGreyFalconMemory(_user, "grey_falcon_return_route"))
			state.Sorties = ::Math.min(3, state.Sorties + 1);
		return true;
	}
	function getTooltip()
	{
		local ret = [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()}, {id=4,type="text",icon="ui/icons/special.png",text="$bv{enterprise.airstrike.rules}"},
			{id=5,type="text",icon="skills/$bvvar{iconPrefix}/enterprise_sortie_points.png",text=::$bvvar{namespace}.getEnterpriseStateText(this.owner())}];
		if (!::$bvvar{namespace}.canEnterpriseCommand(this.owner())) ret.push({id=6,type="text",icon="ui/tooltips/warning.png",text="$bv{enterprise.command.blocked}"});
		if (!this.hasResources()) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{enterprise.airstrike.blocked}"});
		if (::$bvvar{namespace}.hasEnterpriseSignatureBow(this.owner())) ret.push({id=8,type="text",icon="ui/icons/special.png",text="$bv{enterprise.signature.active}"});
		return ret;
	}
});
