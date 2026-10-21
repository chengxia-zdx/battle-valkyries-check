// Stable save ID; shared chapter transactions, participation and gallery rules.
::$bvvar{namespace}.ChapterDefinitions.royal_banner_returning_tide <- {
	ID = "royal_banner_returning_tide",
	Name = "$bv{chapter.royal_tide.name}",
	Description = "$bv{chapter.royal_tide.description}",
	Ending = "$bv{chapter.royal_tide.ending}",
	Poster = "ui/chapters/royal_banner_returning_tide/cover.jpg",
	Actors = ["cerydra", "hysilens"],
	PortraitOrder = ["cerydra", "hysilens"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/royal_tide_chapter_location",
	Videos = {

	},
	Portraits = {
		cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_standing.png",
		hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.royal_tide.opening.name}",
			Background = "ui/chapters/royal_banner_returning_tide/cover.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.opening.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.opening.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.opening.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.opening.line4}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_standing.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_standing.png"
			}
		},
		stage1 = {
			Title = "$bv{chapter.royal_tide.stage1.name}",
			Background = "ui/chapters/royal_banner_returning_tide/stage1.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage1.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage1.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage1.line3}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage1.line4}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage1.line5}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage1.line6}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_resolved.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_resolved.png"
			}
		},
		stage2 = {
			Title = "$bv{chapter.royal_tide.stage2.name}",
			Background = "ui/chapters/royal_banner_returning_tide/stage2.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage2.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage2.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage2.line3}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage2.line4}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage2.line5}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage2.line6}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_resolved.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_resolved.png"
			}
		},
		stage3 = {
			Title = "$bv{chapter.royal_tide.stage3.name}",
			Background = "ui/chapters/royal_banner_returning_tide/cg_lamplight.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage3.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage3.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage3.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage3.line4}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage3.line5}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage3.line6}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage3.line7}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_soft.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_soft.png"
			},
			PortraitOrder = []
		},
		stage4 = {
			Title = "$bv{chapter.royal_tide.stage4.name}",
			Background = "ui/chapters/royal_banner_returning_tide/stage4.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage4.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage4.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage4.line3}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage4.line4}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage4.line5}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage4.line6}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_resolved.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_resolved.png"
			}
		},
		stage5 = {
			Title = "$bv{chapter.royal_tide.stage5.name}",
			Background = "ui/chapters/royal_banner_returning_tide/cg_tidewatch.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage5.line1}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage5.line2}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage5.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage5.line4}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage5.line5}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage5.line6}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage5.line7}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage5.line8}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_soft.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_soft.png"
			},
			PortraitOrder = []
		},
		stage6 = {
			Title = "$bv{chapter.royal_tide.stage6.name}",
			Background = "ui/chapters/royal_banner_returning_tide/stage6.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage6.line1}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage6.line2}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage6.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage6.line4}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage6.line5}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage6.line6}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_resolved.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_resolved.png"
			}
		},
		stage7 = {
			Title = "$bv{chapter.royal_tide.stage7.name}",
			Background = "ui/chapters/royal_banner_returning_tide/cg_oath_blade.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage7.line1}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage7.line2}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage7.line3}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage7.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage7.line5}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage7.line6}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage7.line7}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage7.line8}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_soft.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_soft.png"
			},
			PortraitOrder = []
		},
		stage8 = {
			Title = "$bv{chapter.royal_tide.stage8.name}",
			Background = "ui/chapters/royal_banner_returning_tide/cg_ending.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage8.line1}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage8.line2}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage8.line3}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage8.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage8.line5}"
			}, {
				Speaker = "cerydra",
				Text = "$bv{chapter.royal_tide.stage8.line6}"
			}, {
				Speaker = "hysilens",
				Text = "$bv{chapter.royal_tide.stage8.line7}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.royal_tide.stage8.line8}"
			}],
			Portraits = {
				cerydra = "ui/chapters/royal_banner_returning_tide/cerydra_soft.png",
				hysilens = "ui/chapters/royal_banner_returning_tide/hysilens_soft.png"
			},
			PortraitOrder = []
		},
		preparation_seawall_complete = { Title = "$bv{chapter.preparation.royal_tide.seawall_complete.name}", Video = "", Background = "ui/chapters/royal_banner_returning_tide/stage1.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.royal_tide.seawall_complete.text}" }] },
		preparation_lighthouse_complete = { Title = "$bv{chapter.preparation.royal_tide.lighthouse_complete.name}", Video = "", Background = "ui/chapters/royal_banner_returning_tide/cg_lamplight.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.royal_tide.lighthouse_complete.text}" }] },
		preparation_royal_tent_complete = { Title = "$bv{chapter.preparation.royal_tide.royal_tent_complete.name}", Video = "", Background = "ui/chapters/royal_banner_returning_tide/cg_tidewatch.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.royal_tide.royal_tent_complete.text}" }] },
		preparation_prep_5_2 = { Title = "$bv{chapter.preparation.royal_tide.prep_5_2.name}", Video = "", Background = "ui/chapters/royal_banner_returning_tide/cg_tidewatch.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.royal_tide.prep_5_2.text}" }] },
		preparation_returning_forge_complete = { Title = "$bv{chapter.preparation.royal_tide.returning_forge_complete.name}", Video = "", Background = "ui/chapters/royal_banner_returning_tide/cg_oath_blade.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.royal_tide.returning_forge_complete.text}" }] }
	},
	PreparationVersion = 1,
	Evidence = [{ Key = "evacuation_plans", Name = "$bv{chapter.preparation.royal_tide.evidence.evacuation_plans}", Stage = 4, Source = "$bv{chapter.preparation.royal_tide.evidence.evacuation_plans.source}" }, { Key = "relay_core", Name = "$bv{chapter.preparation.royal_tide.evidence.relay_core}", Stage = 6, Source = "$bv{chapter.preparation.royal_tide.evidence.relay_core.source}" }],
	Stages = [
		{
		Name = "$bv{chapter.royal_tide.stage1.name}",
		Brief = "$bv{chapter.royal_tide.stage1.brief}",
		Scene = "stage1",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.royal_tide.reward.story}",
		Goals = [{ Key = "seawall_complete", Node = "seawall", Name = "$bv{chapter.preparation.royal_tide.seawall_complete.name}", Action = "$bv{chapter.preparation.royal_tide.seawall_complete.name}", Battle = false, Scene = "preparation_seawall_complete", LegacyGoal = "seawall_complete" }],
		Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
	},
		{
		Name = "$bv{chapter.royal_tide.stage2.name}",
		Brief = "$bv{chapter.royal_tide.stage2.brief}",
		Scene = "stage2",
		Money = 1400,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.royal_tide.reward.battle}",
		Goals = [{
			Key = "causeway_complete",
			Node = "causeway",
			Name = "$bv{chapter.royal_tide.node.causeway}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.royal_tide.stage3.name}",
		Brief = "$bv{chapter.royal_tide.stage3.brief}",
		Scene = "stage3",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.royal_tide.reward.story}",
		Goals = [{ Key = "lighthouse_complete", Node = "lighthouse", Name = "$bv{chapter.preparation.royal_tide.lighthouse_complete.name}", Action = "$bv{chapter.preparation.royal_tide.lighthouse_complete.name}", Battle = false, Scene = "preparation_lighthouse_complete", LegacyGoal = "lighthouse_complete" }],
		Materials = [{ Key = "medicine", Name = "$bv{chapter.preparation.material.medicine}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }, { Key = "grain", Name = "$bv{chapter.preparation.material.grain}", Source = "$bv{chapter.preparation.stock_source}", Count = 1, Item = "supplies.ground_grains", Script = "scripts/items/supplies/ground_grains_item" }]
	},
		{
		Name = "$bv{chapter.royal_tide.stage4.name}",
		Brief = "$bv{chapter.royal_tide.stage4.brief}",
		Scene = "stage4",
		Money = 2200,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.royal_tide.reward.battle}",
		Goals = [{
			Key = "archive_complete",
			Node = "archive",
			Name = "$bv{chapter.royal_tide.node.archive}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.royal_tide.stage5.name}",
		Brief = "$bv{chapter.royal_tide.stage5.brief}",
		Scene = "stage5",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.royal_tide.reward.story}",
		Goals = [{ Key = "royal_tent_complete", Node = "royal_tent", Name = "$bv{chapter.preparation.royal_tide.royal_tent_complete.name}", Action = "$bv{chapter.preparation.royal_tide.royal_tent_complete.name}", Battle = false, Scene = "preparation_royal_tent_complete", LegacyGoal = "royal_tent_complete" }, { Key = "prep_5_2", Node = "royal_tent", Name = "$bv{chapter.preparation.royal_tide.prep_5_2.name}", Action = "$bv{chapter.preparation.royal_tide.prep_5_2.name}", Battle = false, Scene = "preparation_prep_5_2", LegacyGoal = "royal_tent_complete", Requires = ["royal_tent_complete"] }],
		Materials = []
	, RequiredEvidence = ["evacuation_plans"] },
		{
		Name = "$bv{chapter.royal_tide.stage6.name}",
		Brief = "$bv{chapter.royal_tide.stage6.brief}",
		Scene = "stage6",
		Money = 3000,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.royal_tide.reward.battle}",
		Goals = [{
			Key = "signal_corridor_complete",
			Node = "signal_corridor",
			Name = "$bv{chapter.royal_tide.node.signal_corridor}",
			Battle = true
		}],
		Materials = []
	},
		{
		Name = "$bv{chapter.royal_tide.stage7.name}",
		Brief = "$bv{chapter.royal_tide.stage7.brief}",
		Scene = "stage7",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.royal_tide.reward.growth}",
		Goals = [{ Key = "returning_forge_complete", Node = "returning_forge", Name = "$bv{chapter.preparation.royal_tide.returning_forge_complete.name}", Action = "$bv{chapter.preparation.royal_tide.returning_forge_complete.name}", Battle = false, Scene = "preparation_returning_forge_complete", LegacyGoal = "returning_forge_complete" }],
		Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
	, RequiredEvidence = ["relay_core"] },
		{
		Name = "$bv{chapter.royal_tide.stage8.name}",
		Brief = "$bv{chapter.royal_tide.stage8.brief}",
		Scene = "stage8",
		Money = 6000,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.royal_tide.reward.ending}",
		Goals = [{
			Key = "oath_core_complete",
			Node = "oath_core",
			Name = "$bv{chapter.royal_tide.node.oath_core}",
			Battle = true
		}],
		Materials = []
	}
	],
	Nodes = {
		seawall = {
			Name = "$bv{chapter.royal_tide.node.seawall}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = false
		},
		causeway = {
			Name = "$bv{chapter.royal_tide.node.causeway}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = true
		},
		lighthouse = {
			Name = "$bv{chapter.royal_tide.node.lighthouse}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = false
		},
		archive = {
			Name = "$bv{chapter.royal_tide.node.archive}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = true
		},
		royal_tent = {
			Name = "$bv{chapter.royal_tide.node.royal_tent}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = false
		},
		signal_corridor = {
			Name = "$bv{chapter.royal_tide.node.signal_corridor}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = true
		},
		returning_forge = {
			Name = "$bv{chapter.royal_tide.node.returning_forge}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = false
		},
		oath_core = {
			Name = "$bv{chapter.royal_tide.node.oath_core}",
			Brush = "world_bv_royal_banner_returning_tide",
			Battle = true
		}
	},
	SkillRewards = [{
		Actor = "cerydra",
		Stage = 7,
		Key = "royal_tide_cerydra_growth"
	}, {
		Actor = "hysilens",
		Stage = 7,
		Key = "royal_tide_hysilens_growth"
	}],
	SkinRewards = [{
		Actor = "cerydra",
		Stage = 8,
		Skin = "cerydra_tidal_regalia_skin"
	}, {
		Actor = "hysilens",
		Stage = 8,
		Skin = "hysilens_returning_sword_banner_skin"
	}],
	Gallery = [{
		ID = "lamplight",
		Stage = 3,
		Title = "$bv{chapter.royal_tide.cg.lamplight.title}",
		Caption = "$bv{chapter.royal_tide.cg.lamplight.caption}",
		Image = "ui/chapters/royal_banner_returning_tide/cg_lamplight.jpg"
	}, {
		ID = "tidewatch",
		Stage = 5,
		Title = "$bv{chapter.royal_tide.cg.tidewatch.title}",
		Caption = "$bv{chapter.royal_tide.cg.tidewatch.caption}",
		Image = "ui/chapters/royal_banner_returning_tide/cg_tidewatch.jpg"
	}, {
		ID = "oath_blade",
		Stage = 7,
		Title = "$bv{chapter.royal_tide.cg.oath_blade.title}",
		Caption = "$bv{chapter.royal_tide.cg.oath_blade.caption}",
		Image = "ui/chapters/royal_banner_returning_tide/cg_oath_blade.jpg"
	}, {
		ID = "ending",
		Stage = 8,
		Title = "$bv{chapter.royal_tide.cg.ending.title}",
		Caption = "$bv{chapter.royal_tide.cg.ending.caption}",
		Image = "ui/chapters/royal_banner_returning_tide/cg_ending.jpg"
	}]
};
::$bvvar{namespace}.Skins.cerydra_tidal_regalia_skin <- {
	ID = "cerydra_tidal_regalia_skin",
	ValkyrieID = "cerydra",
	IsOriginal = false,
	UnlockChapter = "royal_banner_returning_tide",
	Name = "$bv{skin.cerydra_tidal_regalia_skin.name}",
	TabName = "$bv{skin.cerydra_tidal_regalia_skin.tab_name}",
	Description = "$bv{skin.cerydra_tidal_regalia_skin.description}",
	Brush = "bust_bv_cerydra_tidal_regalia_skin",
	DeathBrush = "bust_bv_cerydra_tidal_regalia_skin_dead",
	WorldLeaderBrush = "world_bv_cerydra_tidal_regalia_leader",
	Portrait = "ui/chapters/royal_banner_returning_tide/cerydra_soft.png",
	Preview = "ui/valkyries/cerydra_tidal_regalia_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/cerydra_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/cerydra_tidal_regalia_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/cerydra_tidal_regalia_skin_poster.jpg",
		Video = "ui/valkyries/detail/cerydra_tidal_regalia_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.cerydra)) ::$bvvar{namespace}.Valkyries.cerydra.SkinIDs <- ["cerydra_skin"];
if (::$bvvar{namespace}.Valkyries.cerydra.SkinIDs.find("cerydra_tidal_regalia_skin") == null) ::$bvvar{namespace}.Valkyries.cerydra.SkinIDs.push("cerydra_tidal_regalia_skin");
::$bvvar{namespace}.Skins.hysilens_returning_sword_banner_skin <- {
	ID = "hysilens_returning_sword_banner_skin",
	ValkyrieID = "hysilens",
	IsOriginal = false,
	UnlockChapter = "royal_banner_returning_tide",
	Name = "$bv{skin.hysilens_returning_sword_banner_skin.name}",
	TabName = "$bv{skin.hysilens_returning_sword_banner_skin.tab_name}",
	Description = "$bv{skin.hysilens_returning_sword_banner_skin.description}",
	Brush = "bust_bv_hysilens_returning_sword_banner_skin",
	DeathBrush = "bust_bv_hysilens_returning_sword_banner_skin_dead",
	WorldLeaderBrush = "world_bv_hysilens_returning_sword_banner_leader",
	Portrait = "ui/chapters/royal_banner_returning_tide/hysilens_soft.png",
	Preview = "ui/valkyries/hysilens_returning_sword_banner_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/hysilens_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/hysilens_returning_sword_banner_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/hysilens_returning_sword_banner_skin_poster.jpg",
		Video = "ui/valkyries/detail/hysilens_returning_sword_banner_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.hysilens)) ::$bvvar{namespace}.Valkyries.hysilens.SkinIDs <- ["hysilens_skin"];
if (::$bvvar{namespace}.Valkyries.hysilens.SkinIDs.find("hysilens_returning_sword_banner_skin") == null) ::$bvvar{namespace}.Valkyries.hysilens.SkinIDs.push("hysilens_returning_sword_banner_skin");
