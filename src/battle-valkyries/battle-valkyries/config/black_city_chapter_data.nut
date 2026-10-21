// Independent conquest chapter. Story cast is not a player-roster prerequisite.
::$bvvar{namespace}.ChapterDefinitions.black_city_falls <- {
	ID = "black_city_falls",
	Name = "$bv{chapter.black_city.name}",
	Description = "$bv{chapter.black_city.description}",
	Ending = "$bv{chapter.black_city.ending}",
	Poster = "ui/chapters/black_city_falls/city.jpg",
	Actors = [],
	PortraitOrder = ["chloe", "olga"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/black_city_chapter_location",
	Videos = {},
	Portraits = {
		chloe = "ui/chapters/black_city_falls/chloe_standing.png",
		olga = "ui/chapters/black_city_falls/olga_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.black_city.opening.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.opening.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.opening.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.opening.line3}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.opening.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.opening.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.opening.line6}"
				}
			]
		},
		stage1 = {
			Title = "$bv{chapter.black_city.stage1.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage1.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage1.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage1.line3}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage1.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage1.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage1.line6}"
				}
			]
		},
		stage2 = {
			Title = "$bv{chapter.black_city.stage2.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage2.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage2.line2}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage2.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage2.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage2.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage2.line6}"
				}
			]
		},
		stage3 = {
			Title = "$bv{chapter.black_city.stage3.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = ["chloe"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage3.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage3.line2}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage3.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage3.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage3.line5}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage3.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage3.line7}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage3.line8}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage3.line9}"
				}
			]
		},
		stage4 = {
			Title = "$bv{chapter.black_city.stage4.name}",
			Background = "ui/chapters/black_city_falls/cg_chloe.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage4.line1}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage4.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage4.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage4.line4}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage4.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage4.line6}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage4.line7}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage4.line8}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage4.line9}",
					Name = ""
				}
			]
		},
		stage5 = {
			Title = "$bv{chapter.black_city.stage5.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = ["chloe"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage5.line1}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage5.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage5.line3}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage5.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage5.line5}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage5.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage5.line7}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage5.line8}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage5.line9}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage5.line10}",
					Name = ""
				}
			]
		},
		stage6 = {
			Title = "$bv{chapter.black_city.stage6.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = ["chloe"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage6.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage6.line2}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage6.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage6.line4}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage6.line5}"
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage6.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage6.line7}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage6.line8}"
				}
			]
		},
		stage7 = {
			Title = "$bv{chapter.black_city.stage7.name}",
			Background = "ui/chapters/black_city_falls/city.jpg",
			Video = "",
			PortraitOrder = ["chloe", "olga"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage7.line1}"
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage7.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage7.line3}",
					Name = ""
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage7.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage7.line5}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage7.line6}"
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage7.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage7.line8}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage7.line9}",
					Name = ""
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage7.line10}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage7.line11}"
				}
			]
		},
		stage8 = {
			Title = "$bv{chapter.black_city.stage8.name}",
			Background = "ui/chapters/black_city_falls/cg_olga.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage8.line1}"
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage8.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage8.line3}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage8.line4}"
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage8.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage8.line6}",
					Name = ""
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.stage8.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage8.line8}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.stage8.line9}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.stage8.line10}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.stage8.line11}"
				}
			]
		},
		epilogue = {
			Title = "$bv{chapter.black_city.epilogue.name}",
			Background = "ui/chapters/black_city_falls/cg_together.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.epilogue.line1}"
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.epilogue.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.epilogue.line3}",
					Name = ""
				},
				{
					Speaker = "chloe",
					Text = "$bv{chapter.black_city.epilogue.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.epilogue.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.epilogue.line6}",
					Name = ""
				},
				{
					Speaker = "olga",
					Text = "$bv{chapter.black_city.epilogue.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.black_city.epilogue.line8}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.black_city.epilogue.line9}"
				}
			]
		}
	},
	Nodes = {
		waystation = {
			Name = "$bv{chapter.black_city.node.waystation}",
			Brush = "world_ruins_01",
			Battle = false
		},
		depot = {
			Name = "$bv{chapter.black_city.node.depot}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		culvert = {
			Name = "$bv{chapter.black_city.node.culvert}",
			Brush = "world_ruins_01",
			Battle = false
		},
		black_bridge = {
			Name = "$bv{chapter.black_city.node.black_bridge}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		armory = {
			Name = "$bv{chapter.black_city.node.armory}",
			Brush = "world_ruins_01",
			Battle = false
		},
		ward_tower = {
			Name = "$bv{chapter.black_city.node.ward_tower}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		court_gate = {
			Name = "$bv{chapter.black_city.node.court_gate}",
			Brush = "world_ruins_01",
			Battle = false
		},
		throne = {
			Name = "$bv{chapter.black_city.node.throne}",
			Brush = "world_bandit_camp_01",
			Battle = true
		}
	},
	Stages = [
		{
			Name = "$bv{chapter.black_city.stage1.name}",
			Brief = "$bv{chapter.black_city.stage1.brief}",
			Scene = "stage1",
			Goals = [
				{
					Key = "tracks",
					Name = "$bv{chapter.black_city.goal.tracks}",
					Node = "waystation",
					Battle = false
				},
				{
					Key = "roster",
					Name = "$bv{chapter.black_city.goal.roster}",
					Node = "waystation",
					Battle = false,
					Requires = ["tracks"]
				}
			],
			Materials = [],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage2.name}",
			Brief = "$bv{chapter.black_city.stage2.brief}",
			Scene = "stage2",
			Goals = [
				{
					Key = "convoy_won",
					Name = "$bv{chapter.black_city.goal.convoy_won}",
					Node = "depot",
					Battle = true
				}
			],
			Materials = [],
			Money = 1500,
			Medicine = 10,
			Tools = 20,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage3.name}",
			Brief = "$bv{chapter.black_city.stage3.brief}",
			Scene = "stage3",
			Goals = [
				{
					Key = "culvert",
					Name = "$bv{chapter.black_city.goal.culvert}",
					Node = "culvert",
					Battle = false
				},
				{
					Key = "winch",
					Name = "$bv{chapter.black_city.goal.winch}",
					Node = "culvert",
					Battle = false,
					Requires = ["culvert"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 10,
					Source = "$bv{chapter.black_city.tools_source}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage4.name}",
			Brief = "$bv{chapter.black_city.stage4.brief}",
			Scene = "stage4",
			Goals = [
				{
					Key = "chloe_won",
					Name = "$bv{chapter.black_city.goal.chloe_won}",
					Node = "black_bridge",
					Battle = true
				}
			],
			Materials = [],
			Money = 3000,
			Medicine = 10,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage5.name}",
			Brief = "$bv{chapter.black_city.stage5.brief}",
			Scene = "stage5",
			Goals = [
				{
					Key = "keys",
					Name = "$bv{chapter.black_city.goal.keys}",
					Node = "armory",
					Battle = false
				},
				{
					Key = "ward_route",
					Name = "$bv{chapter.black_city.goal.ward_route}",
					Node = "armory",
					Battle = false,
					Requires = ["keys"]
				}
			],
			Materials = [],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage6.name}",
			Brief = "$bv{chapter.black_city.stage6.brief}",
			Scene = "stage6",
			Goals = [
				{
					Key = "lamps_won",
					Name = "$bv{chapter.black_city.goal.lamps_won}",
					Node = "ward_tower",
					Battle = true
				}
			],
			Materials = [],
			Money = 4500,
			Medicine = 0,
			Tools = 10,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage7.name}",
			Brief = "$bv{chapter.black_city.stage7.brief}",
			Scene = "stage7",
			Goals = [
				{
					Key = "withdrawal",
					Name = "$bv{chapter.black_city.goal.withdrawal}",
					Node = "court_gate",
					Battle = false
				},
				{
					Key = "terms",
					Name = "$bv{chapter.black_city.goal.terms}",
					Node = "court_gate",
					Battle = false,
					Requires = ["withdrawal"]
				}
			],
			Materials = [
				{
					Key = "medicine",
					Name = "$bv{chapter.material.medicine}",
					Count = 10,
					Source = "$bv{chapter.black_city.medicine_source}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.black_city.stage8.name}",
			Brief = "$bv{chapter.black_city.stage8.brief}",
			Scene = "stage8",
			Goals = [
				{
					Key = "queen_won",
					Name = "$bv{chapter.black_city.goal.queen_won}",
					Node = "throne",
					Battle = true
				}
			],
			Materials = [],
			Money = 7000,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.black_city.recruit_reward}"
		}
	],
	Gallery = [
		{
			ID = "chloe",
			Stage = 4,
			Title = "$bv{chapter.black_city.cg.chloe.title}",
			Caption = "$bv{chapter.black_city.cg.chloe.caption}",
			Image = "ui/chapters/black_city_falls/cg_chloe.jpg"
		},
		{
			ID = "olga",
			Stage = 8,
			Title = "$bv{chapter.black_city.cg.olga.title}",
			Caption = "$bv{chapter.black_city.cg.olga.caption}",
			Image = "ui/chapters/black_city_falls/cg_olga.jpg"
		},
		{
			ID = "together",
			Stage = 8,
			Title = "$bv{chapter.black_city.cg.together.title}",
			Caption = "$bv{chapter.black_city.cg.together.caption}",
			Image = "ui/chapters/black_city_falls/cg_together.jpg"
		}
	]
};
::$bvvar{namespace}.Valkyries.chloe.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.olga.ChapterRecruitOnly <- true;
