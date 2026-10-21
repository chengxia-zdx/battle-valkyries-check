// Exact-damage normalization must run after every original item callback so
// equipment can observe the hit without being allowed to scale fixed damage.
::$bvvar{namespace}.MH.hook("scripts/items/item_container", function(q) {
	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_skill))
		{
			return __original(_attacker, _skill, _hitInfo, _properties);
		}
		local ret = __original(_attacker, _skill, _hitInfo, _properties);
		local target = null;
		try { target = this.getActor(); } catch (e) { target = null; }
		local frame = ::$bvvar{namespace}.getValkyrieFixedDamageFrameForHit(_hitInfo, target, _attacker, _skill);
		if (frame != null)
		{
			::BattleValkyriesFixedDamageState.normalizeValkyrieFixedDamage(frame.Marker, _hitInfo, _properties);
		}
		return ret;
	}

	q.onDamageDealt = @(__original) function( _target, _skill, _hitInfo )
	{
		if ("isValkyrieOpaqueCombatSkill" in ::$bvvar{namespace}
			&& ::$bvvar{namespace}.isValkyrieOpaqueCombatSkill(_skill))
		{
			return __original(_target, _skill, _hitInfo);
		}
		local actor = null;
		try { actor = this.getActor(); } catch (e) { actor = null; }
		if (::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(actor, _skill, _target) != null)
		{
			return null;
		}
		return __original(_target, _skill, _hitInfo);
	}
});
