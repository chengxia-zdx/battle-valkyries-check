// Two linked conquest chapters. Enemy story cast never requires owned player identities.
::$bvvar{namespace}.ChapterDefinitions.seven_shields_upper <- {
	ID = "seven_shields_upper",
	Name = "$bv{chapter.seven_shields.upper.name}",
	Description = "$bv{chapter.seven_shields.upper.description}",
	Ending = "$bv{chapter.seven_shields.upper.ending}",
	Poster = "ui/chapters/seven_shields/upper.jpg",
	Actors = [],
	PortraitOrder = ["alicia", "prim", "kaguya"],
	RequiredChapter = "black_city_falls",
	RecruitActors = ["alicia", "prim", "kaguya"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/seven_shields_chapter_location",
	Videos = {},
	Portraits = {
		alicia = "ui/chapters/seven_shields/alicia_standing.png",
		prim = "ui/chapters/seven_shields/prim_standing.png",
		kaguya = "ui/chapters/seven_shields/kaguya_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.seven_shields.upper.opening.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.opening.line1}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.opening.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.opening.line3}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.opening.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.opening.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.opening.line6}"
				}
			]
		},
		stage1 = {
			Title = "$bv{chapter.seven_shields.upper.stage1.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage1.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage1.line2}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage1.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage1.line4}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage1.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage1.line6}",
					Name = ""
				}
			]
		},
		stage2 = {
			Title = "$bv{chapter.seven_shields.upper.stage2.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage2.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage2.line2}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage2.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage2.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage2.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage2.line6}"
				}
			]
		},
		stage3 = {
			Title = "$bv{chapter.seven_shields.upper.stage3.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = ["alicia"],
			Lines = [
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage3.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage3.line2}",
					Name = ""
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage3.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage3.line4}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage3.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage3.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage3.line7}",
					Name = ""
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage3.line8}"
				}
			]
		},
		stage4 = {
			Title = "$bv{chapter.seven_shields.upper.stage4.name}",
			Background = "ui/chapters/seven_shields/cg_alicia.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage4.line1}"
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage4.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage4.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage4.line4}",
					Name = ""
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage4.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage4.line6}",
					Name = ""
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.stage4.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage4.line8}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage4.line9}"
				}
			]
		},
		stage5 = {
			Title = "$bv{chapter.seven_shields.upper.stage5.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = ["prim"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage5.line1}"
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage5.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage5.line3}",
					Name = ""
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage5.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage5.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage5.line6}",
					Name = ""
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage5.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage5.line8}",
					Name = ""
				}
			]
		},
		stage6 = {
			Title = "$bv{chapter.seven_shields.upper.stage6.name}",
			Background = "ui/chapters/seven_shields/cg_prim.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage6.line1}"
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage6.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage6.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage6.line4}",
					Name = ""
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage6.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage6.line6}",
					Name = ""
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.stage6.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage6.line8}"
				}
			]
		},
		stage7 = {
			Title = "$bv{chapter.seven_shields.upper.stage7.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = ["kaguya"],
			Lines = [
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage7.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage7.line2}",
					Name = ""
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage7.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage7.line4}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage7.line5}"
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage7.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage7.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage7.line8}",
					Name = ""
				}
			]
		},
		stage8 = {
			Title = "$bv{chapter.seven_shields.upper.stage8.name}",
			Background = "ui/chapters/seven_shields/cg_kaguya.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage8.line1}"
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage8.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage8.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage8.line4}",
					Name = ""
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage8.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage8.line6}",
					Name = ""
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage8.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.stage8.line8}"
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage8.line9}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.stage8.line10}",
					Name = ""
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.stage8.line11}"
				}
			]
		},
		epilogue = {
			Title = "$bv{chapter.seven_shields.upper.epilogue.name}",
			Background = "ui/chapters/seven_shields/upper.jpg",
			Video = "",
			PortraitOrder = ["alicia", "prim", "kaguya"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line1}"
				},
				{
					Speaker = "alicia",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line3}",
					Name = ""
				},
				{
					Speaker = "prim",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line4}"
				},
				{
					Speaker = "kaguya",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.upper.epilogue.line7}",
					Name = ""
				}
			]
		}
	},
	Nodes = {
		tax_station = {
			Name = "$bv{chapter.seven_shields.upper.node.tax_station}",
			Brush = "world_ruins_01",
			Battle = false
		},
		convoy = {
			Name = "$bv{chapter.seven_shields.upper.node.convoy}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		first_approach = {
			Name = "$bv{chapter.seven_shields.upper.node.first_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_one = {
			Name = "$bv{chapter.seven_shields.upper.node.fortress_one}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		second_approach = {
			Name = "$bv{chapter.seven_shields.upper.node.second_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_two = {
			Name = "$bv{chapter.seven_shields.upper.node.fortress_two}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		third_approach = {
			Name = "$bv{chapter.seven_shields.upper.node.third_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_three = {
			Name = "$bv{chapter.seven_shields.upper.node.fortress_three}",
			Brush = "world_bandit_camp_01",
			Battle = true
		}
	},
	Stages = [
		{
			Name = "$bv{chapter.seven_shields.upper.stage1.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage1.brief}",
			Scene = "stage1",
			Goals = [
				{
					Key = "tax_station_notice",
					Name = "$bv{chapter.seven_shields.upper.stage1.goal1}",
					Action = "$bv{chapter.seven_shields.upper.stage1.action1}",
					Node = "tax_station",
					Battle = false
				},
				{
					Key = "tax_station_account",
					Name = "$bv{chapter.seven_shields.upper.stage1.goal2}",
					Action = "$bv{chapter.seven_shields.upper.stage1.action2}",
					Node = "tax_station",
					Battle = false,
					Requires = ["tax_station_notice"]
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
			Name = "$bv{chapter.seven_shields.upper.stage2.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage2.brief}",
			Scene = "stage2",
			Goals = [
				{
					Key = "convoy_won",
					Name = "$bv{chapter.seven_shields.upper.stage2.goal}",
					Node = "convoy",
					Battle = true
				}
			],
			Materials = [],
			Money = 1800,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["tax_station_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage3.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage3.brief}",
			Scene = "stage3",
			Goals = [
				{
					Key = "first_approach_spillway",
					Name = "$bv{chapter.seven_shields.upper.stage3.goal1}",
					Action = "$bv{chapter.seven_shields.upper.stage3.action1}",
					Node = "first_approach",
					Battle = false
				},
				{
					Key = "first_approach_winch",
					Name = "$bv{chapter.seven_shields.upper.stage3.goal2}",
					Action = "$bv{chapter.seven_shields.upper.stage3.action2}",
					Node = "first_approach",
					Battle = false,
					Requires = ["first_approach_spillway"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 10,
					Source = "$bv{chapter.seven_shields.material.tools}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage4.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage4.brief}",
			Scene = "stage4",
			Goals = [
				{
					Key = "fortress_one_won",
					Name = "$bv{chapter.seven_shields.upper.stage4.goal}",
					Node = "fortress_one",
					Battle = true
				}
			],
			Materials = [],
			Money = 3000,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["first_approach_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage5.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage5.brief}",
			Scene = "stage5",
			Goals = [
				{
					Key = "second_approach_receipt",
					Name = "$bv{chapter.seven_shields.upper.stage5.goal1}",
					Action = "$bv{chapter.seven_shields.upper.stage5.action1}",
					Node = "second_approach",
					Battle = false
				},
				{
					Key = "second_approach_evacuate",
					Name = "$bv{chapter.seven_shields.upper.stage5.goal2}",
					Action = "$bv{chapter.seven_shields.upper.stage5.action2}",
					Node = "second_approach",
					Battle = false,
					Requires = ["second_approach_receipt"]
				}
			],
			Materials = [
				{
					Key = "medicine",
					Name = "$bv{chapter.material.medicine}",
					Count = 10,
					Source = "$bv{chapter.seven_shields.material.medicine}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage6.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage6.brief}",
			Scene = "stage6",
			Goals = [
				{
					Key = "fortress_two_won",
					Name = "$bv{chapter.seven_shields.upper.stage6.goal}",
					Node = "fortress_two",
					Battle = true
				}
			],
			Materials = [],
			Money = 3500,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["second_approach_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage7.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage7.brief}",
			Scene = "stage7",
			Goals = [
				{
					Key = "third_approach_conduits",
					Name = "$bv{chapter.seven_shields.upper.stage7.goal1}",
					Action = "$bv{chapter.seven_shields.upper.stage7.action1}",
					Node = "third_approach",
					Battle = false
				},
				{
					Key = "third_approach_ground",
					Name = "$bv{chapter.seven_shields.upper.stage7.goal2}",
					Action = "$bv{chapter.seven_shields.upper.stage7.action2}",
					Node = "third_approach",
					Battle = false,
					Requires = ["third_approach_conduits"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 10,
					Source = "$bv{chapter.seven_shields.material.tools}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.upper.stage8.name}",
			Brief = "$bv{chapter.seven_shields.upper.stage8.brief}",
			Scene = "stage8",
			Goals = [
				{
					Key = "fortress_three_won",
					Name = "$bv{chapter.seven_shields.upper.stage8.goal}",
					Node = "fortress_three",
					Battle = true
				}
			],
			Materials = [],
			Money = 4500,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "$bv{chapter.seven_shields.upper.stage8.special}",
			RequiredEvidence = ["third_approach_record"]
		}
	],
	Gallery = [
		{
			ID = "alicia_defeat",
			Stage = 4,
			Title = "$bv{chapter.seven_shields.cg.alicia.name}",
			Caption = "$bv{chapter.seven_shields.cg.alicia.caption}",
			Image = "ui/chapters/seven_shields/cg_alicia.jpg",
			Video = ""
		},
		{
			ID = "prim_defeat",
			Stage = 6,
			Title = "$bv{chapter.seven_shields.cg.prim.name}",
			Caption = "$bv{chapter.seven_shields.cg.prim.caption}",
			Image = "ui/chapters/seven_shields/cg_prim.jpg",
			Video = ""
		},
		{
			ID = "kaguya_defeat",
			Stage = 8,
			Title = "$bv{chapter.seven_shields.cg.kaguya.name}",
			Caption = "$bv{chapter.seven_shields.cg.kaguya.caption}",
			Image = "ui/chapters/seven_shields/cg_kaguya.jpg",
			Video = ""
		}
	],
	Evidence = [
		{
			Key = "tax_station_record",
			Name = "$bv{chapter.seven_shields.upper.stage1.evidence}",
			Source = "$bv{chapter.seven_shields.upper.stage1.brief}",
			Stage = 1,
			Goal = "tax_station_account"
		},
		{
			Key = "first_approach_record",
			Name = "$bv{chapter.seven_shields.upper.stage3.evidence}",
			Source = "$bv{chapter.seven_shields.upper.stage3.brief}",
			Stage = 3,
			Goal = "first_approach_winch"
		},
		{
			Key = "second_approach_record",
			Name = "$bv{chapter.seven_shields.upper.stage5.evidence}",
			Source = "$bv{chapter.seven_shields.upper.stage5.brief}",
			Stage = 5,
			Goal = "second_approach_evacuate"
		},
		{
			Key = "third_approach_record",
			Name = "$bv{chapter.seven_shields.upper.stage7.evidence}",
			Source = "$bv{chapter.seven_shields.upper.stage7.brief}",
			Stage = 7,
			Goal = "third_approach_ground"
		}
	]
};
::$bvvar{namespace}.Valkyries.alicia.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.alicia.ChapterRecruitHint <- "$bv{chapter.seven_shields.upper.recruit_only}";
::$bvvar{namespace}.Valkyries.prim.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.prim.ChapterRecruitHint <- "$bv{chapter.seven_shields.upper.recruit_only}";
::$bvvar{namespace}.Valkyries.kaguya.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.kaguya.ChapterRecruitHint <- "$bv{chapter.seven_shields.upper.recruit_only}";
::$bvvar{namespace}.ChapterDefinitions.seven_shields_lower <- {
	ID = "seven_shields_lower",
	Name = "$bv{chapter.seven_shields.lower.name}",
	Description = "$bv{chapter.seven_shields.lower.description}",
	Ending = "$bv{chapter.seven_shields.lower.ending}",
	Poster = "ui/chapters/seven_shields/lower.jpg",
	Actors = [],
	PortraitOrder = ["maia", "luu_luu", "claudia", "celestine"],
	RequiredChapter = "seven_shields_upper",
	RecruitActors = ["maia", "luu_luu", "claudia", "celestine"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/seven_shields_chapter_location",
	Videos = {},
	Portraits = {
		maia = "ui/chapters/seven_shields/maia_standing.png",
		luu_luu = "ui/chapters/seven_shields/luu_luu_standing.png",
		claudia = "ui/chapters/seven_shields/claudia_standing.png",
		celestine = "ui/chapters/seven_shields/celestine_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.seven_shields.lower.opening.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["maia"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.opening.line1}"
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.opening.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.opening.line3}",
					Name = ""
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.opening.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.opening.line5}",
					Name = ""
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.opening.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.opening.line7}"
				}
			]
		},
		stage1 = {
			Title = "$bv{chapter.seven_shields.lower.stage1.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["maia"],
			Lines = [
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.stage1.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage1.line2}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage1.line3}"
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.stage1.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage1.line5}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage1.line6}"
				}
			]
		},
		stage2 = {
			Title = "$bv{chapter.seven_shields.lower.stage2.name}",
			Background = "ui/chapters/seven_shields/cg_maia.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage2.line1}"
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.stage2.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage2.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage2.line4}",
					Name = ""
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.stage2.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage2.line6}",
					Name = ""
				},
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.stage2.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage2.line8}"
				}
			]
		},
		stage3 = {
			Title = "$bv{chapter.seven_shields.lower.stage3.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["luu_luu"],
			Lines = [
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage3.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage3.line2}",
					Name = ""
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage3.line3}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage3.line4}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage3.line5}",
					Name = ""
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage3.line6}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage3.line7}"
				}
			]
		},
		stage4 = {
			Title = "$bv{chapter.seven_shields.lower.stage4.name}",
			Background = "ui/chapters/seven_shields/cg_luu_luu.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage4.line1}"
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage4.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage4.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage4.line4}",
					Name = ""
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage4.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage4.line6}",
					Name = ""
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.stage4.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage4.line8}"
				}
			]
		},
		stage5 = {
			Title = "$bv{chapter.seven_shields.lower.stage5.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["claudia"],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage5.line1}"
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage5.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage5.line3}",
					Name = ""
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage5.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage5.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage5.line6}",
					Name = ""
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage5.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage5.line8}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage5.line9}"
				}
			]
		},
		stage6 = {
			Title = "$bv{chapter.seven_shields.lower.stage6.name}",
			Background = "ui/chapters/seven_shields/cg_claudia.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage6.line1}"
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage6.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage6.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage6.line4}",
					Name = ""
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage6.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage6.line6}",
					Name = ""
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage6.line7}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage6.line8}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage6.line9}"
				}
			]
		},
		stage7 = {
			Title = "$bv{chapter.seven_shields.lower.stage7.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["celestine", "claudia"],
			Lines = [
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage7.line1}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage7.line2}",
					Name = ""
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage7.line3}"
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage7.line4}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage7.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage7.line6}",
					Name = ""
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage7.line7}"
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage7.line8}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage7.line9}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage7.line10}",
					Name = ""
				}
			]
		},
		stage8 = {
			Title = "$bv{chapter.seven_shields.lower.stage8.name}",
			Background = "ui/chapters/seven_shields/cg_celestine.jpg",
			Video = "",
			PortraitOrder = [],
			Lines = [
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage8.line1}"
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage8.line2}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage8.line3}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage8.line4}",
					Name = ""
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage8.line5}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.stage8.line6}",
					Name = ""
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.stage8.line7}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage8.line8}"
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.stage8.line9}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.stage8.line10}"
				}
			]
		},
		epilogue = {
			Title = "$bv{chapter.seven_shields.lower.epilogue.name}",
			Background = "ui/chapters/seven_shields/lower.jpg",
			Video = "",
			PortraitOrder = ["maia", "luu_luu", "claudia", "celestine"],
			Lines = [
				{
					Speaker = "maia",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line1}"
				},
				{
					Speaker = "luu_luu",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line2}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line3}",
					Name = ""
				},
				{
					Speaker = "claudia",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line4}"
				},
				{
					Speaker = "celestine",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line5}"
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line6}"
				},
				{
					Speaker = "captain",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line7}",
					Name = ""
				},
				{
					Speaker = "narrator",
					Text = "$bv{chapter.seven_shields.lower.epilogue.line8}"
				}
			]
		}
	},
	Nodes = {
		fourth_approach = {
			Name = "$bv{chapter.seven_shields.lower.node.fourth_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_four = {
			Name = "$bv{chapter.seven_shields.lower.node.fortress_four}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		fifth_approach = {
			Name = "$bv{chapter.seven_shields.lower.node.fifth_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_five = {
			Name = "$bv{chapter.seven_shields.lower.node.fortress_five}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		sixth_approach = {
			Name = "$bv{chapter.seven_shields.lower.node.sixth_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_six = {
			Name = "$bv{chapter.seven_shields.lower.node.fortress_six}",
			Brush = "world_bandit_camp_01",
			Battle = true
		},
		seventh_approach = {
			Name = "$bv{chapter.seven_shields.lower.node.seventh_approach}",
			Brush = "world_ruins_01",
			Battle = false
		},
		fortress_seven = {
			Name = "$bv{chapter.seven_shields.lower.node.fortress_seven}",
			Brush = "world_bandit_camp_01",
			Battle = true
		}
	},
	Stages = [
		{
			Name = "$bv{chapter.seven_shields.lower.stage1.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage1.brief}",
			Scene = "stage1",
			Goals = [
				{
					Key = "fourth_approach_waterway",
					Name = "$bv{chapter.seven_shields.lower.stage1.goal1}",
					Action = "$bv{chapter.seven_shields.lower.stage1.action1}",
					Node = "fourth_approach",
					Battle = false
				},
				{
					Key = "fourth_approach_sluice",
					Name = "$bv{chapter.seven_shields.lower.stage1.goal2}",
					Action = "$bv{chapter.seven_shields.lower.stage1.action2}",
					Node = "fourth_approach",
					Battle = false,
					Requires = ["fourth_approach_waterway"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 10,
					Source = "$bv{chapter.seven_shields.material.tools}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage2.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage2.brief}",
			Scene = "stage2",
			Goals = [
				{
					Key = "fortress_four_won",
					Name = "$bv{chapter.seven_shields.lower.stage2.goal}",
					Node = "fortress_four",
					Battle = true
				}
			],
			Materials = [],
			Money = 4500,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["fourth_approach_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage3.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage3.brief}",
			Scene = "stage3",
			Goals = [
				{
					Key = "fifth_approach_forest",
					Name = "$bv{chapter.seven_shields.lower.stage3.goal1}",
					Action = "$bv{chapter.seven_shields.lower.stage3.action1}",
					Node = "fifth_approach",
					Battle = false
				},
				{
					Key = "fifth_approach_clan",
					Name = "$bv{chapter.seven_shields.lower.stage3.goal2}",
					Action = "$bv{chapter.seven_shields.lower.stage3.action2}",
					Node = "fifth_approach",
					Battle = false,
					Requires = ["fifth_approach_forest"]
				}
			],
			Materials = [
				{
					Key = "medicine",
					Name = "$bv{chapter.material.medicine}",
					Count = 10,
					Source = "$bv{chapter.seven_shields.material.medicine}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage4.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage4.brief}",
			Scene = "stage4",
			Goals = [
				{
					Key = "fortress_five_won",
					Name = "$bv{chapter.seven_shields.lower.stage4.goal}",
					Node = "fortress_five",
					Battle = true
				}
			],
			Materials = [],
			Money = 5000,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["fifth_approach_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage5.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage5.brief}",
			Scene = "stage5",
			Goals = [
				{
					Key = "sixth_approach_ledger",
					Name = "$bv{chapter.seven_shields.lower.stage5.goal1}",
					Action = "$bv{chapter.seven_shields.lower.stage5.action1}",
					Node = "sixth_approach",
					Battle = false
				},
				{
					Key = "sixth_approach_bridge",
					Name = "$bv{chapter.seven_shields.lower.stage5.goal2}",
					Action = "$bv{chapter.seven_shields.lower.stage5.action2}",
					Node = "sixth_approach",
					Battle = false,
					Requires = ["sixth_approach_ledger"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 15,
					Source = "$bv{chapter.seven_shields.material.tools}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage6.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage6.brief}",
			Scene = "stage6",
			Goals = [
				{
					Key = "fortress_six_won",
					Name = "$bv{chapter.seven_shields.lower.stage6.goal}",
					Node = "fortress_six",
					Battle = true
				}
			],
			Materials = [],
			Money = 6000,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "",
			RequiredEvidence = ["sixth_approach_record"]
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage7.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage7.brief}",
			Scene = "stage7",
			Goals = [
				{
					Key = "seventh_approach_originals",
					Name = "$bv{chapter.seven_shields.lower.stage7.goal1}",
					Action = "$bv{chapter.seven_shields.lower.stage7.action1}",
					Node = "seventh_approach",
					Battle = false
				},
				{
					Key = "seventh_approach_court",
					Name = "$bv{chapter.seven_shields.lower.stage7.goal2}",
					Action = "$bv{chapter.seven_shields.lower.stage7.action2}",
					Node = "seventh_approach",
					Battle = false,
					Requires = ["seventh_approach_originals"]
				}
			],
			Materials = [
				{
					Key = "tools",
					Name = "$bv{chapter.material.tools}",
					Count = 15,
					Source = "$bv{chapter.seven_shields.material.tools}"
				},
				{
					Key = "medicine",
					Name = "$bv{chapter.material.medicine}",
					Count = 15,
					Source = "$bv{chapter.seven_shields.material.medicine}"
				}
			],
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = ""
		},
		{
			Name = "$bv{chapter.seven_shields.lower.stage8.name}",
			Brief = "$bv{chapter.seven_shields.lower.stage8.brief}",
			Scene = "stage8",
			Goals = [
				{
					Key = "fortress_seven_won",
					Name = "$bv{chapter.seven_shields.lower.stage8.goal}",
					Node = "fortress_seven",
					Battle = true
				}
			],
			Materials = [],
			Money = 10000,
			Medicine = 20,
			Tools = 20,
			PerksEach = 0,
			Special = "$bv{chapter.seven_shields.lower.stage8.special}",
			RequiredEvidence = ["seventh_approach_record"]
		}
	],
	Gallery = [
		{
			ID = "maia_defeat",
			Stage = 2,
			Title = "$bv{chapter.seven_shields.cg.maia.name}",
			Caption = "$bv{chapter.seven_shields.cg.maia.caption}",
			Image = "ui/chapters/seven_shields/cg_maia.jpg",
			Video = ""
		},
		{
			ID = "luu_luu_defeat",
			Stage = 4,
			Title = "$bv{chapter.seven_shields.cg.luu_luu.name}",
			Caption = "$bv{chapter.seven_shields.cg.luu_luu.caption}",
			Image = "ui/chapters/seven_shields/cg_luu_luu.jpg",
			Video = ""
		},
		{
			ID = "claudia_defeat",
			Stage = 6,
			Title = "$bv{chapter.seven_shields.cg.claudia.name}",
			Caption = "$bv{chapter.seven_shields.cg.claudia.caption}",
			Image = "ui/chapters/seven_shields/cg_claudia.jpg",
			Video = ""
		},
		{
			ID = "celestine_defeat",
			Stage = 8,
			Title = "$bv{chapter.seven_shields.cg.celestine.name}",
			Caption = "$bv{chapter.seven_shields.cg.celestine.caption}",
			Image = "ui/chapters/seven_shields/cg_celestine.jpg",
			Video = ""
		}
	],
	Evidence = [
		{
			Key = "fourth_approach_record",
			Name = "$bv{chapter.seven_shields.lower.stage1.evidence}",
			Source = "$bv{chapter.seven_shields.lower.stage1.brief}",
			Stage = 1,
			Goal = "fourth_approach_sluice"
		},
		{
			Key = "fifth_approach_record",
			Name = "$bv{chapter.seven_shields.lower.stage3.evidence}",
			Source = "$bv{chapter.seven_shields.lower.stage3.brief}",
			Stage = 3,
			Goal = "fifth_approach_clan"
		},
		{
			Key = "sixth_approach_record",
			Name = "$bv{chapter.seven_shields.lower.stage5.evidence}",
			Source = "$bv{chapter.seven_shields.lower.stage5.brief}",
			Stage = 5,
			Goal = "sixth_approach_bridge"
		},
		{
			Key = "seventh_approach_record",
			Name = "$bv{chapter.seven_shields.lower.stage7.evidence}",
			Source = "$bv{chapter.seven_shields.lower.stage7.brief}",
			Stage = 7,
			Goal = "seventh_approach_court"
		}
	]
};
::$bvvar{namespace}.Valkyries.maia.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.maia.ChapterRecruitHint <- "$bv{chapter.seven_shields.lower.recruit_only}";
::$bvvar{namespace}.Valkyries.luu_luu.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.luu_luu.ChapterRecruitHint <- "$bv{chapter.seven_shields.lower.recruit_only}";
::$bvvar{namespace}.Valkyries.claudia.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.claudia.ChapterRecruitHint <- "$bv{chapter.seven_shields.lower.recruit_only}";
::$bvvar{namespace}.Valkyries.celestine.ChapterRecruitOnly <- true;
::$bvvar{namespace}.Valkyries.celestine.ChapterRecruitHint <- "$bv{chapter.seven_shields.lower.recruit_only}";
