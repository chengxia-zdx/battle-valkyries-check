// Standalone chapter; all progression and rewards are committed by the shared service.
::$bvvar{namespace}.ChapterDefinitions.silent_city_encore <- {
	ID = "silent_city_encore",
	Name = "$bv{chapter.silent_city.name}",
	Description = "$bv{chapter.silent_city.description}",
	Poster = "ui/chapters/silent_city_encore/cover.jpg",
	Actors = [
		"robin",
		"togawa_sakiko"
	],
	PortraitOrder = [
		"robin",
		"togawa_sakiko"
	],
	Portraits = {
		robin = "ui/chapters/silent_city_encore/robin_standing.png",
		togawa_sakiko = "ui/chapters/silent_city_encore/togawa_sakiko_standing.png"
	},
	Videos = {

	},
	LocationScript = "scripts/entity/world/locations/battle_valkyries/silent_city_encore_chapter_location",
	Ending = "$bv{chapter.silent_city.ending}",
	Scenes = {
		opening = {
			Title = "$bv{chapter.silent_city.opening.name}",
			Background = "ui/chapters/silent_city_encore/stage1.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.opening.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.opening.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.opening.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.opening.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.opening.line5}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.opening.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.opening.line7}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.opening.line8}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.opening.line9}"
				}
			]
		},
		stage1 = {
			Title = "$bv{chapter.silent_city.stage1.name}",
			Background = "ui/chapters/silent_city_encore/stage1.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage1.line1}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage1.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage1.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage1.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage1.line5}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage1.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage1.line7}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage1.line8}"
				}
			]
		},
		stage2 = {
			Title = "$bv{chapter.silent_city.stage2.name}",
			Background = "ui/chapters/silent_city_encore/stage2.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage2.line1}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage2.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage2.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage2.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage2.line5}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage2.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage2.line7}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage2.line8}"
				}
			]
		},
		stage3 = {
			Title = "$bv{chapter.silent_city.stage3.name}",
			Background = "ui/chapters/silent_city_encore/cg_rest.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage3.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage3.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage3.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage3.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage3.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage3.line6}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage3.line7}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage3.line8}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage3.line9}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage3.line10}"
				}
			],
			PortraitOrder = []
		},
		stage4 = {
			Title = "$bv{chapter.silent_city.stage4.name}",
			Background = "ui/chapters/silent_city_encore/stage4.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage4.line1}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage4.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage4.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage4.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage4.line5}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage4.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage4.line7}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage4.line8}"
				}
			],
			Portraits = {
				robin = "ui/chapters/silent_city_encore/robin_resolved.png",
				togawa_sakiko = "ui/chapters/silent_city_encore/togawa_sakiko_resolved.png"
			}
		},
		stage5 = {
			Title = "$bv{chapter.silent_city.stage5.name}",
			Background = "ui/chapters/silent_city_encore/stage5.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage5.line1}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage5.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage5.line3}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage5.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage5.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage5.line6}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage5.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage5.line8}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage5.line9}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage5.line10}"
				}
			]
		},
		stage6 = {
			Title = "$bv{chapter.silent_city.stage6.name}",
			Background = "ui/chapters/silent_city_encore/stage6.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage6.line1}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage6.line2}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage6.line3}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage6.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage6.line5}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage6.line6}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage6.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage6.line8}"
				}
			],
			Portraits = {
				robin = "ui/chapters/silent_city_encore/robin_resolved.png",
				togawa_sakiko = "ui/chapters/silent_city_encore/togawa_sakiko_resolved.png"
			}
		},
		stage7 = {
			Title = "$bv{chapter.silent_city.stage7.name}",
			Background = "ui/chapters/silent_city_encore/cg_handoff.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage7.line1}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage7.line2}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage7.line3}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage7.line4}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage7.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage7.line6}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage7.line7}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage7.line8}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage7.line9}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage7.line10}"
				}
			],
			PortraitOrder = []
		},
		stage8 = {
			Title = "$bv{chapter.silent_city.stage8.name}",
			Background = "ui/chapters/silent_city_encore/cg_encore.jpg",
			Video = "",
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line2}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage8.line3}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage8.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line7}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage8.line8}"
				},
				{
					Speaker = "togawa_sakiko",
					Text = "$bv{chapter.silent_city.stage8.line9}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.silent_city.stage8.line10}"
				},
				{
					Speaker = "robin",
					Text = "$bv{chapter.silent_city.stage8.line11}"
				}
			],
			PortraitOrder = []
		},
		preparation_auditorium_complete = { Title = "$bv{chapter.preparation.silent_city.auditorium_complete.name}", Video = "", Background = "ui/chapters/silent_city_encore/stage1.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.auditorium_complete.text}" }] },
		preparation_rehearsal_complete = { Title = "$bv{chapter.preparation.silent_city.rehearsal_complete.name}", Video = "", Background = "ui/chapters/silent_city_encore/cg_rest.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.rehearsal_complete.text}" }] },
		preparation_prep_3_2 = { Title = "$bv{chapter.preparation.silent_city.prep_3_2.name}", Video = "", Background = "ui/chapters/silent_city_encore/cg_rest.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.prep_3_2.text}" }] },
		preparation_platform_complete = { Title = "$bv{chapter.preparation.silent_city.platform_complete.name}", Video = "", Background = "ui/chapters/silent_city_encore/stage5.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.platform_complete.text}" }] },
		preparation_dress_rehearsal_complete = { Title = "$bv{chapter.preparation.silent_city.dress_rehearsal_complete.name}", Video = "", Background = "ui/chapters/silent_city_encore/cg_handoff.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.dress_rehearsal_complete.text}" }] },
		preparation_prep_7_2 = { Title = "$bv{chapter.preparation.silent_city.prep_7_2.name}", Video = "", Background = "ui/chapters/silent_city_encore/cg_handoff.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.silent_city.prep_7_2.text}" }] }
	},
	PreparationVersion = 1,
	Evidence = [{ Key = "instrument_parts", Name = "$bv{chapter.preparation.silent_city.evidence.instrument_parts}", Stage = 2, Source = "$bv{chapter.preparation.silent_city.evidence.instrument_parts.source}" }],
	Stages = [
		{
			Name = "$bv{chapter.silent_city.stage1.name}",
			Brief = "$bv{chapter.silent_city.stage1.brief}",
			Scene = "stage1",
			Money = 800,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [{ Key = "auditorium_complete", Node = "auditorium", Name = "$bv{chapter.preparation.silent_city.auditorium_complete.name}", Action = "$bv{chapter.preparation.silent_city.auditorium_complete.name}", Battle = false, Scene = "preparation_auditorium_complete", LegacyGoal = "auditorium_complete" }],
			Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
		},
		{
			Name = "$bv{chapter.silent_city.stage2.name}",
			Brief = "$bv{chapter.silent_city.stage2.brief}",
			Scene = "stage2",
			Money = 1600,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [
				{
					Key = "warehouse_complete",
					Node = "warehouse",
					Name = "$bv{chapter.silent_city.node.warehouse}",
					Battle = true
				}
			],
			Materials = []
		},
		{
			Name = "$bv{chapter.silent_city.stage3.name}",
			Brief = "$bv{chapter.silent_city.stage3.brief}",
			Scene = "stage3",
			Money = 1200,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [{ Key = "rehearsal_complete", Node = "rehearsal", Name = "$bv{chapter.preparation.silent_city.rehearsal_complete.name}", Action = "$bv{chapter.preparation.silent_city.rehearsal_complete.name}", Battle = false, Scene = "preparation_rehearsal_complete", LegacyGoal = "rehearsal_complete" }, { Key = "prep_3_2", Node = "rehearsal", Name = "$bv{chapter.preparation.silent_city.prep_3_2.name}", Action = "$bv{chapter.preparation.silent_city.prep_3_2.name}", Battle = false, Scene = "preparation_prep_3_2", LegacyGoal = "rehearsal_complete", Requires = ["rehearsal_complete"] }],
			Materials = []
		, RequiredEvidence = ["instrument_parts"] },
		{
			Name = "$bv{chapter.silent_city.stage4.name}",
			Brief = "$bv{chapter.silent_city.stage4.brief}",
			Scene = "stage4",
			Money = 2600,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [
				{
					Key = "tunnels_complete",
					Node = "tunnels",
					Name = "$bv{chapter.silent_city.node.tunnels}",
					Battle = true
				}
			],
			Materials = []
		},
		{
			Name = "$bv{chapter.silent_city.stage5.name}",
			Brief = "$bv{chapter.silent_city.stage5.brief}",
			Scene = "stage5",
			Money = 1800,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [{ Key = "platform_complete", Node = "platform", Name = "$bv{chapter.preparation.silent_city.platform_complete.name}", Action = "$bv{chapter.preparation.silent_city.platform_complete.name}", Battle = false, Scene = "preparation_platform_complete", LegacyGoal = "platform_complete" }],
			Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 15 }, { Key = "spider_silk", Name = "$bv{chapter.preparation.material.spider_silk}", Source = "$bv{chapter.preparation.stock_source}", Count = 1, Item = "misc.spider_silk", Script = "scripts/items/misc/spider_silk_item" }]
		},
		{
			Name = "$bv{chapter.silent_city.stage6.name}",
			Brief = "$bv{chapter.silent_city.stage6.brief}",
			Scene = "stage6",
			Money = 4000,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.silent_city.reward.story}",
			Goals = [
				{
					Key = "quarry_complete",
					Node = "quarry",
					Name = "$bv{chapter.silent_city.node.quarry}",
					Battle = true
				}
			],
			Materials = []
		},
		{
			Name = "$bv{chapter.silent_city.stage7.name}",
			Brief = "$bv{chapter.silent_city.stage7.brief}",
			Scene = "stage7",
			Money = 2000,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.silent_city.reward.growth}",
			Goals = [{ Key = "dress_rehearsal_complete", Node = "dress_rehearsal", Name = "$bv{chapter.preparation.silent_city.dress_rehearsal_complete.name}", Action = "$bv{chapter.preparation.silent_city.dress_rehearsal_complete.name}", Battle = false, Scene = "preparation_dress_rehearsal_complete", LegacyGoal = "dress_rehearsal_complete" }, { Key = "prep_7_2", Node = "dress_rehearsal", Name = "$bv{chapter.preparation.silent_city.prep_7_2.name}", Action = "$bv{chapter.preparation.silent_city.prep_7_2.name}", Battle = false, Scene = "preparation_prep_7_2", LegacyGoal = "dress_rehearsal_complete", Requires = ["dress_rehearsal_complete"] }],
			Materials = []
		},
		{
			Name = "$bv{chapter.silent_city.stage8.name}",
			Brief = "$bv{chapter.silent_city.stage8.brief}",
			Scene = "stage8",
			Money = 8000,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.silent_city.reward.ending}",
			Goals = [
				{
					Key = "resonance_complete",
					Node = "resonance",
					Name = "$bv{chapter.silent_city.node.resonance}",
					Battle = true
				}
			],
			Materials = []
		}
	],
	Nodes = {
		auditorium = {
			Name = "$bv{chapter.silent_city.node.auditorium}",
			Brush = "world_ruins_01",
			Battle = false
		},
		warehouse = {
			Name = "$bv{chapter.silent_city.node.warehouse}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		rehearsal = {
			Name = "$bv{chapter.silent_city.node.rehearsal}",
			Brush = "world_ruins_01",
			Battle = false
		},
		tunnels = {
			Name = "$bv{chapter.silent_city.node.tunnels}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		platform = {
			Name = "$bv{chapter.silent_city.node.platform}",
			Brush = "world_ruins_01",
			Battle = false
		},
		quarry = {
			Name = "$bv{chapter.silent_city.node.quarry}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		dress_rehearsal = {
			Name = "$bv{chapter.silent_city.node.dress_rehearsal}",
			Brush = "world_ruins_01",
			Battle = false
		},
		resonance = {
			Name = "$bv{chapter.silent_city.node.resonance}",
			Brush = "world_bandit_camp_01",
			Battle = true
		}
	},
	SkillRewards = [
		{
			Actor = "robin",
			Stage = 7,
			Key = "silent_city_robin_breath"
		},
		{
			Actor = "togawa_sakiko",
			Stage = 7,
			Key = "silent_city_sakiko_entry"
		}
	],
	SkinRewards = [
		{
			Actor = "robin",
			Stage = 8,
			Skin = "robin_wind_encore_skin"
		},
		{
			Actor = "togawa_sakiko",
			Stage = 8,
			Skin = "togawa_sakiko_morning_rehearsal_skin"
		}
	],
	Gallery = [
		{
			ID = "rest",
			Stage = 3,
			Title = "$bv{chapter.silent_city.cg.rest.title}",
			Caption = "$bv{chapter.silent_city.cg.rest.caption}",
			Image = "ui/chapters/silent_city_encore/cg_rest.jpg"
		},
		{
			ID = "handoff",
			Stage = 7,
			Title = "$bv{chapter.silent_city.cg.handoff.title}",
			Caption = "$bv{chapter.silent_city.cg.handoff.caption}",
			Image = "ui/chapters/silent_city_encore/cg_handoff.jpg"
		},
		{
			ID = "encore",
			Stage = 8,
			Title = "$bv{chapter.silent_city.cg.encore.title}",
			Caption = "$bv{chapter.silent_city.cg.encore.caption}",
			Image = "ui/chapters/silent_city_encore/cg_encore.jpg"
		}
	]
};

::$bvvar{namespace}.Skins.robin_wind_encore_skin <- {
	ID = "robin_wind_encore_skin",
	ValkyrieID = "robin", IsOriginal = false,
	UnlockChapter = "silent_city_encore",
	Name = "$bv{skin.robin_wind_encore_skin.name}",
	TabName = "$bv{skin.robin_wind_encore_skin.tab_name}",
	Description = "$bv{skin.robin_wind_encore_skin.description}",
	Brush = "bust_bv_robin_wind_encore_skin",
	DeathBrush = "bust_bv_robin_wind_encore_skin_dead",
	WorldLeaderBrush = "world_bv_robin_wind_encore_leader",
	Portrait = "ui/valkyries/robin_wind_encore_card.png",
	Preview = "ui/valkyries/robin_wind_encore_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/robin_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/robin_wind_encore_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/robin_wind_encore_skin_poster.jpg",
		Video = "ui/valkyries/detail/robin_wind_encore_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
::$bvvar{namespace}.Valkyries.robin.SkinIDs <- ["robin_skin", "robin_wind_encore_skin"];
::$bvvar{namespace}.Skins.togawa_sakiko_morning_rehearsal_skin <- {
	ID = "togawa_sakiko_morning_rehearsal_skin",
	ValkyrieID = "togawa_sakiko", IsOriginal = false,
	UnlockChapter = "silent_city_encore",
	Name = "$bv{skin.togawa_sakiko_morning_rehearsal_skin.name}",
	TabName = "$bv{skin.togawa_sakiko_morning_rehearsal_skin.tab_name}",
	Description = "$bv{skin.togawa_sakiko_morning_rehearsal_skin.description}",
	Brush = "bust_bv_togawa_sakiko_morning_rehearsal_skin",
	DeathBrush = "bust_bv_togawa_sakiko_morning_rehearsal_skin_dead",
	WorldLeaderBrush = "world_bv_togawa_sakiko_morning_rehearsal_leader",
	Portrait = "ui/chapters/silent_city_encore/togawa_sakiko_standing.png",
	Preview = "ui/valkyries/togawa_sakiko_morning_rehearsal_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/togawa_sakiko_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/togawa_sakiko_morning_rehearsal_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/togawa_sakiko_morning_rehearsal_skin_poster.jpg",
		Video = "ui/valkyries/detail/togawa_sakiko_morning_rehearsal_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
::$bvvar{namespace}.Valkyries.togawa_sakiko.SkinIDs <- ["togawa_sakiko_skin", "togawa_sakiko_morning_rehearsal_skin"];
