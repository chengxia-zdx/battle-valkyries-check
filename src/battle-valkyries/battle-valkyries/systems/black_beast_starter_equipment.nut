// Ordinary entry-level equipment shared by test and chapter recruits.
::$bvvar{namespace}.BlackBeastStarterGear <- {
    chloe = ["weapons/shortsword", "shields/wooden_shield"],
    olga = ["weapons/knife", "shields/buckler_shield"],
    alicia = ["weapons/shortsword"],
    prim = ["tools/player_banner"],
    kaguya = ["weapons/pitchfork"],
    maia = ["weapons/shortsword", "shields/wooden_shield"],
    luu_luu = ["weapons/woodcutters_axe"],
    claudia = ["weapons/two_handed_wooden_hammer"],
    celestine = ["weapons/knife", "shields/buckler_shield"]
};
::$bvvar{namespace}.BlackBeastStarterArmor <- ["armor/linen_tunic", "helmets/hood"];

// Call only for actors created by the current recruitment transaction. The caller
// owns rollback, so an item failure must abort delivery of the entire group.
::$bvvar{namespace}.equipBlackBeastStarter <- function(_actor, _id, _context)
{
    local ns = ::$bvvar{namespace};
    if (_actor == null || !(_id in ns.BlackBeastStarterGear)) throw "Unknown Black Beast recruit: " + _id;
    local paths = clone ns.BlackBeastStarterGear[_id];
    paths.extend(ns.BlackBeastStarterArmor);
    foreach (path in paths)
    {
        local item = ns.createValkyrieScriptObject(_context, _actor, "scripts/items/" + path);
        if (item == null || !_actor.getItems().equip(item)) throw "Black Beast starter equipment failed: " + path;
    }
};
