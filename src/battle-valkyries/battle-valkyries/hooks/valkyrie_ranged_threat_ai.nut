::$bvvar{namespace}.ValkyrieAIRangedThreats <- {
	castorice = {
		Range = 6,
		IsTrueRangedWeapon = true
	},
	himeko = {
		Range = 7,
		IsTrueRangedWeapon = true
	},
	fengjin = {
		Range = 6,
		IsTrueRangedWeapon = true
	}
};

::$bvvar{namespace}.getValkyrieAIRangedThreatInfo <- function( _actor )
{
	if (_actor == null || ::$bvvar{namespace}.isActorDeadOrDying(_actor))
	{
		return null;
	}

	local valkyrieID = ::$bvvar{namespace}.getActorValkyrieID(_actor);
	if (valkyrieID == null || !(valkyrieID in ::$bvvar{namespace}.ValkyrieAIRangedThreats))
	{
		return null;
	}

	return ::$bvvar{namespace}.ValkyrieAIRangedThreats[valkyrieID];
}

::$bvvar{namespace}.applyValkyrieAIRangedThreatInfo <- function( _actor, _result )
{
	local threat = ::$bvvar{namespace}.getValkyrieAIRangedThreatInfo(_actor);
	if (threat == null)
	{
		return _result;
	}

	local range = threat.Range;
	local properties = _actor.getCurrentProperties();
	if (properties != null)
	{
		range = ::Math.min(range, properties.getVision());
	}

	range = ::Math.max(1, range);
	_result.HasRangedWeapon = true;
	_result.IsTrueRangedWeapon = _result.IsTrueRangedWeapon || threat.IsTrueRangedWeapon;
	_result.Range = ::Math.max(_result.Range, range);
	_result.RangeWithLevel = ::Math.max(_result.RangeWithLevel, range);
	return _result;
}

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.getRangedWeaponInfo = @(__original) function()
	{
		return ::$bvvar{namespace}.applyValkyrieAIRangedThreatInfo(this, __original());
	}

	q.hasRangedWeapon = @(__original) function( _trueRangedOnly = false )
	{
		local threat = ::$bvvar{namespace}.getValkyrieAIRangedThreatInfo(this);
		if (threat != null && (!_trueRangedOnly || threat.IsTrueRangedWeapon))
		{
			return true;
		}

		return __original(_trueRangedOnly);
	}

	q.getIdealRange = @(__original) function()
	{
		local range = __original();
		local threat = ::$bvvar{namespace}.getValkyrieAIRangedThreatInfo(this);
		if (threat == null)
		{
			return range;
		}

		return ::Math.max(range, threat.Range);
	}
});
