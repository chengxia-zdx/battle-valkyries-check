// This is deliberately an ID allow-list. It does not classify effects by their
// display name, skill type, source, or icon, and therefore cannot swallow an
// unrelated mod's stateful effect.
::$bvvar{namespace}.MH.hook("scripts/skills/skill_container", function( q )
{
	q.add = @(__original) function( _skill, _order = 0 )
	{
		local actor = null;
		try { actor = this.getActor(); } catch (e) { actor = null; }
		if (actor != null && ::$bvvar{namespace}.shouldBlockJeanneAlterPositiveEffect(actor, _skill)) return;
		return __original(_skill, _order);
	}
});
