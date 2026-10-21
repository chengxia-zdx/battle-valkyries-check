this.royal_tide_fortified_oath_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Anchor = null, LastRound = -1 },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID = "$bvvar{modId}.effects.royal_tide_fortified_oath";
		this.m.Name = "$bv{effect.royal_tide.fortified.name}"; this.m.Description = "$bv{effect.royal_tide.fortified.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/fortified_oath.png"; this.m.IconDisabled = "skills/$bvvar{iconPrefix}/fortified_oath_sw.png";
	}
	function clearAnchor() { this.m.Anchor = null; }
	function getAnchor()
	{
		local bv = ::$bvvar{namespace}, owner = this.getContainer().getActor();
		local anchor = this.m.Anchor == null || this.m.Anchor.isNull() ? null : this.m.Anchor.get();
		return bv.isActorDeadOrDying(owner) || bv.isActorDeadOrDying(anchor) || !owner.isPlacedOnMap() || !anchor.isPlacedOnMap()
			|| owner.isAlliedWithPlayer() || anchor.getFaction() != owner.getFaction() || owner.getTile().getDistanceTo(anchor.getTile()) > 2 ? null : anchor;
	}
	function onTurnStart()
	{
		local bv = ::$bvvar{namespace}, owner = this.getContainer().getActor();
		if (bv.isActorDeadOrDying(owner) || !owner.isPlacedOnMap() || owner.isAlliedWithPlayer()) { this.clearAnchor(); return; }
		local skills = owner.getSkills(), command = skills.getSkillByID("$bvvar{modId}.effects.cerydra_command_turn"), granted = skills.getSkillByID("$bvvar{modId}.effects.robin_granted_action");
		if ((command != null && command.m.IsCommandPhase) || (granted != null && granted.m.BVIsExtraTurn)
			|| ("BVCCExtraTurnFrame" in owner.m && owner.m.BVCCExtraTurnFrame) || this.m.LastRound == ::Time.getRound()) return;
		this.m.LastRound = ::Time.getRound(); this.clearAnchor();
		local chosen = null;
		foreach (group in ::Tactical.Entities.getAllInstances()) foreach (target in group)
		{
			if (target == owner || bv.isActorDeadOrDying(target) || !target.isPlacedOnMap() || target.getFaction() != owner.getFaction()
				|| !target.getFlags().has("BVRoyalTideOathGuard") || owner.getTile().getDistanceTo(target.getTile()) > 2) continue;
			if (chosen == null || target.getID() < chosen.getID()) chosen = target;
		}
		if (chosen != null) this.m.Anchor = ::WeakTableRef(chosen);
	}
	function onUpdate(properties) { if (this.getAnchor() != null) { properties.MeleeDefense += 20; properties.RangedDefense += 20; } }
	function onDeath(fatality) { this.clearAnchor(); }
	function onCombatFinished() { this.clearAnchor(); }
	function getTooltip()
	{
		local ret = [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }], anchor = this.getAnchor();
		ret.push({ id = 3, type = "text", icon = "ui/icons/melee_defense.png", text = anchor == null ? "$bv{effect.royal_tide.fortified.inactive}" : "$bv{effect.royal_tide.fortified.anchor}" + anchor.getName() }); return ret;
	}
});
