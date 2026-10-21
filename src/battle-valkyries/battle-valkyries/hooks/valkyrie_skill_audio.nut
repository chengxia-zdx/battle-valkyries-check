::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieSkillAudio(true);
		return __original();
	}
	q.onFinish = @(__original) function()
	{
		::$bvvar{namespace}.resetValkyrieSkillAudio(false);
		return __original();
	}
});

::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.resetValkyrieSkillAudio(false);
		return __original(_in);
	}
});
