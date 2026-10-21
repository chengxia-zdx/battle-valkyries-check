// Chapter outfits are visual-only; entitlement is awarded by the common chapter service.
local bv = ::$bvvar{namespace};
bv.Skins.rachel_dawn_tea_skin <- {
 ID = "rachel_dawn_tea_skin", ValkyrieID = "rachel_alucard", IsOriginal = false, UnlockChapter = "thirteenth_bell",
 Name = "$bv{chapter.thirteenth_bell.skin.rachel.name}", TabName = "$bv{chapter.thirteenth_bell.skin.rachel.name}", Description = "$bv{chapter.thirteenth_bell.skin.rachel.description}",
 Brush = "bust_bv_rachel_dawn_tea_skin", DeathBrush = "bust_bv_rachel_dawn_tea_skin_dead", WorldLeaderBrush = "world_bv_rachel_dawn_tea_leader",
 Portrait = "ui/chapters/thirteenth_bell/rachel_dawn_tea_portrait.png", Preview = "ui/valkyries/rachel_dawn_tea_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/rachel_alucard_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/rachel_dawn_tea_skin_icon.png",
 DetailMedia = { Poster = "ui/chapters/thirteenth_bell/rachel_dawn_tea_poster.jpg", Video = "", PositionX = 0.5, PositionY = 0.5 }
};
if (bv.Valkyries.rachel_alucard.SkinIDs.find("rachel_dawn_tea_skin") == null) bv.Valkyries.rachel_alucard.SkinIDs.push("rachel_dawn_tea_skin");
bv.Skins.es_homeward_watch_skin <- {
 ID = "es_homeward_watch_skin", ValkyrieID = "es", IsOriginal = false, UnlockChapter = "thirteenth_bell",
 Name = "$bv{chapter.thirteenth_bell.skin.es.name}", TabName = "$bv{chapter.thirteenth_bell.skin.es.name}", Description = "$bv{chapter.thirteenth_bell.skin.es.description}",
 Brush = "bust_bv_es_homeward_watch_skin", DeathBrush = "bust_bv_es_homeward_watch_skin_dead", WorldLeaderBrush = "world_bv_es_homeward_watch_leader",
 Portrait = "ui/chapters/thirteenth_bell/es_homeward_watch_portrait.png", Preview = "ui/valkyries/es_homeward_watch_skin_preview.png",
 TraitIcon = "ui/traits/$bvvar{iconPrefix}/es_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/es_homeward_watch_skin_icon.png",
 DetailMedia = { Poster = "ui/chapters/thirteenth_bell/es_homeward_watch_poster.jpg", Video = "", PositionX = 0.5, PositionY = 0.5 }
};
if (bv.Valkyries.es.SkinIDs.find("es_homeward_watch_skin") == null) bv.Valkyries.es.SkinIDs.push("es_homeward_watch_skin");
