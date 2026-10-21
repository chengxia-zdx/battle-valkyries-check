local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, context = "unknown")
{
	local result = originalSync.call(this, actor, context);
	if (result != null && result.Success) ::$bvvar{namespace}.syncReturningOathSkills(actor);
	return result;
};
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q)
{
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.resetRoyalTideCombat(this);
		return __original();
	};
});
