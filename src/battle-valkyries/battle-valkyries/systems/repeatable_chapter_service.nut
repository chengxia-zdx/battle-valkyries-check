// Explicit loop dispatch leaves every finite chapter on its existing service.
::$bvvar{namespace}.ChapterLoops <- {};
local chapters = ::$bvvar{namespace}.Chapters;
chapters.loopService <- function(id)
{
	local d = this.definition(id);
	return d != null && "Repeatable" in d && d.Repeatable && id in ::$bvvar{namespace}.ChapterLoops ? ::$bvvar{namespace}.ChapterLoops[id] : null;
};
local wrap = function(name)
{
	local original = chapters[name];
	chapters[name] = function(id, ...)
	{
		local loop = this.loopService(id), args = [loop == null ? this : loop, id];
		args.extend(vargv);
		return loop == null ? original.acall(args) : loop[name].acall(args);
	};
};
foreach (name in ["canStart", "start", "stage", "findLocation", "ensureLocations", "cleanupLocations", "syncRewards", "gallery", "dto", "battleWon"]) wrap(name);
local request = chapters.request;
chapters.request = function(data)
{
	local loop = typeof data == "table" && "ID" in data ? this.loopService(data.ID) : null;
	return loop == null ? request.call(this, data) : loop.request(data);
};
