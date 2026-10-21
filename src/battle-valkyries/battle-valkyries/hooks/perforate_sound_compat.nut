// Some Chinese data archives include the Perforate skill but omit its four
// dedicated hit sounds. Leaving the list empty preserves the attack while
// preventing the resource manager from terminating combat on a missing file.
try
{
	::$bvvar{namespace}.MH.hook("scripts/skills/actives/perforate_skill", function( q )
	{
		q.create = @(__original) function()
		{
			__original();
			this.m.SoundOnHit = [];
		}
	});
}
catch (perforateSoundCompatError)
{
	// Perforate is supplied only by the Chinese compatibility data/Legends.
	// Vanilla installations without that script do not need this repair.
}
