// Some legacy Chinese patches wrap bleeding turn events and access ::Legends
// unconditionally. Do not replace normal bleeding behavior: first run the
// complete existing wrapper chain, then recover only the known missing-Legends
// error with the small vanilla-safe damage path.
::$bvvar{namespace}.isMissingLegendsBleedingError <- function( _error )
{
	try
	{
		return ("" + _error).find("Legends") != null;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.applyMissingLegendsBleedingFallback <- function( _effect )
{
	if (_effect.m.LastRoundApplied == _effect.Time.getRound()) return;

	_effect.m.LastRoundApplied = _effect.Time.getRound();
	local actor = _effect.getContainer().getActor();
	_effect.spawnIcon("status_effect_01", actor.getTile());

	local hitInfo = clone _effect.Const.Tactical.HitInfo;
	hitInfo.DamageRegular = _effect.m.Damage * (actor.getSkills().hasSkill("effects.hyena_potion") ? 0.5 : 1.0);
	hitInfo.DamageDirect = 1.0;
	hitInfo.BodyPart = _effect.Const.BodyPart.Body;
	hitInfo.BodyDamageMult = 1.0;
	hitInfo.FatalityChanceMult = 0.0;
	actor.onDamageReceived(actor, _effect, hitInfo);

	if (--_effect.m.TurnsLeft <= 0)
{
		_effect.removeSelf();
	}
};

::$bvvar{namespace}.MH.hook("scripts/skills/effects/bleeding_effect", function( q )
{
	q.onTurnEnd = @(__original) function()
	{
		try
		{
			return __original();
		}
		catch (e)
		{
			if (!::$bvvar{namespace}.isMissingLegendsBleedingError(e)) throw e;
			::$bvvar{namespace}.applyMissingLegendsBleedingFallback(this);
		}
	}

	q.onWaitTurn = @(__original) function()
	{
		try
		{
			return __original();
		}
		catch (e)
		{
			if (!::$bvvar{namespace}.isMissingLegendsBleedingError(e)) throw e;
			::$bvvar{namespace}.applyMissingLegendsBleedingFallback(this);
		}
	}
});
