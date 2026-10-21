local originalSync = ::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills = function(actor, reason = "unknown")
{
	local result = originalSync(actor, reason);
	if (result != null && result.Success) ::$bvvar{namespace}.syncLiuchunWeaponSkills(actor);
	return result;
};
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onCombatStart = @(__original) function()
	{
		::$bvvar{namespace}.resetSpringGrowth(this);
		return __original();
	}
});
