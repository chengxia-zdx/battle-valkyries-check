// Control transitions invalidate both ends immediately, including restoration in the same round.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/actor", function(q) {
	q.onFactionChanged = @(__original) function()
	{
		local result = __original();
		local skills = this.getSkills();
		if (skills == null) return result;
		skills.removeByID("$bvvar{modId}.effects.blackgold_weiss_bid");
		local controller = skills.getSkillByID("$bvvar{modId}.effects.blackgold_weiss_controller");
		if (controller != null) controller.clearBid();
		return result;
	}
});
