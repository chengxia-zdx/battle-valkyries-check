// Legends replaces human/player deserialization instead of always wrapping the
// previously installed implementation. Install this idempotent repair after it.
::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		local ret = __original(_in);
		::$bvvar{namespace}.applyValkyrieIdentityMetadata(this);
		return ret;
	}
});
