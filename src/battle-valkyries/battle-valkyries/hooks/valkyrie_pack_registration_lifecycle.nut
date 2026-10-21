::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.closeValkyriePackRegistration("world_state.onInit");
		return __original();
	}

	q.onDeserialize = @(__original) function( _in )
	{
		::$bvvar{namespace}.closeValkyriePackRegistration("world_state.onDeserialize");
		return __original(_in);
	}
});
