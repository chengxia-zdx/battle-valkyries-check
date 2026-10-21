// Stable chapter ID; progression and delivery use the shared transaction service.
::$bvvar{namespace}.ChapterDefinitions.thirteenth_bell <- {
	ID = "thirteenth_bell",
	Name = "$bv{chapter.thirteenth_bell.name}",
	Description = "$bv{chapter.thirteenth_bell.description}",
	Ending = "$bv{chapter.thirteenth_bell.ending}",
	Poster = "ui/chapters/thirteenth_bell/cover.jpg",
	Actors = ["rachel_alucard", "es"],
	PortraitOrder = ["rachel_alucard", "es"],
	Portraits = {
		rachel_alucard = "ui/chapters/thirteenth_bell/rachel_standing.png",
		es = "ui/chapters/thirteenth_bell/es_standing.png"
	},
	LocationScript = "scripts/entity/world/locations/battle_valkyries/thirteenth_bell_chapter_location",
	Videos = {

	},
	PreparationVersion = 1,
	Scenes = {
		opening = {
			Title = "$bv{chapter.thirteenth_bell.opening.name}",
			Background = "ui/chapters/thirteenth_bell/city.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.opening.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.opening.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.opening.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.opening.line4}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.opening.line5}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.opening.line6}"
			}]
		},
		stage1 = {
			Title = "$bv{chapter.thirteenth_bell.stage1.name}",
			Background = "ui/chapters/thirteenth_bell/tea.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage1.line1}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage1.line2}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage1.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage1.line4}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage1.line5}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage1.line6}"
			}]
		},
		stage2 = {
			Title = "$bv{chapter.thirteenth_bell.stage2.name}",
			Background = "ui/chapters/thirteenth_bell/cg_rain.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage2.line1}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage2.line2}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage2.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage2.line4}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage2.line5}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage2.line6}"
			}],
			PortraitOrder = []
		},
		stage3 = {
			Title = "$bv{chapter.thirteenth_bell.stage3.name}",
			Background = "ui/chapters/thirteenth_bell/chapel.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage3.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage3.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage3.line3}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage3.line4}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage3.line5}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage3.line6}"
			}]
		},
		stage4 = {
			Title = "$bv{chapter.thirteenth_bell.stage4.name}",
			Background = "ui/chapters/thirteenth_bell/cg_judgment.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage4.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage4.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage4.line3}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage4.line4}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage4.line5}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage4.line6}"
			}],
			PortraitOrder = []
		},
		stage5 = {
			Title = "$bv{chapter.thirteenth_bell.stage5.name}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage5.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage5.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage5.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage5.line4}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage5.line5}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage5.line6}"
			}]
		},
		stage6 = {
			Title = "$bv{chapter.thirteenth_bell.stage6.name}",
			Background = "ui/chapters/thirteenth_bell/cg_trust.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage6.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage6.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage6.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage6.line4}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage6.line5}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage6.line6}"
			}],
			PortraitOrder = []
		},
		stage7 = {
			Title = "$bv{chapter.thirteenth_bell.stage7.name}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage7.line1}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage7.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage7.line3}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage7.line4}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage7.line5}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage7.line6}"
			}]
		},
		stage8 = {
			Title = "$bv{chapter.thirteenth_bell.stage8.name}",
			Background = "ui/chapters/thirteenth_bell/cg_dawn.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage8.line1}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage8.line2}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage8.line3}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage8.line4}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage8.line5}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage8.line6}"
			}, {
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.stage8.line7}"
			}, {
				Speaker = "es",
				Text = "$bv{chapter.thirteenth_bell.stage8.line8}"
			}, {
				Speaker = "rachel_alucard",
				Text = "$bv{chapter.thirteenth_bell.stage8.line9}"
			}],
			PortraitOrder = []
		},
		prepare_accounts = {
			Title = "$bv{chapter.thirteenth_bell.action.accounts}",
			Background = "ui/chapters/thirteenth_bell/tea.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_accounts.line1}"
			}]
		},
		prepare_dessert = {
			Title = "$bv{chapter.thirteenth_bell.action.dessert}",
			Background = "ui/chapters/thirteenth_bell/tea.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_dessert.line1}"
			}]
		},
		prepare_signs = {
			Title = "$bv{chapter.thirteenth_bell.action.signs}",
			Background = "ui/chapters/thirteenth_bell/tea.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_signs.line1}"
			}]
		},
		prepare_names = {
			Title = "$bv{chapter.thirteenth_bell.action.names}",
			Background = "ui/chapters/thirteenth_bell/chapel.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_names.line1}"
			}]
		},
		prepare_patients = {
			Title = "$bv{chapter.thirteenth_bell.action.patients}",
			Background = "ui/chapters/thirteenth_bell/chapel.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_patients.line1}"
			}]
		},
		prepare_route = {
			Title = "$bv{chapter.thirteenth_bell.action.route}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_route.line1}"
			}]
		},
		prepare_anchors = {
			Title = "$bv{chapter.thirteenth_bell.action.anchors}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_anchors.line1}"
			}]
		},
		prepare_evacuation = {
			Title = "$bv{chapter.thirteenth_bell.action.evacuation}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_evacuation.line1}"
			}]
		},
		prepare_plan = {
			Title = "$bv{chapter.thirteenth_bell.action.plan}",
			Background = "ui/chapters/thirteenth_bell/greenhouse.jpg",
			Video = "",
			Lines = [{
				Speaker = "narrator",
				Text = "$bv{chapter.thirteenth_bell.prepare_plan.line1}"
			}]
		}
	},
	Stages = [{
		Name = "$bv{chapter.thirteenth_bell.stage1.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage1.brief}",
		Scene = "stage1",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.thirteenth_bell.reward.1}",
		Goals = [{
			Key = "accounts",
			Node = "tea",
			Name = "$bv{chapter.thirteenth_bell.action.accounts}",
			Action = "$bv{chapter.thirteenth_bell.action.accounts}",
			Battle = false,
			Scene = "prepare_accounts"
		}, {
			Key = "dessert",
			Node = "tea",
			Name = "$bv{chapter.thirteenth_bell.action.dessert}",
			Action = "$bv{chapter.thirteenth_bell.action.dessert}",
			Battle = false,
			Scene = "prepare_dessert",
			Requires = ["accounts"]
		}, {
			Key = "signs",
			Node = "tea",
			Name = "$bv{chapter.thirteenth_bell.action.signs}",
			Action = "$bv{chapter.thirteenth_bell.action.signs}",
			Battle = false,
			Scene = "prepare_signs",
			Requires = ["dessert"]
		}],
		Materials = [{
			Key = "tools",
			Name = "$bv{chapter.preparation.material.tools}",
			Source = "$bv{chapter.preparation.stock_source}",
			Count = 10
		}]
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage2.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage2.brief}",
		Scene = "stage2",
		Money = 1200,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.thirteenth_bell.reward.2}",
		Goals = [{
			Key = "procession_victory",
			Node = "procession",
			Name = "$bv{chapter.thirteenth_bell.goal.procession}",
			Battle = true
		}],
		Materials = []
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage3.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage3.brief}",
		Scene = "stage3",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.thirteenth_bell.reward.3}",
		Goals = [{
			Key = "names",
			Node = "chapel",
			Name = "$bv{chapter.thirteenth_bell.action.names}",
			Action = "$bv{chapter.thirteenth_bell.action.names}",
			Battle = false,
			Scene = "prepare_names"
		}, {
			Key = "patients",
			Node = "chapel",
			Name = "$bv{chapter.thirteenth_bell.action.patients}",
			Action = "$bv{chapter.thirteenth_bell.action.patients}",
			Battle = false,
			Scene = "prepare_patients",
			Requires = ["names"]
		}],
		Materials = [{
			Key = "medicine",
			Name = "$bv{chapter.preparation.material.medicine}",
			Source = "$bv{chapter.preparation.stock_source}",
			Count = 5
		}],
		RequiredEvidence = ["register"]
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage4.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage4.brief}",
		Scene = "stage4",
		Money = 1800,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.thirteenth_bell.reward.4}",
		Goals = [{
			Key = "street_victory",
			Node = "street",
			Name = "$bv{chapter.thirteenth_bell.goal.street}",
			Battle = true
		}],
		Materials = [],
		RequiredEvidence = ["register"]
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage5.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage5.brief}",
		Scene = "stage5",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.thirteenth_bell.reward.5}",
		Goals = [{
			Key = "route",
			Node = "greenhouse",
			Name = "$bv{chapter.thirteenth_bell.action.route}",
			Action = "$bv{chapter.thirteenth_bell.action.route}",
			Battle = false,
			Scene = "prepare_route"
		}, {
			Key = "anchors",
			Node = "greenhouse",
			Name = "$bv{chapter.thirteenth_bell.action.anchors}",
			Action = "$bv{chapter.thirteenth_bell.action.anchors}",
			Battle = false,
			Scene = "prepare_anchors",
			Requires = ["route"]
		}],
		Materials = [{
			Key = "tools",
			Name = "$bv{chapter.preparation.material.tools}",
			Source = "$bv{chapter.preparation.stock_source}",
			Count = 15
		}],
		RequiredEvidence = ["register"]
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage6.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage6.brief}",
		Scene = "stage6",
		Money = 2400,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.thirteenth_bell.reward.6}",
		Goals = [{
			Key = "shadows_victory",
			Node = "shadows",
			Name = "$bv{chapter.thirteenth_bell.goal.shadows}",
			Battle = true
		}],
		Materials = []
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage7.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage7.brief}",
		Scene = "stage7",
		Money = 0,
		Medicine = 0,
		Tools = 0,
		PerksEach = 0,
		Special = "$bv{chapter.thirteenth_bell.reward.7}",
		Goals = [{
			Key = "evacuation",
			Node = "refuge",
			Name = "$bv{chapter.thirteenth_bell.action.evacuation}",
			Action = "$bv{chapter.thirteenth_bell.action.evacuation}",
			Battle = false,
			Scene = "prepare_evacuation"
		}, {
			Key = "plan",
			Node = "refuge",
			Name = "$bv{chapter.thirteenth_bell.action.plan}",
			Action = "$bv{chapter.thirteenth_bell.action.plan}",
			Battle = false,
			Scene = "prepare_plan",
			Requires = ["evacuation"]
		}],
		Materials = [{
			Key = "medicine",
			Name = "$bv{chapter.preparation.material.medicine}",
			Source = "$bv{chapter.preparation.stock_source}",
			Count = 5
		}],
		RequiredEvidence = ["key"]
	}, {
		Name = "$bv{chapter.thirteenth_bell.stage8.name}",
		Brief = "$bv{chapter.thirteenth_bell.stage8.brief}",
		Scene = "stage8",
		Money = 3600,
		Medicine = 0,
		Tools = 0,
		PerksEach = 1,
		Special = "$bv{chapter.thirteenth_bell.reward.8}",
		Goals = [{
			Key = "keeper_victory",
			Node = "keeper",
			Name = "$bv{chapter.thirteenth_bell.goal.keeper}",
			Battle = true
		}],
		Materials = [],
		RequiredEvidence = ["key"]
	}],
	Nodes = {
		tea = {
			Name = "$bv{chapter.thirteenth_bell.node.tea}",
			Brush = "world_bv_thirteenth_bell",
			Battle = false
		},
		procession = {
			Name = "$bv{chapter.thirteenth_bell.node.procession}",
			Brush = "world_bv_thirteenth_bell",
			Battle = true
		},
		chapel = {
			Name = "$bv{chapter.thirteenth_bell.node.chapel}",
			Brush = "world_bv_thirteenth_bell",
			Battle = false
		},
		street = {
			Name = "$bv{chapter.thirteenth_bell.node.street}",
			Brush = "world_bv_thirteenth_bell",
			Battle = true
		},
		greenhouse = {
			Name = "$bv{chapter.thirteenth_bell.node.greenhouse}",
			Brush = "world_bv_thirteenth_bell",
			Battle = false
		},
		shadows = {
			Name = "$bv{chapter.thirteenth_bell.node.shadows}",
			Brush = "world_bv_thirteenth_bell",
			Battle = true
		},
		refuge = {
			Name = "$bv{chapter.thirteenth_bell.node.refuge}",
			Brush = "world_bv_thirteenth_bell",
			Battle = false
		},
		keeper = {
			Name = "$bv{chapter.thirteenth_bell.node.keeper}",
			Brush = "world_bv_thirteenth_bell",
			Battle = true
		}
	},
	SkillRewards = [{
		Actor = "rachel_alucard",
		Stage = 2,
		Key = "thirteenth_bell_tea"
	}, {
		Actor = "es",
		Stage = 4,
		Key = "thirteenth_bell_crest"
	}, {
		Actor = "rachel_alucard",
		Stage = 6,
		Key = "thirteenth_bell_promise"
	}, {
		Actor = "es",
		Stage = 6,
		Key = "thirteenth_bell_promise"
	}],
	SkinRewards = [{
		Actor = "rachel_alucard",
		Stage = 8,
		Skin = "rachel_dawn_tea_skin"
	}, {
		Actor = "es",
		Stage = 8,
		Skin = "es_homeward_watch_skin"
	}],
	Gallery = [{
		ID = "rain",
		Stage = 2,
		Title = "$bv{chapter.thirteenth_bell.cg.rain.title}",
		Caption = "$bv{chapter.thirteenth_bell.cg.rain.caption}",
		Image = "ui/chapters/thirteenth_bell/cg_rain.jpg"
	}, {
		ID = "judgment",
		Stage = 4,
		Title = "$bv{chapter.thirteenth_bell.cg.judgment.title}",
		Caption = "$bv{chapter.thirteenth_bell.cg.judgment.caption}",
		Image = "ui/chapters/thirteenth_bell/cg_judgment.jpg"
	}, {
		ID = "trust",
		Stage = 6,
		Title = "$bv{chapter.thirteenth_bell.cg.trust.title}",
		Caption = "$bv{chapter.thirteenth_bell.cg.trust.caption}",
		Image = "ui/chapters/thirteenth_bell/cg_trust.jpg"
	}, {
		ID = "dawn",
		Stage = 8,
		Title = "$bv{chapter.thirteenth_bell.cg.dawn.title}",
		Caption = "$bv{chapter.thirteenth_bell.cg.dawn.caption}",
		Image = "ui/chapters/thirteenth_bell/cg_dawn.jpg"
	}],
	Evidence = [{
		Key = "register",
		Stage = 2,
		Name = "$bv{chapter.thirteenth_bell.evidence.register}",
		Source = "$bv{chapter.thirteenth_bell.evidence.register.description}"
	}, {
		Key = "anchors",
		Stage = 5,
		Name = "$bv{chapter.thirteenth_bell.evidence.anchors}",
		Source = "$bv{chapter.thirteenth_bell.evidence.anchors.description}"
	}, {
		Key = "key",
		Stage = 6,
		Name = "$bv{chapter.thirteenth_bell.evidence.key}",
		Source = "$bv{chapter.thirteenth_bell.evidence.key.description}"
	}]
};
