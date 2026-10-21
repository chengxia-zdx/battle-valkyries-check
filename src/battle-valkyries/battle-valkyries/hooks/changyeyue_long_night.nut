::$bvvar{namespace}.notifyChangyeyueAllyDamaged <- function( _victim, _hitpointDamage )
{
	if (_victim == null || _hitpointDamage <= 0 || !_victim.isPlacedOnMap())
	{
		return;
	}

	local root = getroottable();
	if (!("Tactical" in root) || ::Tactical.Entities == null)
	{
		return;
	}

	local victimTile = _victim.getTile();
	local actors = ::Tactical.Entities.getAllInstancesAsArray();

	foreach( actor in actors )
	{
		if (actor == null || actor.getID() == _victim.getID() || !actor.isPlacedOnMap())
		{
			continue;
		}

		if (!actor.isAlliedWith(_victim) || ::$bvvar{namespace}.isActorDeadOrDying(actor))
		{
			continue;
		}

		if (actor.getTile().getDistanceTo(victimTile) > 4)
		{
			continue;
		}

		local skill = ::$bvvar{namespace}.getRuntimeSkillByKey(actor, "changyeyue_long_night");
		if (skill != null)
		{
			skill.onAllyDamaged(_victim, _hitpointDamage);
		}
	}
};

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onDamageReceived = @(__original) function( _attacker, _skill, _hitInfo )
	{
		local hpBefore = this.getHitpoints();
		local ret = __original(_attacker, _skill, _hitInfo);
		local hpAfter = this.getHitpoints();
		local hpDamage = hpBefore - hpAfter;

		if (hpDamage > 0)
		{
			::$bvvar{namespace}.notifyChangyeyueAllyDamaged(this, hpDamage);
		}

		return ret;
	}
});
