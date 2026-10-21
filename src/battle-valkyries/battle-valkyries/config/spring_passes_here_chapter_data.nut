// Stable save ID. Progression, transactions and CG visibility use the shared chapter service.
::$bvvar{namespace}.ChapterDefinitions.spring_passes_here <- {
	ID = "spring_passes_here",
	Name = "$bv{chapter.spring.name}",
	Description = "$bv{chapter.spring.description}",
	Ending = "$bv{chapter.spring.ending}",
	Poster = "ui/chapters/spring_passes_here/cover.jpg",
	Actors = ["castorice", "fengjin"],
	PortraitOrder = ["castorice", "fengjin"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/spring_passes_here_chapter_location",
	Videos = {

	},
	Portraits = {
		castorice = "ui/chapters/spring_passes_here/castorice_standing.png",
		fengjin = "ui/chapters/spring_passes_here/fengjin_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.spring.opening.name}",
			Background = "ui/chapters/spring_passes_here/cover.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.opening.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.opening.line2}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.opening.line3}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.opening.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.opening.line5}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_standing.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_standing.png"
			}
		},
		stage1 = {
			Title = "$bv{chapter.spring.stage1.name}",
			Background = "ui/chapters/spring_passes_here/stage1.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage1.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage1.line2}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage1.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage1.line4}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_standing.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_standing.png"
			}
		},
		stage2 = {
			Title = "$bv{chapter.spring.stage2.name}",
			Background = "ui/chapters/spring_passes_here/stage2.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage2.line1}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage2.line2}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage2.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage2.line4}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_resolved.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_resolved.png"
			}
		},
		stage3 = {
			Title = "$bv{chapter.spring.stage3.name}",
			Background = "ui/chapters/spring_passes_here/stage3.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage3.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage3.line2}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage3.line3}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage3.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage3.line5}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_soft.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_soft.png"
			}
		},
		stage4 = {
			Title = "$bv{chapter.spring.stage4.name}",
			Background = "ui/chapters/spring_passes_here/stage4.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage4.line1}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage4.line2}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage4.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage4.line4}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_resolved.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_resolved.png"
			}
		},
		stage5 = {
			Title = "$bv{chapter.spring.stage5.name}",
			Background = "ui/chapters/spring_passes_here/stage5.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage5.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage5.line2}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage5.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage5.line4}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage5.line5}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_soft.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_soft.png"
			}
		},
		stage6 = {
			Title = "$bv{chapter.spring.stage6.name}",
			Background = "ui/chapters/spring_passes_here/stage6.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage6.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage6.line2}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage6.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage6.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage6.line5}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_soft.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_soft.png"
			}
		},
		stage7 = {
			Title = "$bv{chapter.spring.stage7.name}",
			Background = "ui/chapters/spring_passes_here/cg_trial_blade.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage7.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage7.line2}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage7.line3}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage7.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage7.line5}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage7.line6}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_resolved.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_resolved.png"
			},
			PortraitOrder = []
		},
		stage8 = {
			Title = "$bv{chapter.spring.stage8.name}",
			Background = "ui/chapters/spring_passes_here/stage8.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage8.line1}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage8.line2}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage8.line3}"
			}, {
				Speaker = "castorice",
				Text = "$bv{chapter.spring.stage8.line4}"
			}, {
				Speaker = "fengjin",
				Text = "$bv{chapter.spring.stage8.line5}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.spring.stage8.line6}"
			}],
			Portraits = {
				castorice = "ui/chapters/spring_passes_here/castorice_soft.png",
				fengjin = "ui/chapters/spring_passes_here/fengjin_soft.png"
			}
		},
		preparation_waystation_complete = { Title = "$bv{chapter.preparation.spring.waystation_complete.name}", Video = "", Background = "ui/chapters/spring_passes_here/stage1.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.waystation_complete.text}" }] },
		preparation_window_complete = { Title = "$bv{chapter.preparation.spring.window_complete.name}", Video = "", Background = "ui/chapters/spring_passes_here/stage3.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.window_complete.text}" }] },
		preparation_handover_complete = { Title = "$bv{chapter.preparation.spring.handover_complete.name}", Video = "", Background = "ui/chapters/spring_passes_here/stage5.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.handover_complete.text}" }] },
		preparation_prep_5_2 = { Title = "$bv{chapter.preparation.spring.prep_5_2.name}", Video = "", Background = "ui/chapters/spring_passes_here/stage5.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.prep_5_2.text}" }] },
		preparation_forge_complete = { Title = "$bv{chapter.preparation.spring.forge_complete.name}", Video = "", Background = "ui/chapters/spring_passes_here/cg_trial_blade.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.forge_complete.text}" }] },
		preparation_prep_7_2 = { Title = "$bv{chapter.preparation.spring.prep_7_2.name}", Video = "", Background = "ui/chapters/spring_passes_here/cg_trial_blade.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.spring.prep_7_2.text}" }] }
	},
	PreparationVersion = 1,
	Evidence = [{ Key = "cemetery_records", Name = "$bv{chapter.preparation.spring.evidence.cemetery_records}", Stage = 4, Source = "$bv{chapter.preparation.spring.evidence.cemetery_records.source}" }, { Key = "nursery_crystal", Name = "$bv{chapter.preparation.spring.evidence.nursery_crystal}", Stage = 6, Source = "$bv{chapter.preparation.spring.evidence.nursery_crystal.source}" }],
	Stages = [
		{
		Name = "$bv{chapter.spring.stage1.name}",
		Brief = "$bv{chapter.spring.stage1.brief}",
		Scene = "stage1",
		Money = 200,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.spring.reward.story}",
		Goals = [{ Key = "waystation_complete", Node = "waystation", Name = "$bv{chapter.preparation.spring.waystation_complete.name}", Action = "$bv{chapter.preparation.spring.waystation_complete.name}", Battle = false, Scene = "preparation_waystation_complete", LegacyGoal = "waystation_complete" }],
		Materials = [{ Key = "grain", Name = "$bv{chapter.preparation.material.grain}", Source = "$bv{chapter.preparation.stock_source}", Count = 1, Item = "supplies.ground_grains", Script = "scripts/items/supplies/ground_grains_item" }, { Key = "medicine", Name = "$bv{chapter.preparation.material.medicine}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
	},
		{
		Name = "$bv{chapter.spring.stage2.name}",
		Brief = "$bv{chapter.spring.stage2.brief}",
		Scene = "stage2",
		Money = 1400,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.spring.reward.battle}",
		Goals = [{
			Key = "watermill_complete",
			Node = "watermill",
			Name = "$bv{chapter.spring.node.watermill}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.spring.stage3.name}",
		Brief = "$bv{chapter.spring.stage3.brief}",
		Scene = "stage3",
		Money = 300,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.spring.reward.story}",
		Goals = [{ Key = "window_complete", Node = "window", Name = "$bv{chapter.preparation.spring.window_complete.name}", Action = "$bv{chapter.preparation.spring.window_complete.name}", Battle = false, Scene = "preparation_window_complete", LegacyGoal = "window_complete" }],
		Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
	},
		{
		Name = "$bv{chapter.spring.stage4.name}",
		Brief = "$bv{chapter.spring.stage4.brief}",
		Scene = "stage4",
		Money = 2200,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.spring.reward.battle}",
		Goals = [{
			Key = "cemetery_complete",
			Node = "cemetery",
			Name = "$bv{chapter.spring.node.cemetery}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.spring.stage5.name}",
		Brief = "$bv{chapter.spring.stage5.brief}",
		Scene = "stage5",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.spring.reward.story}",
		Goals = [{ Key = "handover_complete", Node = "handover", Name = "$bv{chapter.preparation.spring.handover_complete.name}", Action = "$bv{chapter.preparation.spring.handover_complete.name}", Battle = false, Scene = "preparation_handover_complete", LegacyGoal = "handover_complete" }, { Key = "prep_5_2", Node = "handover", Name = "$bv{chapter.preparation.spring.prep_5_2.name}", Action = "$bv{chapter.preparation.spring.prep_5_2.name}", Battle = false, Scene = "preparation_prep_5_2", LegacyGoal = "handover_complete", Requires = ["handover_complete"] }],
		Materials = []
	, RequiredEvidence = ["cemetery_records"] },
		{
		Name = "$bv{chapter.spring.stage6.name}",
		Brief = "$bv{chapter.spring.stage6.brief}",
		Scene = "stage6",
		Money = 3000,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.spring.reward.battle}",
		Goals = [{
			Key = "nursery_complete",
			Node = "nursery",
			Name = "$bv{chapter.spring.node.nursery}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.spring.stage7.name}",
		Brief = "$bv{chapter.spring.stage7.brief}",
		Scene = "stage7",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.spring.reward.growth}",
		Goals = [{ Key = "forge_complete", Node = "forge", Name = "$bv{chapter.preparation.spring.forge_complete.name}", Action = "$bv{chapter.preparation.spring.forge_complete.name}", Battle = false, Scene = "preparation_forge_complete", LegacyGoal = "forge_complete" }, { Key = "prep_7_2", Node = "forge", Name = "$bv{chapter.preparation.spring.prep_7_2.name}", Action = "$bv{chapter.preparation.spring.prep_7_2.name}", Battle = false, Scene = "preparation_prep_7_2", LegacyGoal = "forge_complete", Requires = ["forge_complete"] }],
		Materials = []
	, RequiredEvidence = ["nursery_crystal"] },
		{
		Name = "$bv{chapter.spring.stage8.name}",
		Brief = "$bv{chapter.spring.stage8.brief}",
		Scene = "stage8",
		Money = 6000,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.spring.reward.ending}",
		Goals = [{
			Key = "bloom_complete",
			Node = "bloom",
			Name = "$bv{chapter.spring.node.bloom}",
			Battle = true
		}],
		Materials = []
	}
	],
	Nodes = {
		waystation = {
			Name = "$bv{chapter.spring.node.waystation}",
			Brush = "world_bv_spring_passes_here",
			Battle = false
		},
		watermill = {
			Name = "$bv{chapter.spring.node.watermill}",
			Brush = "world_bv_spring_passes_here",
			Battle = true
		},
		window = {
			Name = "$bv{chapter.spring.node.window}",
			Brush = "world_bv_spring_passes_here",
			Battle = false
		},
		cemetery = {
			Name = "$bv{chapter.spring.node.cemetery}",
			Brush = "world_bv_spring_passes_here",
			Battle = true
		},
		handover = {
			Name = "$bv{chapter.spring.node.handover}",
			Brush = "world_bv_spring_passes_here",
			Battle = false
		},
		nursery = {
			Name = "$bv{chapter.spring.node.nursery}",
			Brush = "world_bv_spring_passes_here",
			Battle = true
		},
		forge = {
			Name = "$bv{chapter.spring.node.forge}",
			Brush = "world_bv_spring_passes_here",
			Battle = false
		},
		bloom = {
			Name = "$bv{chapter.spring.node.bloom}",
			Brush = "world_bv_spring_passes_here",
			Battle = true
		}
	},
	SkillRewards = [{
		Actor = "castorice",
		Stage = 7,
		Key = "spring_castorice_growth"
	}, {
		Actor = "fengjin",
		Stage = 7,
		Key = "spring_fengjin_growth"
	}],
	SkinRewards = [{
		Actor = "castorice",
		Stage = 8,
		Skin = "castorice_white_flower_return_skin"
	}, {
		Actor = "fengjin",
		Stage = 8,
		Skin = "fengjin_waystation_green_skin"
	}],
	Gallery = [{
		ID = "window_breeze",
		Stage = 3,
		Title = "$bv{chapter.spring.cg.window_breeze.title}",
		Caption = "$bv{chapter.spring.cg.window_breeze.caption}",
		Image = "ui/chapters/spring_passes_here/cg_window_breeze.jpg"
	}, {
		ID = "feather_rest",
		Stage = 6,
		Title = "$bv{chapter.spring.cg.feather_rest.title}",
		Caption = "$bv{chapter.spring.cg.feather_rest.caption}",
		Image = "ui/chapters/spring_passes_here/cg_feather_rest.jpg"
	}, {
		ID = "trial_blade",
		Stage = 7,
		Title = "$bv{chapter.spring.cg.trial_blade.title}",
		Caption = "$bv{chapter.spring.cg.trial_blade.caption}",
		Image = "ui/chapters/spring_passes_here/cg_trial_blade.jpg"
	}, {
		ID = "ending",
		Stage = 8,
		Title = "$bv{chapter.spring.cg.ending.title}",
		Caption = "$bv{chapter.spring.cg.ending.caption}",
		Image = "ui/chapters/spring_passes_here/cg_ending.jpg"
	}, {
		ID = "spring_evening",
		Stage = 8,
		Title = "$bv{chapter.spring.cg.spring_evening.title}",
		Caption = "$bv{chapter.spring.cg.spring_evening.caption}",
		Image = "ui/chapters/spring_passes_here/cg_spring_evening.jpg"
	}]
};
::$bvvar{namespace}.Skins.castorice_white_flower_return_skin <- {
	ID = "castorice_white_flower_return_skin",
	ValkyrieID = "castorice",
	IsOriginal = false,
	UnlockChapter = "spring_passes_here",
	Name = "$bv{skin.castorice_white_flower_return_skin.name}",
	TabName = "$bv{skin.castorice_white_flower_return_skin.tab_name}",
	Description = "$bv{skin.castorice_white_flower_return_skin.description}",
	Brush = "bust_bv_castorice_white_flower_return_skin",
	DeathBrush = "bust_bv_castorice_white_flower_return_skin_dead",
	WorldLeaderBrush = "world_bv_castorice_white_flower_return_leader",
	Portrait = "ui/chapters/spring_passes_here/castorice_soft.png",
	Preview = "ui/valkyries/castorice_white_flower_return_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/castorice_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/castorice_white_flower_return_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/castorice_white_flower_return_skin_poster.jpg",
		Video = "ui/valkyries/detail/castorice_white_flower_return_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.castorice)) ::$bvvar{namespace}.Valkyries.castorice.SkinIDs <- ["castorice_skin"];
if (::$bvvar{namespace}.Valkyries.castorice.SkinIDs.find("castorice_white_flower_return_skin") == null) ::$bvvar{namespace}.Valkyries.castorice.SkinIDs.push("castorice_white_flower_return_skin");
::$bvvar{namespace}.Skins.fengjin_waystation_green_skin <- {
	ID = "fengjin_waystation_green_skin",
	ValkyrieID = "fengjin",
	IsOriginal = false,
	UnlockChapter = "spring_passes_here",
	Name = "$bv{skin.fengjin_waystation_green_skin.name}",
	TabName = "$bv{skin.fengjin_waystation_green_skin.tab_name}",
	Description = "$bv{skin.fengjin_waystation_green_skin.description}",
	Brush = "bust_bv_fengjin_waystation_green_skin",
	DeathBrush = "bust_bv_fengjin_waystation_green_skin_dead",
	WorldLeaderBrush = "world_bv_fengjin_waystation_green_leader",
	Portrait = "ui/chapters/spring_passes_here/fengjin_soft.png",
	Preview = "ui/valkyries/fengjin_waystation_green_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/fengjin_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/fengjin_waystation_green_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/fengjin_waystation_green_skin_poster.jpg",
		Video = "ui/valkyries/detail/fengjin_waystation_green_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.fengjin)) ::$bvvar{namespace}.Valkyries.fengjin.SkinIDs <- ["fengjin_skin"];
if (::$bvvar{namespace}.Valkyries.fengjin.SkinIDs.find("fengjin_waystation_green_skin") == null) ::$bvvar{namespace}.Valkyries.fengjin.SkinIDs.push("fengjin_waystation_green_skin");
