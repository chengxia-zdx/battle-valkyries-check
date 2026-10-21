::$bvvar{namespace}.getQingmingWeapon <- function(actor)
{
	if (actor == null || actor.getItems() == null) return null;
	local item = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
	return item != null && item.getID() == "$bvvar{modId}.weapon.qingming_casket" ? item : null;
};
::$bvvar{namespace}.getYunkiWeaponStage <- function(actor)
{
	local flag = "$bvvar{modId}.yunki.weapon_stage";
	return actor != null && actor.getFlags().has(flag) ? actor.getFlags().get(flag) : 0;
};
::$bvvar{namespace}.syncQingmingWeaponSkills <- function(actor)
{
	if (actor == null) return;
	local item = ::$bvvar{namespace}.getQingmingWeapon(actor), owner = "$bvvar{modId}.owner.item.qingming_casket";
	local valid = item != null && ::$bvvar{namespace}.getActorValkyrieID(actor) == "ye_shunguang";
	if (item != null)
	{
		local previous = item.m.SwordForm; item.refreshForm();
		if (previous != item.m.SwordForm) { actor.getItems().updateAppearance(); actor.setDirty(true); }
	}
	foreach (key in ["qingming_casket_strike", "qingming_unsheathe"])
	{
		local attach = valid && (key == "qingming_casket_strike" || ::$bvvar{namespace}.getYunkiWeaponStage(actor) >= 6);
		if (attach) ::$bvvar{namespace}.attachTransientSkill(actor, key, owner);
		else
		{
			local skill = ::$bvvar{namespace}.getRuntimeSkillByKey(actor, key);
			if (skill != null && skill.hasTransientOwner(owner)) ::$bvvar{namespace}.detachTransientSkill(actor, key, owner);
		}
	}
};
