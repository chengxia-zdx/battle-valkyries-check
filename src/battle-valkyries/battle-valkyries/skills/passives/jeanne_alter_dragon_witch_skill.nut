this.jeanne_alter_dragon_witch_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function owner() { local c = this.getContainer(); return c == null ? null : c.getActor(); }
	function getCurse( _target )
	{
		if (_target == null) return null;
		try { return _target.getSkills().getSkillByID("$bvvar{modId}.effects.jeanne_alter_black_flame_curse"); }
		catch (e) { return null; }
	}
	function hasMeleeWeapon()
	{
		local actor = this.owner(); local weapon = null;
		try { weapon = actor.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand); } catch (e) { weapon = null; }
		return weapon != null && weapon.isItemType(this.Const.Items.ItemType.MeleeWeapon);
	}
	function isJeanneAlterRuinAttack( _skill )
	{
		local owner = this.owner();
		try
		{
			local frame = ::$bvvar{namespace}.getCurrentValkyrieCombatSource(owner, _skill);
			return frame != null && "Source" in frame && frame.Source == "jeanne_alter_ruin";
		}
		catch (e) { return false; }
	}
	function isHuntWeaponAttack( _skill, _target = null )
	{
		if (_skill == null || _target == null || this.isJeanneAlterRuinAttack(_skill) || !::$bvvar{namespace}.isActiveWeaponAttack(_skill)) return false;
		try { return !_skill.isRanged() && this.getCurse(_target) != null; } catch (e) { return false; }
	}
	function isOwner( _actor )
	{
		local owner = this.owner();
		return owner != null && _actor != null
			&& ::$bvvar{namespace}.getValkyrieCombatObjectID(owner) == ::$bvvar{namespace}.getValkyrieCombatObjectID(_actor);
	}
	function applyBlackFlame( _target )
	{
		local owner = this.owner();
		if (owner == null || _target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return null;
		local existing = this.getCurse(_target);
		if (existing != null) { existing.setJeanneAlterOwner(owner); existing.onRefresh(); return existing; }
		local effect = ::new("$bvvar{privateFolder}/skills/effects/jeanne_alter_black_flame_curse_effect");
		if (effect == null) return null;
		effect.setJeanneAlterOwner(owner);
		_target.getSkills().add(effect);
		return effect;
	}
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (!this.isHuntWeaponAttack(_skill, _targetEntity)) return;
		_properties.DamageRegularMult *= ("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 1.35 : 1.20;
		_properties.DamageDirectMeleeAdd += 0.10;
	}
	function onValkyrieCombatEvent( _event )
	{
		if (_event == null || !("Type" in _event) || _event.Type != "TargetResolved") return;
		local owner = this.owner();
		if (owner == null || !("Attacker" in _event) || !this.isOwner(_event.Attacker) || !("Target" in _event) || _event.Target == null) return;
		if (!("Skill" in _event) || !("Hit" in _event) || !_event.Hit) return;
		local source = "Source" in _event ? _event.Source : null;
		if (source == "followup" || source == "fixed_damage" || source == "dot" || source == "damage_over_time") return;
		local skill = _event.Skill;
		if (!::$bvvar{namespace}.isActiveWeaponAttack(skill)) return;
		try { if (skill.isRanged()) return; } catch (e) { return; }
		local curse = this.applyBlackFlame(_event.Target);
		if (curse == null || ::$bvvar{namespace}.isActorDeadOrDying(_event.Target)) return;
		local isPlaced = false;
		try { isPlaced = _event.Target.isPlacedOnMap(); } catch (e) { return; }
		if (isPlaced && "playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _event.Target, "jeanne_black_flame");
	}
	function getTooltip()
	{
		return [{ id = 1, type = "title", text = this.getName() }, { id = 2, type = "description", text = this.getDescription() }, { id = 3, type = "text", icon = "ui/icons/hitchance.png", text = "$bv{skill.jeanne_alter_dragon_witch.tooltip.hunt}" }, { id = 4, type = "text", icon = "ui/icons/direct_damage.png", text = "$bv{skill.jeanne_alter_dragon_witch.tooltip.damage}" }];
	}
});
