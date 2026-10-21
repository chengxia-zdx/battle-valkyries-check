this.grail_oath_thrust_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create() {
		this.valkyrie_active_skill.create(); this.m.IsTargeted = true; this.m.IsTargetingActor = true;
		this.m.IsAttack = true; this.m.IsWeaponSkill = true; this.m.IsRanged = false;
		this.m.ActionPointCost = 3; this.m.FatigueCost = 12; this.m.MinRange = 1; this.m.MaxRange = 2;
		this.m.DirectDamageMult = 0.5; this.m.IsUsingHitchance = true;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody; this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
	},
	function bindWeapon() {
		local actor = ::$bvvar{namespace}.getGrailEquipmentActor(this.getContainer() == null ? null : this.getContainer().getActor());
		local items = actor == null ? null : actor.getItems();
		local item = items == null ? null : items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
		if (item == null || item.getID() != "$bvvar{modId}.item.grail_gungnir" || item.getCondition() <= 0) item = null;
		this.setItem(item); return item;
	},
	function onAdded() { this.skill.onAdded(); this.bindWeapon(); },
	function isUsable() { return this.skill.isUsable() && this.bindWeapon() != null; },
	function onVerifyTarget(origin, target) {
		return target != null && target.IsOccupiedByActor && this.skill.onVerifyTarget(origin, target)
			&& !this.getContainer().getActor().isAlliedWith(target.getEntity()) && !::$bvvar{namespace}.isActorDeadOrDying(target.getEntity());
	},
	function onAnySkillUsed(skill, target, p) { if (skill == this && this.bindWeapon() != null) p.MeleeSkill += 20; },
	function onUse(user, tile) {
		local bv = ::$bvvar{namespace}, weapon = this.bindWeapon();
		if (bv.isActorDeadOrDying(user) || weapon == null || tile == null || !this.onVerifyTarget(user.getTile(), tile)
			|| user.getTile().getDistanceTo(tile) < 1 || user.getTile().getDistanceTo(tile) > 2 || !tile.getEntity().isAttackable()) return false;
		local state = bv.grailActorState(user), itemState = bv.grailItemState(weapon), round = ::Time.getRound();
		local normal = bv.isMorganNormalTurn(user) && bv.sameValkyrieCombatObject(this.Tactical.TurnSequenceBar.getActiveEntity(), user);
		local source = bv.getCurrentValkyrieCombatSource(user, this);
		if (source != null && "Source" in source && ["followup", "reaction", "aoo", "riposte", "counterattack"].find(source.Source) != null) normal = false;
		local guaranteed = normal && state.Round != round && itemState.BVGrailRound != round;
		if (normal) { state.Round = round; itemState.BVGrailRound = round; }
		this.m.IsUsingHitchance = !guaranteed;
		local result = false;
		try { result = this.attackEntity(user, tile.getEntity()); }
		catch (e) { this.m.IsUsingHitchance = true; throw e; }
		this.m.IsUsingHitchance = true; return result;
	},
	function getTooltip() { return this.getDefaultTooltip(); }
});
