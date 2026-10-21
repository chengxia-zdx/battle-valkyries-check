::$bvvar{namespace}.registerNestedTooltipRuntimeSkills <- function()
{
	if (!("MSU" in getroottable()) || !("NestedTooltips" in ::MSU)
		|| !("SkillObjectsByFilename" in ::MSU.NestedTooltips))
	{
		return 0;
	}

	local registry = ::MSU.NestedTooltips.SkillObjectsByFilename;
	local added = 0;
	foreach (path in ::IO.enumerateFiles("$bvvar{privateFolder}/skills"))
	{
		local parts = split(path, "/");
		if (parts.len() == 0) continue;
		local filename = parts.top();
		if (filename in registry)
		{
			continue;
		}

		registry[filename] <- path;
		added++;
	}

	return added;
};

// Nested Tooltips populates its filename cache from scripts/skills only. The
// Valkyrie runtime objects deliberately live in the private mod directory, so
// register them after all hooks have completed as well as immediately when the
// framework happened to load first.
if ("QueueBucket" in ::MSU && "AfterHooks" in ::MSU.QueueBucket)
{
	::MSU.QueueBucket.AfterHooks.push(function()
	{
		::$bvvar{namespace}.registerNestedTooltipRuntimeSkills();
	});
}
::$bvvar{namespace}.registerNestedTooltipRuntimeSkills();
