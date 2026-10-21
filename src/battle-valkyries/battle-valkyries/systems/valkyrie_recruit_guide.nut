// Presentation-only metadata. No actor flags, recruitment rules or skill mutation.
::$bvvar{namespace}.validateValkyrieRecruitGuides <- function()
{
	local bv = ::$bvvar{namespace}, labels = bv.ValkyrieRecruitGuideLabels;
	foreach (id in bv.ValkyrieOrder)
	{
		if (!(id in bv.ValkyrieRecruitGuides)) throw "[Battle Valkyries] Missing recruitment assessment: " + id;
		local row = bv.ValkyrieRecruitGuides[id], template = bv.getValkyrieByID(id);
		if (row.Roles.len() == 0 || !(row.Stage in labels.stage) || !(row.Investment in labels.investment))
			throw "[Battle Valkyries] Invalid recruitment assessment: " + id;
		local seen = {};
		foreach (role in row.Roles)
		{
			if (!(role in labels.role) || role in seen) throw "[Battle Valkyries] Invalid recruitment role: " + id;
			seen[role] <- true;
		}
		foreach (tag in row.Tags) if (!(tag in labels.tag)) throw "[Battle Valkyries] Invalid recruitment tag: " + id;
		foreach (rating in [row.Startup, row.Mature]) if (["S", "A", "B", "C"].find(rating) == null)
			throw "[Battle Valkyries] Invalid recruitment rating: " + id;
		foreach (stage in ["early", "mid", "late"])
			if (!(stage in row.Priorities) || typeof row.Priorities[stage] != "integer" || row.Priorities[stage] < 0 || row.Priorities[stage] > 3)
				throw "[Battle Valkyries] Invalid recruitment priority: " + id;
		if (row.Summary == "" || row.Analysis == "" || row.Sources.len() == 0 || row.ReviewedSkills.len() != template.SkillLoadout.len())
			throw "[Battle Valkyries] Incomplete recruitment review: " + id;
		foreach (index, key in template.SkillLoadout) if (row.ReviewedSkills[index] != key)
			throw "[Battle Valkyries] Recruitment review needs updated skill loadout: " + id;
	}
	return true;
};

::$bvvar{namespace}.getValkyrieRecruitGuideCatalog <- function()
{
	local labels = ::$bvvar{namespace}.ValkyrieRecruitGuideLabels;
	local options = function(group, order)
	{
		local result = [];
		foreach (id in order) result.push({ ID = id, Name = group[id] });
		return result;
	};
	return {
		Version = ::$bvvar{namespace}.ValkyrieRecruitGuideVersion,
		Basis = "$bv{ui.hub.guide.ui.basis}", Notice = "$bv{ui.hub.guide.ui.notice}",
		Roles = options(labels.role, ["guard", "warrior", "middle", "ranged", "mage", "mobile", "healer", "control", "banner"]),
		Stages = options(labels.stage, ["early", "mid", "late", "conditional"]),
		Tags = options(labels.tag, ["weapon_free", "signature", "area", "armor", "sustain", "healing", "protection", "team", "growth", "ap", "mobility", "control"])
	};
};

::$bvvar{namespace}.getValkyrieRecruitGuide <- function(_template)
{
	local bv = ::$bvvar{namespace}, id = _template.ID;
	// External packs remain browsable until an explicit assessment is supplied.
	if (!(id in bv.ValkyrieRecruitGuides)) return null;
	local row = bv.ValkyrieRecruitGuides[id], labels = bv.ValkyrieRecruitGuideLabels;
	local names = function(ids, group)
	{
		local text = "";
		foreach (index, key in ids) text += (index == 0 ? "" : " / ") + group[key];
		return text;
	};
	local ranks = { S = 4, A = 3, B = 2, C = 1 };
	local priorityText = {};
	foreach (stage, rank in row.Priorities) priorityText[stage] <- labels.priority[rank.tostring()];
	return {
		RoleIDs = clone row.Roles, RoleText = names(row.Roles, labels.role),
		StageID = row.Stage, StageText = labels.stage[row.Stage], InvestmentText = labels.investment[row.Investment],
		Startup = row.Startup, Mature = row.Mature, StartupRank = ranks[row.Startup], MatureRank = ranks[row.Mature],
		Priorities = clone row.Priorities, PriorityText = priorityText,
		TagIDs = clone row.Tags, TagText = names(row.Tags, labels.tag),
		Summary = row.Summary, Analysis = row.Analysis, Version = bv.ValkyrieRecruitGuideVersion
	};
};
