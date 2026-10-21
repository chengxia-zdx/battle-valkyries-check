// Stable chapter ID; all saves use the shared chapter transaction service.
::$bvvar{namespace}.ChapterDefinitions.painted_harbor <- {
	ID = "painted_harbor",
	Ending = "$bv{chapter.painted_harbor.ending}",
	Name = "$bv{chapter.painted_harbor.name}",
	Description = "$bv{chapter.painted_harbor.description}",
	Poster = "ui/chapters/painted_harbor/cover.jpg",
	Actors = ["abigail_williams", "katsushika_hokusai"],
	PortraitOrder = ["abigail_williams", "katsushika_hokusai"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/painted_harbor_chapter_location",
	Videos = {

	},
	Portraits = {
		abigail_williams = "ui/chapters/painted_harbor/abigail_standing.png",
		katsushika_hokusai = "ui/chapters/painted_harbor/hokusai_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.painted_harbor.opening.name}",
			Background = "ui/chapters/painted_harbor/old_ferry.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.opening.line1}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.opening.line2}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.opening.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.opening.line4}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.opening.line5}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.opening.line6}"
				}]
		},
		stage1 = {
			Title = "$bv{chapter.painted_harbor.stage1.name}",
			Background = "ui/chapters/painted_harbor/painted_street.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage1.line1}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage1.line2}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage1.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage1.line4}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage1.line5}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage1.line6}"
				}]
		},
		stage2 = {
			Title = "$bv{chapter.painted_harbor.stage2.name}",
			Background = "ui/chapters/painted_harbor/warehouse.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage2.line1}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage2.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage2.line3}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage2.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage2.line5}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage2.line6}"
				}]
		},
		stage3 = {
			Title = "$bv{chapter.painted_harbor.stage3.name}",
			Background = "ui/chapters/painted_harbor/old_home.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage3.line1}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage3.line2}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage3.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage3.line4}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage3.line5}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage3.line6}"
				}]
		},
		stage4 = {
			Title = "$bv{chapter.painted_harbor.stage4.name}",
			Background = "ui/chapters/painted_harbor/clocktower.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage4.line1}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage4.line2}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage4.line3}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage4.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage4.line5}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage4.line6}"
				}]
		},
		stage5 = {
			Title = "$bv{chapter.painted_harbor.stage5.name}",
			Background = "ui/chapters/painted_harbor/old_ferry.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage5.line1}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage5.line2}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage5.line3}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage5.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage5.line5}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage5.line6}"
				}]
		},
		stage6 = {
			Title = "$bv{chapter.painted_harbor.stage6.name}",
			Background = "ui/chapters/painted_harbor/portrait_gallery.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage6.line1}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage6.line2}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage6.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage6.line4}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage6.line5}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage6.line6}"
				}]
		},
		stage7 = {
			Title = "$bv{chapter.painted_harbor.stage7.name}",
			Background = "ui/chapters/painted_harbor/master_scroll_hall.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage7.line1}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage7.line2}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage7.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage7.line4}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage7.line5}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage7.line6}"
				}]
		},
		stage8 = {
			Title = "$bv{chapter.painted_harbor.stage8.name}",
			Background = "ui/chapters/painted_harbor/camp.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage8.line1}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage8.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage8.line3}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage8.line4}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage8.line5}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.painted_harbor.stage8.line6}"
				}, {
					Speaker = "abigail_williams",
					Text = "$bv{chapter.painted_harbor.stage8.line7}"
				}, {
					Speaker = "katsushika_hokusai",
					Text = "$bv{chapter.painted_harbor.stage8.line8}"
				}]
		},
		preparation_ferry_complete = { Title = "$bv{chapter.preparation.painted_harbor.ferry_complete.name}", Video = "", Background = "ui/chapters/painted_harbor/painted_street.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.ferry_complete.text}" }] },
		preparation_home_complete = { Title = "$bv{chapter.preparation.painted_harbor.home_complete.name}", Video = "", Background = "ui/chapters/painted_harbor/old_home.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.home_complete.text}" }] },
		preparation_prep_3_2 = { Title = "$bv{chapter.preparation.painted_harbor.prep_3_2.name}", Video = "", Background = "ui/chapters/painted_harbor/old_home.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.prep_3_2.text}" }] },
		preparation_ruins_complete = { Title = "$bv{chapter.preparation.painted_harbor.ruins_complete.name}", Video = "", Background = "ui/chapters/painted_harbor/old_ferry.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.ruins_complete.text}" }] },
		preparation_prep_5_2 = { Title = "$bv{chapter.preparation.painted_harbor.prep_5_2.name}", Video = "", Background = "ui/chapters/painted_harbor/old_ferry.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.prep_5_2.text}" }] },
		preparation_threshold_complete = { Title = "$bv{chapter.preparation.painted_harbor.threshold_complete.name}", Video = "", Background = "ui/chapters/painted_harbor/master_scroll_hall.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.threshold_complete.text}" }] },
		preparation_prep_7_2 = { Title = "$bv{chapter.preparation.painted_harbor.prep_7_2.name}", Video = "", Background = "ui/chapters/painted_harbor/master_scroll_hall.jpg", PortraitOrder = [], Lines = [{ Speaker = "narrator", Text = "$bv{chapter.preparation.painted_harbor.prep_7_2.text}" }] }
	},
	PreparationVersion = 1,
	Evidence = [{ Key = "paint_solvent", Name = "$bv{chapter.preparation.painted_harbor.evidence.paint_solvent}", Stage = 2, Source = "$bv{chapter.preparation.painted_harbor.evidence.paint_solvent.source}" }, { Key = "exit_coordinates", Name = "$bv{chapter.preparation.painted_harbor.evidence.exit_coordinates}", Stage = 5, Source = "$bv{chapter.preparation.painted_harbor.evidence.exit_coordinates.source}", Goal = "prep_5_2" }, { Key = "rescued_portraits", Name = "$bv{chapter.preparation.painted_harbor.evidence.rescued_portraits}", Stage = 6, Source = "$bv{chapter.preparation.painted_harbor.evidence.rescued_portraits.source}" }],
	Stages = [
		{
			Name = "$bv{chapter.painted_harbor.stage1.name}",
			Brief = "$bv{chapter.painted_harbor.stage1.brief}",
			Scene = "stage1",
			Money = 800,
			Medicine = 0,
			Tools = 0,
			Special = "$bv{chapter.painted_harbor.reward.cg}",
			Goals = [{ Key = "ferry_complete", Node = "ferry", Name = "$bv{chapter.preparation.painted_harbor.ferry_complete.name}", Action = "$bv{chapter.preparation.painted_harbor.ferry_complete.name}", Battle = false, Scene = "preparation_ferry_complete", LegacyGoal = "ferry_complete" }],
			Materials = [{ Key = "cloth", Name = "$bv{chapter.preparation.material.cloth}", Source = "$bv{chapter.preparation.stock_source}", Count = 1, Item = "misc.cloth_rolls", Script = "scripts/items/trade/cloth_rolls_item" }]
		},
		{
			Name = "$bv{chapter.painted_harbor.stage2.name}",
			Brief = "$bv{chapter.painted_harbor.stage2.brief}",
			Scene = "stage2",
			Money = 1600,
			Medicine = 0,
			Tools = 0,
			Special = "",
			Goals = [{
					Key = "warehouse_complete",
					Node = "warehouse",
					Name = "$bv{chapter.painted_harbor.node.warehouse}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.painted_harbor.stage3.name}",
			Brief = "$bv{chapter.painted_harbor.stage3.brief}",
			Scene = "stage3",
			Money = 2200,
			Medicine = 0,
			Tools = 0,
			Special = "",
			Goals = [{ Key = "home_complete", Node = "home", Name = "$bv{chapter.preparation.painted_harbor.home_complete.name}", Action = "$bv{chapter.preparation.painted_harbor.home_complete.name}", Battle = false, Scene = "preparation_home_complete", LegacyGoal = "home_complete" }, { Key = "prep_3_2", Node = "home", Name = "$bv{chapter.preparation.painted_harbor.prep_3_2.name}", Action = "$bv{chapter.preparation.painted_harbor.prep_3_2.name}", Battle = false, Scene = "preparation_prep_3_2", LegacyGoal = "home_complete", Requires = ["home_complete"] }],
			Materials = []
		, RequiredEvidence = ["paint_solvent"] },
		{
			Name = "$bv{chapter.painted_harbor.stage4.name}",
			Brief = "$bv{chapter.painted_harbor.stage4.brief}",
			Scene = "stage4",
			Money = 3200,
			Medicine = 0,
			Tools = 0,
			Special = "",
			Goals = [{
					Key = "clocktower_complete",
					Node = "clocktower",
					Name = "$bv{chapter.painted_harbor.node.clocktower}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.painted_harbor.stage5.name}",
			Brief = "$bv{chapter.painted_harbor.stage5.brief}",
			Scene = "stage5",
			Money = 4200,
			Medicine = 0,
			Tools = 0,
			Special = "$bv{chapter.painted_harbor.reward.stroke}\n$bv{chapter.painted_harbor.reward.cg}",
			Goals = [{ Key = "ruins_complete", Node = "ruins", Name = "$bv{chapter.preparation.painted_harbor.ruins_complete.name}", Action = "$bv{chapter.preparation.painted_harbor.ruins_complete.name}", Battle = false, Scene = "preparation_ruins_complete", LegacyGoal = "ruins_complete" }, { Key = "prep_5_2", Node = "ruins", Name = "$bv{chapter.preparation.painted_harbor.prep_5_2.name}", Action = "$bv{chapter.preparation.painted_harbor.prep_5_2.name}", Battle = false, Scene = "preparation_prep_5_2", LegacyGoal = "ruins_complete", Requires = ["ruins_complete"] }],
			Materials = [{ Key = "tools", Name = "$bv{chapter.preparation.material.tools}", Source = "$bv{chapter.preparation.stock_source}", Count = 5 }]
		, RequiredEvidence = ["exit_coordinates"] },
		{
			Name = "$bv{chapter.painted_harbor.stage6.name}",
			Brief = "$bv{chapter.painted_harbor.stage6.brief}",
			Scene = "stage6",
			Money = 5500,
			Medicine = 0,
			Tools = 0,
			Special = "",
			Goals = [{
					Key = "gallery_complete",
					Node = "gallery",
					Name = "$bv{chapter.painted_harbor.node.gallery}",
					Battle = true
				}],
			Materials = []
		},
		{
			Name = "$bv{chapter.painted_harbor.stage7.name}",
			Brief = "$bv{chapter.painted_harbor.stage7.brief}",
			Scene = "stage7",
			Money = 6500,
			Medicine = 0,
			Tools = 0,
			Special = "$bv{chapter.painted_harbor.reward.prayer}\n$bv{chapter.painted_harbor.reward.cg}",
			Goals = [{ Key = "threshold_complete", Node = "threshold", Name = "$bv{chapter.preparation.painted_harbor.threshold_complete.name}", Action = "$bv{chapter.preparation.painted_harbor.threshold_complete.name}", Battle = false, Scene = "preparation_threshold_complete", LegacyGoal = "threshold_complete" }, { Key = "prep_7_2", Node = "threshold", Name = "$bv{chapter.preparation.painted_harbor.prep_7_2.name}", Action = "$bv{chapter.preparation.painted_harbor.prep_7_2.name}", Battle = false, Scene = "preparation_prep_7_2", LegacyGoal = "threshold_complete", Requires = ["threshold_complete"] }],
			Materials = []
		, RequiredEvidence = ["exit_coordinates", "rescued_portraits"] },
		{
			Name = "$bv{chapter.painted_harbor.stage8.name}",
			Brief = "$bv{chapter.painted_harbor.stage8.brief}",
			Scene = "stage8",
			Money = 10000,
			Medicine = 0,
			Tools = 0,
			Special = "$bv{chapter.painted_harbor.reward.cg}",
			Goals = [{
					Key = "curator_complete",
					Node = "curator",
					Name = "$bv{chapter.painted_harbor.node.curator}",
					Battle = true
				}],
			Materials = []
		}
	],
	Nodes = {
		ferry = {
			Name = "$bv{chapter.painted_harbor.node.ferry}",
			Brush = "world_bv_painted_harbor",
			Battle = false
		},
		warehouse = {
			Name = "$bv{chapter.painted_harbor.node.warehouse}",
			Brush = "world_bv_painted_harbor",
			Battle = true
		},
		home = {
			Name = "$bv{chapter.painted_harbor.node.home}",
			Brush = "world_bv_painted_harbor",
			Battle = false
		},
		clocktower = {
			Name = "$bv{chapter.painted_harbor.node.clocktower}",
			Brush = "world_bv_painted_harbor",
			Battle = true
		},
		ruins = {
			Name = "$bv{chapter.painted_harbor.node.ruins}",
			Brush = "world_bv_painted_harbor",
			Battle = false
		},
		gallery = {
			Name = "$bv{chapter.painted_harbor.node.gallery}",
			Brush = "world_bv_painted_harbor",
			Battle = true
		},
		threshold = {
			Name = "$bv{chapter.painted_harbor.node.threshold}",
			Brush = "world_bv_painted_harbor",
			Battle = false
		},
		curator = {
			Name = "$bv{chapter.painted_harbor.node.curator}",
			Brush = "world_bv_painted_harbor",
			Battle = true
		}
	},
	SkillRewards = [{
			Actor = "katsushika_hokusai",
			Stage = 5,
			Key = "painted_harbor_human_stroke"
		}, {
			Actor = "abigail_williams",
			Stage = 7,
			Key = "painted_harbor_homeward_prayer"
		}]
};
foreach (key in ["stage6", "stage7"])
	::$bvvar{namespace}.ChapterDefinitions.painted_harbor.Scenes[key].Portraits <- {
		abigail_williams = "ui/chapters/painted_harbor/abigail_resolute.png",
		katsushika_hokusai = "ui/chapters/painted_harbor/hokusai_serious.png"
	};
