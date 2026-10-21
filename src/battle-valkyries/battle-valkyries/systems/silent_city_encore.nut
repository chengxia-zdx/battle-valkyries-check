// Actor-owned, epoch-scoped usage survives skill reconstruction and equipment changes.
::$bvvar{namespace}.encoreMemoryAvailable <- function(actor, key)
{
	if (actor == null || ::$bvvar{namespace}.isActorDeadOrDying(actor) || !actor.isPlacedOnMap() || !actor.isPlayerControlled()) return false;
	local identity = key == "silent_city_robin_breath" ? "robin" : "togawa_sakiko";
	if (::$bvvar{namespace}.getActorValkyrieID(actor) != identity || !::$bvvar{namespace}.hasValkyrieLearnedSkillEntitlement(actor, key)) return false;
	return !("BVEncoreMemory" in actor.m) || actor.m.BVEncoreMemory.Epoch != ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch || !(key in actor.m.BVEncoreMemory.Used);
};
::$bvvar{namespace}.consumeEncoreMemory <- function(actor, key)
{
	if (!::$bvvar{namespace}.encoreMemoryAvailable(actor, key)) return false;
	if (!("BVEncoreMemory" in actor.m) || actor.m.BVEncoreMemory.Epoch != ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch)
		actor.m.BVEncoreMemory <- { Epoch = ::$bvvar{namespace}.ValkyrieCombatEvents.Epoch, Used = {} };
	actor.m.BVEncoreMemory.Used[key] <- true;
	return true;
};
