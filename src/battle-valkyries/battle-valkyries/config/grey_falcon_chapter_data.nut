// Independent eight-stage chapter; persisted by the shared chapter service.
::$bvvar{namespace}.ChapterDefinitions.grey_falcon_last_order <- {
	ID = "grey_falcon_last_order",
	Name = "$bv{chapter.grey_falcon.name}",
	Description = "$bv{chapter.grey_falcon.description}",
	Ending = "$bv{chapter.grey_falcon.ending}",
	Poster = "ui/chapters/grey_falcon_last_order/cover.jpg",
	Actors = ["enterprise", "m4a1"],
	PortraitOrder = ["enterprise", "m4a1"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/grey_falcon_chapter_location",
	Videos = {

	},
	Portraits = {
		enterprise = "ui/chapters/grey_falcon_last_order/enterprise_standing.png",
		m4a1 = "ui/chapters/grey_falcon_last_order/m4a1_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.grey_falcon.opening.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage1.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.opening.line1}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.opening.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.opening.line3}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.opening.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.opening.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.opening.line6}"
				}]
		},
		stage1 = {
			Title = "$bv{chapter.grey_falcon.stage1.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage1.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage1.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage1.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage1.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage1.line4}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage1.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage1.line6}"
				}]
		},
		stage2 = {
			Title = "$bv{chapter.grey_falcon.stage2.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage2.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage2.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage2.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage2.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage2.line4}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage2.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage2.line6}"
				}]
		},
		stage3 = {
			Title = "$bv{chapter.grey_falcon.stage3.name}",
			Background = "ui/chapters/grey_falcon_last_order/cg_hearth.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage3.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage3.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage3.line3}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage3.line4}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage3.line5}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage3.line6}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage3.line7}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage3.line8}"
				}],
			PortraitOrder = []
		},
		stage4 = {
			Title = "$bv{chapter.grey_falcon.stage4.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage4.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage4.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage4.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage4.line3}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage4.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage4.line5}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage4.line6}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage4.line7}"
				}]
		},
		stage5 = {
			Title = "$bv{chapter.grey_falcon.stage5.name}",
			Background = "ui/chapters/grey_falcon_last_order/cg_relief.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage5.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage5.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage5.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage5.line4}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage5.line5}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage5.line6}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage5.line7}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage5.line8}"
				}],
			PortraitOrder = []
		},
		stage6 = {
			Title = "$bv{chapter.grey_falcon.stage6.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage6.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage6.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage6.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage6.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage6.line4}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage6.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage6.line6}"
				}]
		},
		stage7 = {
			Title = "$bv{chapter.grey_falcon.stage7.name}",
			Background = "ui/chapters/grey_falcon_last_order/stage7.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage7.line1}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage7.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage7.line3}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage7.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage7.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage7.line6}"
				}]
		},
		stage8 = {
			Title = "$bv{chapter.grey_falcon.stage8.name}",
			Background = "ui/chapters/grey_falcon_last_order/cg_homecoming.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage8.line1}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage8.line2}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage8.line3}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage8.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage8.line5}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage8.line6}"
				}, {
					Speaker = "m4a1",
					Text = "$bv{chapter.grey_falcon.stage8.line7}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage8.line8}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage8.line9}"
				}, {
					Speaker = "enterprise",
					Text = "$bv{chapter.grey_falcon.stage8.line10}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.grey_falcon.stage8.line11}"
				}],
			PortraitOrder = []
		},
		preparation_aid_post_complete = { Title = "$bv{chapter.preparation.grey_falcon.aid_post_complete.name}", Video = "", Background = "ui/chapters/grey_falcon_last_order/stage1.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.grey_falcon.aid_post_complete.text}" }] },
		preparation_hearth_complete = { Title = "$bv{chapter.preparation.grey_falcon.hearth_complete.name}", Video = "", Background = "ui/chapters/grey_falcon_last_order/cg_hearth.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.grey_falcon.hearth_complete.text}" }] },
		preparation_quarry_road_complete = { Title = "$bv{chapter.preparation.grey_falcon.quarry_road_complete.name}", Video = "", Background = "ui/chapters/grey_falcon_last_order/cg_relief.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.grey_falcon.quarry_road_complete.text}" }] },
		preparation_last_order_complete = { Title = "$bv{chapter.preparation.grey_falcon.last_order_complete.name}", Video = "", Background = "ui/chapters/grey_falcon_last_order/stage7.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.grey_falcon.last_order_complete.text}" }] },
		preparation_prep_7_2 = { Title = "$bv{chapter.preparation.grey_falcon.prep_7_2.name}", Video = "", Background = "ui/chapters/grey_falcon_last_order/stage7.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.grey_falcon.prep_7_2.text}" }] }
	},
	PreparationVersion = 1,
	Evidence = [{ Key = "retreat_order", Name = "$bv{chapter.preparation.grey_falcon.evidence.retreat_order}", Stage = 4, Source = "$bv{chapter.preparation.grey_falcon.evidence.retreat_order.source}" }],
	Stages = [
		{
			Name = "$bv{chapter.grey_falcon.stage1.name}",
			Brief = "$bv{chapter.grey_falcon.stage1.brief}",
			Scene = "stage1",
			Money = 800,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{ Key = "aid_post_complete", Node = "aid_post", Name = "$bv{chapter.preparation.grey_falcon.aid_post_complete.name}", Action = "$bv{chapter.preparation.grey_falcon.aid_post_complete.name}", Battle = false, Scene = "preparation_aid_post_complete", LegacyGoal = "aid_post_complete" }],
			Materials = [{ Key = "bread", Name = "$bv{chapter.preparation.material.bread}", Source = "$bv{chapter.preparation.stock_source}", Count = 2, Item = "supplies.bread", Script = "scripts/items/supplies/bread_item" }, { Key = "medicine", Name = "$bv{chapter.preparation.material.medicine}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
		},
		{
			Name = "$bv{chapter.grey_falcon.stage2.name}",
			Brief = "$bv{chapter.grey_falcon.stage2.brief}",
			Scene = "stage2",
			Money = 1600,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{
					Key = "roadblock_complete",
					Node = "roadblock",
					Name = "$bv{chapter.grey_falcon.node.roadblock}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.grey_falcon.stage3.name}",
			Brief = "$bv{chapter.grey_falcon.stage3.brief}",
			Scene = "stage3",
			Money = 1200,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{ Key = "hearth_complete", Node = "hearth", Name = "$bv{chapter.preparation.grey_falcon.hearth_complete.name}", Action = "$bv{chapter.preparation.grey_falcon.hearth_complete.name}", Battle = false, Scene = "preparation_hearth_complete", LegacyGoal = "hearth_complete" }],
			Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 10 }]
		},
		{
			Name = "$bv{chapter.grey_falcon.stage4.name}",
			Brief = "$bv{chapter.grey_falcon.stage4.brief}",
			Scene = "stage4",
			Money = 2600,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{
					Key = "courier_station_complete",
					Node = "courier_station",
					Name = "$bv{chapter.grey_falcon.node.courier_station}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.grey_falcon.stage5.name}",
			Brief = "$bv{chapter.grey_falcon.stage5.brief}",
			Scene = "stage5",
			Money = 1800,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{ Key = "quarry_road_complete", Node = "quarry_road", Name = "$bv{chapter.preparation.grey_falcon.quarry_road_complete.name}", Action = "$bv{chapter.preparation.grey_falcon.quarry_road_complete.name}", Battle = false, Scene = "preparation_quarry_road_complete", LegacyGoal = "quarry_road_complete" }],
			Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 15 }]
		, RequiredEvidence = ["retreat_order"] },
		{
			Name = "$bv{chapter.grey_falcon.stage6.name}",
			Brief = "$bv{chapter.grey_falcon.stage6.brief}",
			Scene = "stage6",
			Money = 4000,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.grey_falcon.reward.story}",
			Goals = [{
					Key = "pursuit_complete",
					Node = "pursuit",
					Name = "$bv{chapter.grey_falcon.node.pursuit}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.grey_falcon.stage7.name}",
			Brief = "$bv{chapter.grey_falcon.stage7.brief}",
			Scene = "stage7",
			Money = 2000,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.grey_falcon.reward.growth}",
			Goals = [{ Key = "last_order_complete", Node = "last_order", Name = "$bv{chapter.preparation.grey_falcon.last_order_complete.name}", Action = "$bv{chapter.preparation.grey_falcon.last_order_complete.name}", Battle = false, Scene = "preparation_last_order_complete", LegacyGoal = "last_order_complete" }, { Key = "prep_7_2", Node = "last_order", Name = "$bv{chapter.preparation.grey_falcon.prep_7_2.name}", Action = "$bv{chapter.preparation.grey_falcon.prep_7_2.name}", Battle = false, Scene = "preparation_prep_7_2", LegacyGoal = "last_order_complete", Requires = ["last_order_complete"] }],
			Materials = []
		, RequiredEvidence = ["retreat_order"] },
		{
			Name = "$bv{chapter.grey_falcon.stage8.name}",
			Brief = "$bv{chapter.grey_falcon.stage8.brief}",
			Scene = "stage8",
			Money = 8000,
			Medicine = 10,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.grey_falcon.reward.ending}",
			Goals = [{
					Key = "mountain_exit_complete",
					Node = "mountain_exit",
					Name = "$bv{chapter.grey_falcon.node.mountain_exit}",
					Battle = true
				}],
			Materials = []
		}
	],
	Nodes = {
		aid_post = {
			Name = "$bv{chapter.grey_falcon.node.aid_post}",
			Brush = "world_ruins_01",
			Battle = false
		},
		roadblock = {
			Name = "$bv{chapter.grey_falcon.node.roadblock}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		hearth = {
			Name = "$bv{chapter.grey_falcon.node.hearth}",
			Brush = "world_ruins_01",
			Battle = false
		},
		courier_station = {
			Name = "$bv{chapter.grey_falcon.node.courier_station}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		quarry_road = {
			Name = "$bv{chapter.grey_falcon.node.quarry_road}",
			Brush = "world_ruins_01",
			Battle = false
		},
		pursuit = {
			Name = "$bv{chapter.grey_falcon.node.pursuit}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		last_order = {
			Name = "$bv{chapter.grey_falcon.node.last_order}",
			Brush = "world_ruins_01",
			Battle = false
		},
		mountain_exit = {
			Name = "$bv{chapter.grey_falcon.node.mountain_exit}",
			Brush = "world_bandit_camp_01",
			Battle = true
		}
	},
	SkillRewards = [{
			Actor = "enterprise",
			Stage = 7,
			Key = "grey_falcon_return_route"
		}, {
			Actor = "m4a1",
			Stage = 7,
			Key = "grey_falcon_cover_reload"
		}],
	SkinRewards = [{
			Actor = "enterprise",
			Stage = 8,
			Skin = "enterprise_snowline_homecoming_skin"
		}, {
			Actor = "m4a1",
			Stage = 8,
			Skin = "m4a1_armistice_day_skin"
		}],
	Gallery = [{
			ID = "hearth",
			Stage = 3,
			Title = "$bv{chapter.grey_falcon.cg.hearth.title}",
			Caption = "$bv{chapter.grey_falcon.cg.hearth.caption}",
			Image = "ui/chapters/grey_falcon_last_order/cg_hearth.jpg"
		}, {
			ID = "relief",
			Stage = 5,
			Title = "$bv{chapter.grey_falcon.cg.relief.title}",
			Caption = "$bv{chapter.grey_falcon.cg.relief.caption}",
			Image = "ui/chapters/grey_falcon_last_order/cg_relief.jpg"
		}, {
			ID = "homecoming",
			Stage = 8,
			Title = "$bv{chapter.grey_falcon.cg.homecoming.title}",
			Caption = "$bv{chapter.grey_falcon.cg.homecoming.caption}",
			Image = "ui/chapters/grey_falcon_last_order/cg_homecoming.jpg"
		}]
};

::$bvvar{namespace}.Skins.enterprise_snowline_homecoming_skin <- {
	ID = "enterprise_snowline_homecoming_skin",
	ValkyrieID = "enterprise",
	IsOriginal = false,
	UnlockChapter = "grey_falcon_last_order",
	Name = "$bv{skin.enterprise_snowline_homecoming_skin.name}",
	TabName = "$bv{skin.enterprise_snowline_homecoming_skin.tab_name}",
	Description = "$bv{skin.enterprise_snowline_homecoming_skin.description}",
	Brush = "bust_bv_enterprise_snowline_homecoming_skin",
	DeathBrush = "bust_bv_enterprise_snowline_homecoming_skin_dead",
	WorldLeaderBrush = "world_bv_enterprise_snowline_homecoming_leader",
	Portrait = "ui/valkyries/enterprise_snowline_homecoming_card.png",
	Preview = "ui/valkyries/enterprise_snowline_homecoming_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/enterprise_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/enterprise_snowline_homecoming_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/enterprise_snowline_homecoming_skin_poster.jpg",
		Video = "ui/valkyries/detail/enterprise_snowline_homecoming_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.enterprise)) ::$bvvar{namespace}.Valkyries.enterprise.SkinIDs <- ["enterprise_skin"];
if (::$bvvar{namespace}.Valkyries.enterprise.SkinIDs.find("enterprise_snowline_homecoming_skin") == null) ::$bvvar{namespace}.Valkyries.enterprise.SkinIDs.push("enterprise_snowline_homecoming_skin");

::$bvvar{namespace}.Skins.m4a1_armistice_day_skin <- {
	ID = "m4a1_armistice_day_skin",
	ValkyrieID = "m4a1",
	IsOriginal = false,
	UnlockChapter = "grey_falcon_last_order",
	Name = "$bv{skin.m4a1_armistice_day_skin.name}",
	TabName = "$bv{skin.m4a1_armistice_day_skin.tab_name}",
	Description = "$bv{skin.m4a1_armistice_day_skin.description}",
	Brush = "bust_bv_m4a1_armistice_day_skin",
	DeathBrush = "bust_bv_m4a1_armistice_day_skin_dead",
	WorldLeaderBrush = "world_bv_m4a1_armistice_day_leader",
	Portrait = "ui/valkyries/m4a1_armistice_day_card.png",
	Preview = "ui/valkyries/m4a1_armistice_day_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/m4a1_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/m4a1_armistice_day_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/m4a1_armistice_day_skin_poster.jpg",
		Video = "ui/valkyries/detail/m4a1_armistice_day_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.m4a1)) ::$bvvar{namespace}.Valkyries.m4a1.SkinIDs <- ["m4a1_skin"];
if (::$bvvar{namespace}.Valkyries.m4a1.SkinIDs.find("m4a1_armistice_day_skin") == null) ::$bvvar{namespace}.Valkyries.m4a1.SkinIDs.push("m4a1_armistice_day_skin");
