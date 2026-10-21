// Eight stages, four fixed battles; all progress is owned by the shared chapter service.
::$bvvar{namespace}.ChapterDefinitions.blackgold_thirteenth_lot <- {
	ID = "blackgold_thirteenth_lot",
	SceneTokens = { alias = { Flag = "choice.alias", Values = { ash = "$bv{chapter.blackgold.alias.ash}", rose = "$bv{chapter.blackgold.alias.rose}" } } },
	Name = "$bv{chapter.blackgold.name}",
	Description = "$bv{chapter.blackgold.description}",
	Ending = "$bv{chapter.blackgold.ending}",
	Poster = "ui/chapters/blackgold_thirteenth_lot/cover.jpg",
	Actors = ["silver_wolf", "kafka"],
	PortraitOrder = ["silver_wolf", "kafka"],
	LocationScript = "scripts/entity/world/locations/battle_valkyries/blackgold_chapter_location",
	Videos = {

	},
	Portraits = {
		silver_wolf = "ui/chapters/blackgold_thirteenth_lot/silver_wolf_standing.png",
		kafka = "ui/chapters/blackgold_thirteenth_lot/kafka_standing.png"
	},
	Scenes = {
		opening = {
			Title = "$bv{chapter.blackgold.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage1.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.opening.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.opening.line2}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.opening.line3}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.opening.line4}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.opening.line5}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.opening.line6}"
				}]
		},
		clue_escape_route = {
			Title = "$bv{chapter.blackgold.goal.escape_route}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage1.jpg",
			Video = "",
			Lines = [{
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.clue_escape_route.line1}"
				}]
		},
		stage1 = {
			Title = "$bv{chapter.blackgold.stage1.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage1.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage1.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage1.line2}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage1.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage1.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage1.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage1.line6}"
				}]
		},
		stage2 = {
			Title = "$bv{chapter.blackgold.stage2.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage2.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage2.line1}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage2.line2}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage2.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage2.line4}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage2.line5}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage2.line6}"
				}]
		},
		clue_table = {
			Title = "$bv{chapter.blackgold.goal.table}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage3.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.clue_table.line1}"
				}]
		},
		clue_accounts = {
			Title = "$bv{chapter.blackgold.goal.accounts}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage3.jpg",
			Video = "",
			Lines = [{
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.clue_accounts.line1}"
				}]
		},
		clue_plinth = {
			Title = "$bv{chapter.blackgold.goal.plinth}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage3.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.clue_plinth.line1}"
				}]
		},
		stage3 = {
			Title = "$bv{chapter.blackgold.stage3.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/cg_banquet.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage3.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage3.line2}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage3.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage3.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage3.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage3.line6}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage3.line7}"
				}],
			PortraitOrder = []
		},
		stage4 = {
			Portraits = { silver_wolf = "ui/chapters/blackgold_thirteenth_lot/silver_wolf_resolved.png", kafka = "ui/chapters/blackgold_thirteenth_lot/kafka_resolved.png" },
			Title = "$bv{chapter.blackgold.stage4.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage4.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage4.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage4.line2}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage4.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage4.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage4.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage4.line6}"
				}]
		},
		clue_witness = {
			Title = "$bv{chapter.blackgold.goal.witness}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage5.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.clue_witness.line1}"
				}]
		},
		clue_originals = {
			Title = "$bv{chapter.blackgold.goal.originals}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage5.jpg",
			Video = "",
			Lines = [{
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.clue_originals.line1}"
				}]
		},
		clue_third_exit = {
			Title = "$bv{chapter.blackgold.goal.third_exit}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage5.jpg",
			Video = "",
			Lines = [{
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.clue_third_exit.line1}"
				}]
		},
		stage5 = {
			Portraits = { silver_wolf = "ui/chapters/blackgold_thirteenth_lot/silver_wolf_soft.png", kafka = "ui/chapters/blackgold_thirteenth_lot/kafka_soft.png" },
			Title = "$bv{chapter.blackgold.stage5.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage5.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage5.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage5.line2}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage5.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage5.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage5.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage5.line6}"
				}]
		},
		stage6 = {
			Portraits = { silver_wolf = "ui/chapters/blackgold_thirteenth_lot/silver_wolf_resolved.png", kafka = "ui/chapters/blackgold_thirteenth_lot/kafka_resolved.png" },
			Title = "$bv{chapter.blackgold.stage6.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage6.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage6.line1}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage6.line2}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage6.line3}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage6.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage6.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage6.line6}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage6.line7}"
				}]
		},
		clue_evidence_safe = {
			Title = "$bv{chapter.blackgold.goal.evidence_safe}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage7.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.clue_evidence_safe.line1}"
				}]
		},
		clue_witness_safe = {
			Title = "$bv{chapter.blackgold.goal.witness_safe}",
			Background = "ui/chapters/blackgold_thirteenth_lot/stage7.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.clue_witness_safe.line1}"
				}]
		},
		stage7 = {
			Title = "$bv{chapter.blackgold.stage7.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/cg_bridge_handoff.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage7.line1}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage7.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage7.line3}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage7.line4}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage7.line5}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage7.line6}"
				}],
			PortraitOrder = []
		},
		stage8 = {
			Title = "$bv{chapter.blackgold.stage8.name}",
			Background = "ui/chapters/blackgold_thirteenth_lot/cg_ending.jpg",
			Video = "",
			Lines = [{
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage8.line1}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage8.line2}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage8.line3}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage8.line4}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage8.line5}"
				}, {
					Speaker = "kafka",
					Text = "$bv{chapter.blackgold.stage8.line6}"
				}, {
					Speaker = "silver_wolf",
					Text = "$bv{chapter.blackgold.stage8.line7}"
				}, {
					Speaker = "narrator",
					Text = "$bv{chapter.blackgold.stage8.line8}"
				}],
			PortraitOrder = []
		}
	},
	Stages = [{
			Name = "$bv{chapter.blackgold.stage1.name}",
			Brief = "$bv{chapter.blackgold.stage1.brief}",
			Scene = "stage1",
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "alias",
					Node = "inn",
					Name = "$bv{chapter.blackgold.goal.alias}",
					Battle = false,
					Choices = [{
							ID = "ash",
							Name = "$bv{chapter.blackgold.alias.ash}"
						}, {
							ID = "rose",
							Name = "$bv{chapter.blackgold.alias.rose}"
						}]
				}, {
					Key = "escape_route",
					Node = "inn",
					Name = "$bv{chapter.blackgold.goal.escape_route}",
					Battle = false,
					Scene = "clue_escape_route"
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage2.name}",
			Brief = "$bv{chapter.blackgold.stage2.brief}",
			Scene = "stage2",
			Money = 1200,
			Medicine = 0,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "depot_clear",
					Node = "depot",
					Name = "$bv{chapter.blackgold.goal.depot_clear}",
					Battle = true
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage3.name}",
			Brief = "$bv{chapter.blackgold.stage3.brief}",
			Scene = "stage3",
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "table",
					Node = "banquet",
					Name = "$bv{chapter.blackgold.goal.table}",
					Battle = false,
					Scene = "clue_table"
				}, {
					Key = "accounts",
					Node = "banquet",
					Name = "$bv{chapter.blackgold.goal.accounts}",
					Battle = false,
					Scene = "clue_accounts"
				}, {
					Key = "plinth",
					Node = "banquet",
					Name = "$bv{chapter.blackgold.goal.plinth}",
					Battle = false,
					Scene = "clue_plinth"
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage4.name}",
			Brief = "$bv{chapter.blackgold.stage4.brief}",
			Scene = "stage4",
			Money = 2000,
			Medicine = 0,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "vault_clear",
					Node = "vault",
					Name = "$bv{chapter.blackgold.goal.vault_clear}",
					Battle = true
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage5.name}",
			Brief = "$bv{chapter.blackgold.stage5.brief}",
			Scene = "stage5",
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "witness",
					Node = "workshop",
					Name = "$bv{chapter.blackgold.goal.witness}",
					Battle = false,
					Scene = "clue_witness"
				}, {
					Key = "originals",
					Node = "workshop",
					Name = "$bv{chapter.blackgold.goal.originals}",
					Battle = false,
					Scene = "clue_originals"
				}, {
					Key = "third_exit",
					Node = "workshop",
					Name = "$bv{chapter.blackgold.goal.third_exit}",
					Battle = false,
					Scene = "clue_third_exit"
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage6.name}",
			Brief = "$bv{chapter.blackgold.stage6.brief}",
			Scene = "stage6",
			Money = 3000,
			Medicine = 0,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "backstage_clear",
					Node = "backstage",
					Name = "$bv{chapter.blackgold.goal.backstage_clear}",
					Battle = true
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage7.name}",
			Brief = "$bv{chapter.blackgold.stage7.brief}",
			Scene = "stage7",
			Money = 0,
			Medicine = 0,
			Tools = 0,
			PerksEach = 0,
			Special = "$bv{chapter.blackgold.reward.story}",
			Goals = [{
					Key = "evidence_safe",
					Node = "bridge",
					Name = "$bv{chapter.blackgold.goal.evidence_safe}",
					Battle = false,
					Scene = "clue_evidence_safe"
				}, {
					Key = "witness_safe",
					Node = "bridge",
					Name = "$bv{chapter.blackgold.goal.witness_safe}",
					Battle = false,
					Scene = "clue_witness_safe"
				}],
			Materials = []
		}, {
			Name = "$bv{chapter.blackgold.stage8.name}",
			Brief = "$bv{chapter.blackgold.stage8.brief}",
			Scene = "stage8",
			Money = 4500,
			Medicine = 0,
			Tools = 0,
			PerksEach = 1,
			Special = "$bv{chapter.blackgold.reward.ending}",
			Goals = [{
					Key = "yard_clear",
					Node = "yard",
					Name = "$bv{chapter.blackgold.goal.yard_clear}",
					Battle = true
				}],
			Materials = []
		}],
	Nodes = {
		inn = {
			Name = "$bv{chapter.blackgold.node.inn}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = false
		},
		depot = {
			Name = "$bv{chapter.blackgold.node.depot}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = true
		},
		banquet = {
			Name = "$bv{chapter.blackgold.node.banquet}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = false
		},
		vault = {
			Name = "$bv{chapter.blackgold.node.vault}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = true
		},
		workshop = {
			Name = "$bv{chapter.blackgold.node.workshop}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = false
		},
		backstage = {
			Name = "$bv{chapter.blackgold.node.backstage}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = true
		},
		bridge = {
			Name = "$bv{chapter.blackgold.node.bridge}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = false
		},
		yard = {
			Name = "$bv{chapter.blackgold.node.yard}",
			Brush = "world_bv_blackgold_thirteenth_lot",
			Battle = true
		}
	},
	SkillRewards = [{
			Actor = "silver_wolf",
			Stage = 8,
			Key = "blackgold_leave_an_exit"
		}, {
			Actor = "kafka",
			Stage = 8,
			Key = "blackgold_listen_this_time"
		}],
	SkinRewards = [{
			Actor = "silver_wolf",
			Stage = 8,
			Skin = "silver_wolf_blackgold_soiree_skin"
		}, {
			Actor = "kafka",
			Stage = 8,
			Skin = "kafka_blackgold_soiree_skin"
		}],
	Gallery = [{
			ID = "banquet",
			Stage = 3,
			Title = "$bv{chapter.blackgold.cg.banquet.title}",
			Caption = "$bv{chapter.blackgold.cg.banquet.caption}",
			Image = "ui/chapters/blackgold_thirteenth_lot/cg_banquet.jpg"
		}, {
			ID = "bridge_handoff",
			Stage = 7,
			Title = "$bv{chapter.blackgold.cg.bridge_handoff.title}",
			Caption = "$bv{chapter.blackgold.cg.bridge_handoff.caption}",
			Image = "ui/chapters/blackgold_thirteenth_lot/cg_bridge_handoff.jpg"
		}, {
			ID = "ending",
			Stage = 8,
			Title = "$bv{chapter.blackgold.cg.ending.title}",
			Caption = "$bv{chapter.blackgold.cg.ending.caption}",
			Image = "ui/chapters/blackgold_thirteenth_lot/cg_ending.jpg"
		}]
};
::$bvvar{namespace}.Skins.silver_wolf_blackgold_soiree_skin <- {
	ID = "silver_wolf_blackgold_soiree_skin",
	ValkyrieID = "silver_wolf",
	IsOriginal = false,
	UnlockChapter = "blackgold_thirteenth_lot",
	Name = "$bv{chapter.blackgold.skin.silver_wolf.name}",
	TabName = "$bv{chapter.blackgold.skin.silver_wolf.tab}",
	Description = "$bv{chapter.blackgold.skin.silver_wolf.description}",
	Brush = "bust_bv_silver_wolf_blackgold_soiree_skin",
	DeathBrush = "bust_bv_silver_wolf_blackgold_soiree_skin_dead",
	WorldLeaderBrush = "world_bv_silver_wolf_blackgold_soiree_leader",
	Portrait = "ui/chapters/blackgold_thirteenth_lot/silver_wolf_standing.png",
	Preview = "ui/valkyries/silver_wolf_blackgold_soiree_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/silver_wolf_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/silver_wolf_blackgold_soiree_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/silver_wolf_blackgold_soiree_skin_poster.jpg",
		Video = "ui/valkyries/detail/silver_wolf_blackgold_soiree_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.silver_wolf)) ::$bvvar{namespace}.Valkyries.silver_wolf.SkinIDs <- ["silver_wolf_skin"];
if (::$bvvar{namespace}.Valkyries.silver_wolf.SkinIDs.find("silver_wolf_blackgold_soiree_skin") == null) ::$bvvar{namespace}.Valkyries.silver_wolf.SkinIDs.push("silver_wolf_blackgold_soiree_skin");
::$bvvar{namespace}.Skins.kafka_blackgold_soiree_skin <- {
	ID = "kafka_blackgold_soiree_skin",
	ValkyrieID = "kafka",
	IsOriginal = false,
	UnlockChapter = "blackgold_thirteenth_lot",
	Name = "$bv{chapter.blackgold.skin.kafka.name}",
	TabName = "$bv{chapter.blackgold.skin.kafka.tab}",
	Description = "$bv{chapter.blackgold.skin.kafka.description}",
	Brush = "bust_bv_kafka_blackgold_soiree_skin",
	DeathBrush = "bust_bv_kafka_blackgold_soiree_skin_dead",
	WorldLeaderBrush = "world_bv_kafka_blackgold_soiree_leader",
	Portrait = "ui/chapters/blackgold_thirteenth_lot/kafka_standing.png",
	Preview = "ui/valkyries/kafka_blackgold_soiree_skin_preview.png",
	TraitIcon = "ui/traits/$bvvar{iconPrefix}/kafka_trait_icon.png",
	ItemIcon = "$bvvar{iconPrefix}/kafka_blackgold_soiree_skin_icon.png",
	DetailMedia = {
		Poster = "ui/valkyries/detail/kafka_blackgold_soiree_skin_poster.jpg",
		Video = "ui/valkyries/detail/kafka_blackgold_soiree_skin_idle.webm",
		PositionX = 0.35,
		PositionY = 0.1
	}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.kafka)) ::$bvvar{namespace}.Valkyries.kafka.SkinIDs <- ["kafka_skin"];
if (::$bvvar{namespace}.Valkyries.kafka.SkinIDs.find("kafka_blackgold_soiree_skin") == null) ::$bvvar{namespace}.Valkyries.kafka.SkinIDs.push("kafka_blackgold_soiree_skin");
