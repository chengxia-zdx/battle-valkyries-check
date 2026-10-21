::$bvvar{namespace}.Settings <- {
	HideWeapons = true,
	VoiceVolumePercent = 300,
	SkillSoundVolume = 100,
	GachaMode = true,
	EnableRosterExpansion = true,
	RosterCapacity = 200,
	CombatCapacity = 0,
	EnableValkyrieEnemyScaling = true,
	DebugSkin = false,
	DebugSkills = false,
	DebugSaveCompat = false
};

::$bvvar{namespace}.Skins <- {
	abigail_williams_skin = {
		ID="abigail_williams_skin",Name="$bv{skin.abigail_williams_skin.name}",TabName="$bv{skin.abigail_williams_skin.tab_name}",Description="$bv{skin.abigail_williams_skin.description}",
		Brush="bust_bv_abigail_williams_skin",DeathBrush="bust_bv_abigail_williams_skin_dead",WorldLeaderBrush="world_bv_abigail_williams_leader",
		Portrait="ui/valkyries/abigail_williams_card.png",Preview="ui/valkyries/abigail_williams_skin_preview.png",
		TraitIcon="ui/traits/$bvvar{iconPrefix}/abigail_williams_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/abigail_williams_skin_icon.png",
		DetailMedia={Poster="ui/valkyries/detail/abigail_williams_skin_poster.jpg",Video="ui/valkyries/detail/abigail_williams_skin_idle.webm",PositionX=0.35,PositionY=0.10}
	},
	katsushika_hokusai_skin = {
		ID="katsushika_hokusai_skin",Name="$bv{skin.katsushika_hokusai_skin.name}",TabName="$bv{skin.katsushika_hokusai_skin.tab_name}",Description="$bv{skin.katsushika_hokusai_skin.description}",
		Brush="bust_bv_katsushika_hokusai_skin",DeathBrush="bust_bv_katsushika_hokusai_skin_dead",WorldLeaderBrush="world_bv_katsushika_hokusai_leader",
		Portrait="ui/valkyries/katsushika_hokusai_card.png",Preview="ui/valkyries/katsushika_hokusai_skin_preview.png",
		TraitIcon="ui/traits/$bvvar{iconPrefix}/katsushika_hokusai_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/katsushika_hokusai_skin_icon.png",
		DetailMedia={Poster="ui/valkyries/detail/katsushika_hokusai_skin_poster.jpg",Video="ui/valkyries/detail/katsushika_hokusai_skin_idle.webm",PositionX=0.35,PositionY=0.10}
	},
	c_c_skin = {
		ID="c_c_skin",Name="$bv{skin.c_c_skin.name}",TabName="$bv{skin.c_c_skin.tab_name}",Description="$bv{skin.c_c_skin.description}",
		Brush="bust_bv_c_c_skin",DeathBrush="bust_bv_c_c_skin_dead",WorldLeaderBrush="world_bv_c_c_leader",
		Portrait="ui/valkyries/c_c_card.png",Preview="ui/valkyries/c_c_skin_preview.png",
		TraitIcon="ui/traits/$bvvar{iconPrefix}/c_c_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/c_c_skin_icon.png",
		DetailMedia={Poster="ui/valkyries/detail/c_c_skin_poster.jpg",Video="ui/valkyries/detail/c_c_skin_idle.webm",PositionX=0.35,PositionY=0.10}
	},
	enterprise_skin = {
		ID="enterprise_skin", Name="$bv{skin.enterprise_skin.name}", TabName="$bv{skin.enterprise_skin.tab_name}", Description="$bv{skin.enterprise_skin.description}",
		Brush="bust_bv_enterprise_skin", DeathBrush="bust_bv_enterprise_skin_dead", WorldLeaderBrush="world_bv_enterprise_leader",
		Portrait="ui/valkyries/enterprise_card.png", Preview="ui/valkyries/enterprise_skin_preview.png",
		TraitIcon="ui/traits/$bvvar{iconPrefix}/enterprise_trait_icon.png", ItemIcon="$bvvar{iconPrefix}/enterprise_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/enterprise_skin_poster.jpg", Video = "ui/valkyries/detail/enterprise_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	togawa_sakiko_skin = {
		ID="togawa_sakiko_skin", Name="$bv{skin.togawa_sakiko_skin.name}", TabName="$bv{skin.togawa_sakiko_skin.tab_name}", Description="$bv{skin.togawa_sakiko_skin.description}",
		Brush="bust_bv_togawa_sakiko_skin", DeathBrush="bust_bv_togawa_sakiko_skin_dead", WorldLeaderBrush="world_bv_togawa_sakiko_skin_leader",
		Portrait="ui/valkyries/togawa_sakiko_card.png", Preview="ui/valkyries/togawa_sakiko_skin_preview.png",
		TraitIcon="ui/traits/$bvvar{iconPrefix}/togawa_sakiko_trait_icon.png", ItemIcon="$bvvar{iconPrefix}/togawa_sakiko_skin_icon.png",
		DetailMedia={Poster="ui/valkyries/detail/togawa_sakiko_skin_poster.jpg", Video="ui/valkyries/detail/togawa_sakiko_skin_idle.webm", PositionX=0.35, PositionY=0.10}
	},
	m4a1_skin = {
		ID = "m4a1_skin", Name = "$bv{skin.m4a1_skin.name}", TabName = "$bv{skin.m4a1_skin.tab_name}", Description = "$bv{skin.m4a1_skin.description}",
		Brush = "bust_bv_m4a1_skin", DeathBrush = "bust_bv_m4a1_skin_dead", WorldLeaderBrush = "world_bv_m4a1_leader",
		Portrait = "ui/valkyries/m4a1_card.png", Preview = "ui/valkyries/m4a1_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/m4a1_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/m4a1_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/m4a1_skin_poster.jpg", Video = "ui/valkyries/detail/m4a1_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	morgan_skin = {
		ID = "morgan_skin", Name = "$bv{skin.morgan_skin.name}", TabName = "$bv{skin.morgan_skin.tab_name}",
		Description = "$bv{skin.morgan_skin.description}",
		Brush = "bust_bv_morgan_skin", DeathBrush = "bust_bv_morgan_skin_dead", WorldLeaderBrush = "world_bv_morgan_leader",
		Portrait = "ui/valkyries/morgan_card.png", Preview = "ui/valkyries/morgan_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/morgan_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/morgan_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/morgan_skin_poster.jpg", Video = "ui/valkyries/detail/morgan_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	meltryllis_skin = {
		ID = "meltryllis_skin", Name = "$bv{skin.meltryllis_skin.name}", TabName = "$bv{skin.meltryllis_skin.tab_name}",
		Brush = "bust_bv_meltryllis_skin", DeathBrush = "bust_bv_meltryllis_skin_dead", WorldLeaderBrush = "world_bv_meltryllis_leader",
		Portrait = "ui/valkyries/meltryllis_card.png", Preview = "ui/valkyries/meltryllis_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/meltryllis_trait_icon.png", ItemIcon = "$bvvar{iconPrefix}/meltryllis_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/meltryllis_skin_poster.jpg", Video = "ui/valkyries/detail/meltryllis_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	saber_skin = {
		ID = "saber_skin",
		Name = "$bv{skin.saber_skin.name}",
		Brush = "bust_bv_saber_skin",
		DeathBrush = "bust_bv_saber_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/saber_skin_poster.jpg", Video = "ui/valkyries/detail/saber_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	silver_wolf_skin = {
		ID = "silver_wolf_skin",
		Name = "$bv{skin.silver_wolf_skin.name}",
		Brush = "bust_bv_silver_wolf_skin",
		DeathBrush = "bust_bv_silver_wolf_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/silver_wolf_skin_poster.jpg", Video = "ui/valkyries/detail/silver_wolf_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	robin_skin = {
		ID = "robin_skin",
		Name = "$bv{skin.robin_skin.name}",
		Description = "$bv{skin.robin_skin.description}",
		Brush = "bust_bv_robin_skin",
		DeathBrush = "bust_bv_robin_skin_dead",
		WorldLeaderBrush = "world_bv_robin_leader",
		TabName = "$bv{skin.robin_skin.tab_name}",
		Portrait = "ui/valkyries/robin_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/robin_skin_poster.jpg",
			Video = "ui/valkyries/detail/robin_skin_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/robin_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/robin_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/robin_skin_icon.png"
	},
	jeanne_skin = {
		ID = "jeanne_skin",
		Name = "$bv{skin.jeanne_skin.name}",
		Description = "$bv{skin.jeanne_skin.description}",
		Brush = "bust_bv_jeanne_skin",
		DeathBrush = "bust_bv_jeanne_skin_dead",
		WorldLeaderBrush = "world_bv_jeanne_leader",
		TabName = "$bv{skin.jeanne_skin.tab_name}",
		Portrait = "ui/valkyries/jeanne_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/jeanne_poster.jpg",
			Video = "ui/valkyries/detail/jeanne_idle.webm",
			PositionX = 0.35,
			PositionY = 0.1
		},
		Preview = "ui/valkyries/jeanne_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jeanne_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/jeanne_skin_icon.png"
	},
	sword_maiden_skin = {
		ID = "sword_maiden_skin",
		Name = "$bv{skin.sword_maiden_skin.name}",
		Description = "$bv{skin.sword_maiden_skin.description}",
		Brush = "bust_bv_sword_maiden_skin",
		DeathBrush = "bust_bv_sword_maiden_skin_dead",
		WorldLeaderBrush = "world_bv_sword_maiden_leader",
		TabName = "$bv{skin.sword_maiden_skin.tab_name}",
		Portrait = "ui/valkyries/sword_maiden_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/sword_maiden_skin_poster.jpg",
			Video = "ui/valkyries/detail/sword_maiden_skin_idle.webm",
			PositionX = 0.32,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/sword_maiden_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/sword_maiden_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/sword_maiden_skin_icon.png"
	},
	jeanne_summer_skin = {
		ID = "jeanne_summer_skin",
		Name = "$bv{skin.jeanne_summer_skin.name}",
		Description = "$bv{skin.jeanne_summer_skin.description}",
		Brush = "bust_bv_jeanne_summer_skin",
		DeathBrush = "bust_bv_jeanne_summer_skin_dead",
		WorldLeaderBrush = "world_bv_jeanne_summer_leader",
		TabName = "$bv{skin.jeanne_summer_skin.tab_name}",
		Portrait = "ui/valkyries/jeanne_summer_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/jeanne_summer_skin_poster.jpg",
			Video = "ui/valkyries/detail/jeanne_summer_skin_idle.webm",
			PositionX = 0.25,
			PositionY = 0.1
		},
		Preview = "ui/valkyries/jeanne_summer_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jeanne_summer_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/jeanne_summer_skin_icon.png"
	},
	jeanne_beach_skin = {
		ID = "jeanne_beach_skin",
		Name = "$bv{skin.jeanne_beach_skin.name}",
		Description = "$bv{skin.jeanne_beach_skin.description}",
		Brush = "bust_bv_jeanne_beach_skin",
		DeathBrush = "bust_bv_jeanne_beach_skin_dead",
		WorldLeaderBrush = "world_bv_jeanne_beach_leader",
		TabName = "$bv{skin.jeanne_beach_skin.tab_name}",
		Portrait = "ui/valkyries/jeanne_beach_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/jeanne_beach_skin_poster.jpg",
			Video = "ui/valkyries/detail/jeanne_beach_skin_idle.webm",
			PositionX = 0.25,
			PositionY = 0.1
		},
		Preview = "ui/valkyries/jeanne_beach_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jeanne_beach_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/jeanne_beach_skin_icon.png"
	},
	jeanne_alter_skin = {
		ID = "jeanne_alter_skin",
		Name = "$bv{skin.jeanne_alter_skin.name}",
		Brush = "bust_bv_jeanne_alter_skin",
		DeathBrush = "bust_bv_jeanne_alter_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/jeanne_alter_skin_poster.jpg", Video = "ui/valkyries/detail/jeanne_alter_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	jingliu_skin = {
		ID = "jingliu_skin",
		Name = "$bv{skin.jingliu_skin.name}",
		Brush = "bust_bv_jingliu_skin",
		DeathBrush = "bust_bv_jingliu_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/jingliu_skin_poster.jpg", Video = "ui/valkyries/detail/jingliu_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	jingliu_frostmoon_tide_skin = {
		ID = "jingliu_frostmoon_tide_skin",
		Name = "$bv{skin.jingliu_frostmoon_tide_skin.name}",
		Description = "$bv{skin.jingliu_frostmoon_tide_skin.description}",
		Brush = "bust_bv_jingliu_frostmoon_tide_skin",
		DeathBrush = "bust_bv_jingliu_frostmoon_tide_skin_dead",
		TabName = "$bv{skin.jingliu_frostmoon_tide_skin.tab_name}",
		Portrait = "ui/valkyries/jingliu_frostmoon_tide_card.png",
		Preview = "ui/valkyries/jingliu_frostmoon_tide_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jingliu_frostmoon_tide_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/jingliu_frostmoon_tide_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/jingliu_frostmoon_tide_skin_poster.jpg", Video = "ui/valkyries/detail/jingliu_frostmoon_tide_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	jingliu_bride_skin = {
		ID = "jingliu_bride_skin",
		Name = "$bv{skin.jingliu_bride_skin.name}",
		Description = "$bv{skin.jingliu_bride_skin.description}",
		Brush = "bust_bv_jingliu_bride_skin",
		DeathBrush = "bust_bv_jingliu_bride_skin_dead",
		TabName = "$bv{skin.jingliu_bride_skin.tab_name}",
		Portrait = "ui/valkyries/jingliu_bride_card.png",
		Preview = "ui/valkyries/jingliu_bride_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/jingliu_bride_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/jingliu_bride_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/jingliu_bride_skin_poster.jpg", Video = "ui/valkyries/detail/jingliu_bride_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	skirk_skin = {
		ID = "skirk_skin",
		Name = "$bv{skin.skirk_skin.name}",
		Brush = "bust_bv_skirk_skin",
		DeathBrush = "bust_bv_skirk_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/skirk_skin_poster.jpg", Video = "ui/valkyries/detail/skirk_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	jinhsi_skin = {
		ID = "jinhsi_skin",
		Name = "$bv{skin.jinhsi_skin.name}",
		Brush = "bust_bv_jinhsi_skin",
		DeathBrush = "bust_bv_jinhsi_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/jinhsi_skin_poster.jpg", Video = "ui/valkyries/detail/jinhsi_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	nahida_skin = {
		ID = "nahida_skin",
		Name = "$bv{skin.nahida_skin.name}",
		Description = "$bv{skin.nahida_skin.description}",
		Brush = "bust_bv_nahida_skin",
		DeathBrush = "bust_bv_nahida_skin_dead",
		TabName = "$bv{skin.nahida_skin.tab_name}",
		Portrait = "ui/valkyries/nahida_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/nahida_skin_poster.jpg",
			Video = "ui/valkyries/detail/nahida_skin_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/nahida_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/nahida_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/nahida_skin_icon.png"
	},
	hakurei_reimu_skin = {
		ID = "hakurei_reimu_skin",
		Name = "$bv{skin.hakurei_reimu_skin.name}",
		Description = "$bv{skin.hakurei_reimu_skin.description}",
		Brush = "bust_bv_hakurei_reimu_skin",
		DeathBrush = "bust_bv_hakurei_reimu_skin_dead",
		WorldLeaderBrush = "world_bv_hakurei_reimu_leader",
		TabName = "$bv{skin.hakurei_reimu_skin.tab_name}",
		Portrait = "ui/valkyries/hakurei_reimu_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/hakurei_reimu_poster.jpg",
			Video = "ui/valkyries/detail/hakurei_reimu_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/hakurei_reimu_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/hakurei_reimu_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/hakurei_reimu_skin_icon.png"
	},
	yae_miko_skin = {
		ID = "yae_miko_skin",
		Name = "$bv{skin.yae_miko_skin.name}",
		Brush = "bust_bv_yae_miko_skin",
		DeathBrush = "bust_bv_yae_miko_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/yae_miko_skin_poster.jpg", Video = "ui/valkyries/detail/yae_miko_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	chisaki_skin = {
		ID = "chisaki_skin",
		Name = "$bv{skin.chisaki_skin.name}",
		Brush = "bust_bv_chisaki_skin",
		DeathBrush = "bust_bv_chisaki_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/chisaki_skin_poster.jpg", Video = "ui/valkyries/detail/chisaki_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	kafka_skin = {
		ID = "kafka_skin",
		Name = "$bv{skin.kafka_skin.name}",
		Brush = "bust_bv_kafka_skin",
		DeathBrush = "bust_bv_kafka_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/kafka_skin_poster.jpg", Video = "ui/valkyries/detail/kafka_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	ye_shunguang_enlightened_skin = {
		ID = "ye_shunguang_enlightened_skin",
		Name = "$bv{skin.ye_shunguang_enlightened_skin.name}",
		Brush = "bust_bv_ye_shunguang_enlightened",
		DeathBrush = "bust_bv_ye_shunguang_enlightened_dead"
	},
	ye_shunguang_skin = {
		ID = "ye_shunguang_skin",
		Name = "$bv{skin.ye_shunguang_skin.name}",
		Brush = "bust_bv_ye_shunguang_skin",
		DeathBrush = "bust_bv_ye_shunguang_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/ye_shunguang_skin_poster.jpg", Video = "ui/valkyries/detail/ye_shunguang_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	himeko_skin = {
		ID = "himeko_skin",
		Name = "$bv{skin.himeko_skin.name}",
		Description = "$bv{skin.himeko_skin.description}",
		Brush = "bust_bv_himeko_skin",
		DeathBrush = "bust_bv_himeko_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/himeko_skin_poster.jpg", Video = "ui/valkyries/detail/himeko_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	himeko_departure_skin = {
		ID = "himeko_departure_skin",
		Name = "$bv{skin.himeko_departure_skin.name}",
		Description = "$bv{skin.himeko_departure_skin.description}",
		Brush = "bust_bv_himeko_departure_skin",
		DeathBrush = "bust_bv_himeko_departure_skin_dead",
		WorldLeaderBrush = "world_bv_himeko_departure_leader",
		TabName = "$bv{skin.himeko_departure_skin.tab_name}",
		Portrait = "ui/valkyries/himeko_departure_card.png",
		Preview = "ui/valkyries/himeko_departure_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/himeko_departure_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/himeko_departure_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/himeko_departure_skin_poster.jpg", Video = "ui/valkyries/detail/himeko_departure_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	feixue_skin = {
		ID = "feixue_skin",
		Name = "$bv{skin.feixue_skin.name}",
		Brush = "bust_bv_feixue_skin",
		DeathBrush = "bust_bv_feixue_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/feixue_skin_poster.jpg", Video = "ui/valkyries/detail/feixue_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	feixiao_skin = {
		ID = "feixiao_skin",
		Name = "$bv{skin.feixiao_skin.name}",
		Brush = "bust_bv_feixiao_skin",
		DeathBrush = "bust_bv_feixiao_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/feixiao_skin_poster.jpg", Video = "ui/valkyries/detail/feixiao_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	changli_skin = {
		ID = "changli_skin",
		Name = "$bv{skin.changli_skin.name}",
		Brush = "bust_bv_changli_skin",
		DeathBrush = "bust_bv_changli_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/changli_skin_poster.jpg", Video = "ui/valkyries/detail/changli_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	raiden_shogun_skin = {
		ID = "raiden_shogun_skin",
		Name = "$bv{skin.raiden_shogun_skin.name}",
		Brush = "bust_bv_raiden_shogun_skin",
		DeathBrush = "bust_bv_raiden_shogun_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/raiden_shogun_skin_poster.jpg", Video = "ui/valkyries/detail/raiden_shogun_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	yixuan_skin = {
		ID = "yixuan_skin",
		Name = "$bv{skin.yixuan_skin.name}",
		Brush = "bust_bv_yixuan_skin",
		DeathBrush = "bust_bv_yixuan_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/yixuan_skin_poster.jpg", Video = "ui/valkyries/detail/yixuan_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	yixuan_ink_shadow_skin = {
		ID = "yixuan_ink_shadow_skin",
		UnlockChapter = "yunki_demon_chronicle",
		Name = "$bv{skin.yixuan_ink_shadow_skin.name}",
		Description = "$bv{skin.yixuan_ink_shadow_skin.description}",
		Brush = "bust_bv_yixuan_ink_shadow_skin",
		DeathBrush = "bust_bv_yixuan_ink_shadow_skin_dead",
		WorldLeaderBrush = "world_bv_yixuan_ink_shadow_leader",
		TabName = "$bv{skin.yixuan_ink_shadow_skin.tab_name}",
		Portrait = "ui/valkyries/yixuan_ink_shadow_card.png",
		Preview = "ui/valkyries/yixuan_ink_shadow_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/yixuan_ink_shadow_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/yixuan_ink_shadow_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/yixuan_ink_shadow_skin_poster.jpg", Video = "ui/valkyries/detail/yixuan_ink_shadow_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	xilian_skin = {
		ID = "xilian_skin",
		Name = "$bv{skin.xilian_skin.name}",
		Brush = "bust_bv_xilian_skin",
		DeathBrush = "bust_bv_xilian_skin_dead",
		Portrait = "ui/valkyries/xilian_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/xilian_skin_poster.jpg",
			Video = "ui/valkyries/detail/xilian_skin_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		}
	},
	liuying_skin = {
		ID = "liuying_skin",
		Name = "$bv{skin.liuying_skin.name}",
		Brush = "bust_bv_liuying_skin",
		DeathBrush = "bust_bv_liuying_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/liuying_skin_poster.jpg", Video = "ui/valkyries/detail/liuying_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	liuying_sam_skin = {
		ID = "liuying_sam_skin",
		Name = "$bv{skin.liuying_sam_skin.name}",
		Brush = "bust_bv_liuying_sam_skin",
		DeathBrush = "bust_bv_liuying_sam_skin_dead"
	},
	cartethyia_skin = {
		ID = "cartethyia_skin",
		Name = "$bv{skin.cartethyia_skin.name}",
		Brush = "bust_bv_cartethyia_skin",
		DeathBrush = "bust_bv_cartethyia_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/cartethyia_skin_poster.jpg", Video = "ui/valkyries/detail/cartethyia_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	fleurdelys_manifest_skin = {
		ID = "fleurdelys_manifest_skin",
		Name = "$bv{skin.fleurdelys_manifest_skin.name}",
		Brush = "bust_bv_fleurdelys_manifest",
		DeathBrush = "bust_bv_fleurdelys_manifest_dead"
	},
	castorice_skin = {
		ID = "castorice_skin",
		Name = "$bv{skin.castorice_skin.name}",
		Brush = "bust_bv_castorice_skin",
		DeathBrush = "bust_bv_castorice_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/castorice_skin_poster.jpg", Video = "ui/valkyries/detail/castorice_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	changyeyue_skin = {
		ID = "changyeyue_skin",
		Name = "$bv{skin.changyeyue_skin.name}",
		Brush = "bust_bv_changyeyue_skin",
		DeathBrush = "bust_bv_changyeyue_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/changyeyue_skin_poster.jpg", Video = "ui/valkyries/detail/changyeyue_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	hysilens_skin = {
		ID = "hysilens_skin",
		Name = "$bv{skin.hysilens_skin.name}",
		Brush = "bust_bv_hysilens_skin",
		DeathBrush = "bust_bv_hysilens_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/hysilens_skin_poster.jpg", Video = "ui/valkyries/detail/hysilens_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	tilixibiesi_skin = {
		ID = "tilixibiesi_skin",
		Name = "$bv{skin.tilixibiesi_skin.name}",
		Brush = "bust_bv_tilixibiesi_skin",
		DeathBrush = "bust_bv_tilixibiesi_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/tilixibiesi_skin_poster.jpg", Video = "ui/valkyries/detail/tilixibiesi_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	cipher_skin = {
		ID = "cipher_skin",
		Name = "$bv{skin.cipher_skin.name}",
		Brush = "bust_bv_cipher_skin",
		DeathBrush = "bust_bv_cipher_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/cipher_skin_poster.jpg", Video = "ui/valkyries/detail/cipher_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	cerydra_skin = {
		ID = "cerydra_skin",
		Name = "$bv{skin.cerydra_skin.name}",
		Brush = "bust_bv_cerydra_skin",
		DeathBrush = "bust_bv_cerydra_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/cerydra_skin_poster.jpg", Video = "ui/valkyries/detail/cerydra_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	fengjin_skin = {
		ID = "fengjin_skin",
		Name = "$bv{skin.fengjin_skin.name}",
		Brush = "bust_bv_fengjin_skin",
		DeathBrush = "bust_bv_fengjin_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/fengjin_skin_poster.jpg", Video = "ui/valkyries/detail/fengjin_skin_idle.webm", PositionX = 0.35, PositionY = 0.1 }
	},
	yuno_skin = {
		ID = "yuno_skin",
		Name = "$bv{skin.yuno_skin.name}",
		Brush = "bust_bv_yuno_skin",
		DeathBrush = "bust_bv_yuno_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/yuno_skin_poster.jpg", Video = "ui/valkyries/detail/yuno_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	phoebe_skin = {
		ID = "phoebe_skin",
		Name = "$bv{skin.phoebe_skin.name}",
		Brush = "bust_bv_phoebe_skin",
		DeathBrush = "bust_bv_phoebe_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/phoebe_skin_poster.jpg", Video = "ui/valkyries/detail/phoebe_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	wisadel_skin = {
		ID = "wisadel_skin",
		Name = "$bv{skin.wisadel_skin.name}",
		Brush = "bust_bv_wisadel_skin",
		DeathBrush = "bust_bv_wisadel_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/wisadel_skin_poster.jpg", Video = "ui/valkyries/detail/wisadel_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	aglaea_skin = {
		ID = "aglaea_skin",
		Name = "$bv{skin.aglaea_skin.name}",
		Brush = "bust_bv_aglaea_skin",
		DeathBrush = "bust_bv_aglaea_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/aglaea_skin_poster.jpg", Video = "ui/valkyries/detail/aglaea_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	mai_shiranui_skin = {
		ID = "mai_shiranui_skin",
		Name = "$bv{skin.mai_shiranui_skin.name}",
		Brush = "bust_bv_mai_shiranui_skin",
		DeathBrush = "bust_bv_mai_shiranui_skin_dead",
		TabName = "$bv{skin.mai_shiranui_skin.tab_name}",
		Portrait = "ui/valkyries/mai_shiranui_card.png",
		Preview = "ui/valkyries/mai_shiranui_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/mai_shiranui_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/mai_shiranui_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/mai_shiranui_skin_poster.jpg", Video = "ui/valkyries/detail/mai_shiranui_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	scarlet_shadow_kimono_skin = {
		ID = "scarlet_shadow_kimono_skin",
		Name = "$bv{skin.scarlet_shadow_kimono_skin.name}",
		Brush = "bust_bv_scarlet_shadow_kimono_skin",
		DeathBrush = "bust_bv_scarlet_shadow_kimono_skin_dead",
		DetailMedia = { Poster = "ui/valkyries/detail/scarlet_shadow_kimono_skin_poster.jpg", Video = "ui/valkyries/detail/scarlet_shadow_kimono_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	texas_omertosa_skin = {
		ID = "texas_omertosa_skin",
		Name = "$bv{skin.texas_omertosa_skin.name}",
		Description = "$bv{skin.texas_omertosa_skin.description}",
		Brush = "bust_bv_texas_omertosa_skin",
		DeathBrush = "bust_bv_texas_omertosa_skin_dead",
		WorldLeaderBrush = "world_bv_texas_omertosa_leader",
		TabName = "$bv{skin.texas_omertosa_skin.tab_name}",
		Portrait = "ui/valkyries/texas_omertosa_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/texas_omertosa_poster.jpg",
			Video = "ui/valkyries/detail/texas_omertosa_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/texas_omertosa_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/texas_omertosa_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/texas_omertosa_skin_icon.png"
	},
	sparxie_skin = {
		ID = "sparxie_skin",
		Name = "$bv{skin.sparxie_skin.name}",
		Brush = "bust_bv_sparxie_skin",
		DeathBrush = "bust_bv_sparxie_skin_dead",
		TabName = "$bv{skin.sparxie_skin.tab_name}",
		Portrait = "ui/valkyries/sparxie_card.png",
		Preview = "ui/valkyries/sparxie_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/sparxie_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/sparxie_skin_icon.png",
		DetailMedia = { Poster = "ui/valkyries/detail/sparxie_skin_poster.jpg", Video = "ui/valkyries/detail/sparxie_skin_idle.webm", PositionX = 0.35, PositionY = 0.10 }
	},
	the_herta_skin = {
		ID = "the_herta_skin",
		Name = "$bv{skin.the_herta_skin.name}",
		Description = "$bv{skin.the_herta_skin.description}",
		Brush = "bust_bv_the_herta_skin",
		DeathBrush = "bust_bv_the_herta_skin_dead",
		TabName = "$bv{skin.the_herta_skin.tab_name}",
		Portrait = "ui/valkyries/the_herta_card.png",
		DetailMedia = {
			Poster = "ui/valkyries/detail/the_herta_skin_poster.jpg",
			Video = "ui/valkyries/detail/the_herta_skin_idle.webm",
			PositionX = 0.30,
			PositionY = 0.10
		},
		Preview = "ui/valkyries/the_herta_skin_preview.png",
		TraitIcon = "ui/traits/$bvvar{iconPrefix}/the_herta_trait_icon.png",
		ItemIcon = "$bvvar{iconPrefix}/the_herta_skin_icon.png"
	}
};

::$bvvar{namespace}.getSettingValue <- function( _id )
{
	if (::$bvvar{namespace}.Mod != null && ::$bvvar{namespace}.Mod.ModSettings.hasSetting(_id))
	{
		return ::$bvvar{namespace}.Mod.ModSettings.getSetting(_id).getValue();
	}

	return (_id in ::$bvvar{namespace}.Settings) ? ::$bvvar{namespace}.Settings[_id] : null;
};

::$bvvar{namespace}.log <- function( _message )
{
	if (_message == null)
	{
		return;
	}

	local isDeathFix = _message.find("[DeathFix]") == 0;
	local isDeathDrop = _message.find("[DeathDrop]") == 0;
	local isSkillDebug = _message.find("[SkillDebug]") == 0;
	local isSaveCompat = _message.find("[SaveCompat]") == 0;

	if (!isDeathFix
		&& !isDeathDrop
		&& (!isSkillDebug || !::$bvvar{namespace}.getSettingValue("DebugSkills"))
		&& (!isSaveCompat || !::$bvvar{namespace}.getSettingValue("DebugSaveCompat"))
		&& (isSkillDebug || isSaveCompat || !::$bvvar{namespace}.getSettingValue("DebugSkin")))
	{
		return;
	}

	try
	{
		::logInfo("[Battle Valkyries] " + _message);
	}
	catch (e)
	{
	}
};

::$bvvar{namespace}.getSkin <- function( _skinID )
{
	return _skinID in ::$bvvar{namespace}.Skins ? ::$bvvar{namespace}.Skins[_skinID] : null;
};

::$bvvar{namespace}.ValkyrieSkinItemCarrierScript <- "scripts/items/misc/snake_oil_item";
::$bvvar{namespace}.ValkyrieSkinItemFlag <- "$bvvar{itemFlag}";
::$bvvar{namespace}.ValkyrieSkinItemValkyrieIDFlag <- "$bvvar{itemFlag}.ValkyrieID";
::$bvvar{namespace}.ValkyrieSkinItemSkinIDFlag <- "$bvvar{itemFlag}.SkinID";

::$bvvar{namespace}.getItemFlags <- function( _item )
{
	if (_item == null || _item == -1)
	{
		return null;
	}

	try
	{
		return _item.getFlags();
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.getValkyrieSkinItemData <- function( _item )
{
	local flags = ::$bvvar{namespace}.getItemFlags(_item);

	if (flags == null || !flags.has(::$bvvar{namespace}.ValkyrieSkinItemFlag))
	{
		return null;
	}

	local valkyrieID = flags.get(::$bvvar{namespace}.ValkyrieSkinItemValkyrieIDFlag);
	local skinID = flags.get(::$bvvar{namespace}.ValkyrieSkinItemSkinIDFlag);

	if (valkyrieID == false)
	{
		valkyrieID = "";
	}

	if (skinID == false)
	{
		skinID = "";
	}

	if ((skinID == null || skinID == "") && valkyrieID != null && valkyrieID != "")
	{
		local template = ::$bvvar{namespace}.getValkyrieByID(valkyrieID);

		if (template != null && "SkinID" in template)
		{
			skinID = template.SkinID;
		}
	}

	return {
		ValkyrieID = valkyrieID == null ? "" : valkyrieID,
		SkinID = skinID == null ? "" : skinID
	};
};

::$bvvar{namespace}.isValkyrieSkinItem <- function( _item )
{
	local data = ::$bvvar{namespace}.getValkyrieSkinItemData(_item);
	return data != null && data.SkinID != null && data.SkinID != "" && ::$bvvar{namespace}.getSkin(data.SkinID) != null;
};

::$bvvar{namespace}.refreshValkyrieSkinItemDisplay <- function( _item )
{
	local data = ::$bvvar{namespace}.getValkyrieSkinItemData(_item);

	if (data == null)
	{
		return false;
	}

	local template = ::$bvvar{namespace}.getValkyrieByID(data.ValkyrieID);
	local skin = ::$bvvar{namespace}.getSkin(data.SkinID);
	local displayName = template != null ? ::$bvvar{namespace}.getValkyrieSkinItemBaseName(template, data.SkinID) : (skin != null ? skin.Name : "$bv{item.valkyrie_skin.fallback_name}");
	local skinItemIcon = data.ValkyrieID != null && data.ValkyrieID != "" ? "$bvvar{iconPrefix}/" + data.ValkyrieID + "_skin_icon.png" : "$bvvar{iconPrefix}/valkyries_hub_icon.png";

	if (template != null)
	{
		skinItemIcon = ::$bvvar{namespace}.getValkyrieSkinItemIconPath(template, data.SkinID);
	}

	try
	{
		_item.m.ID = "$bvvar{itemIdPrefix}.valkyrie_skin_item";
		_item.m.Name = displayName + "$bv{item.valkyrie_skin.name_suffix}";
		_item.m.Description = "$bv{item.valkyrie_skin.description_prefix}" + displayName + "$bv{item.valkyrie_skin.description_suffix}";
		_item.m.Categories = "$bv{item.valkyrie_skin.category}";
		_item.m.Icon = skinItemIcon;
		_item.m.IconLarge = _item.m.Icon;
		_item.m.SlotType = ::Const.ItemSlot.None;
		_item.m.ItemType = ::Const.Items.ItemType.Usable;
		_item.m.IsAllowedInBag = false;
		_item.m.IsDroppedAsLoot = false;
		_item.m.IsSellable = false;
		_item.m.IsUsable = true;
		_item.m.Value = 0;
	}
	catch (e)
	{
		return false;
	}

	return true;
};

::$bvvar{namespace}.markValkyrieSkinItem <- function( _item, _valkyrieID, _skinID )
{
	local flags = ::$bvvar{namespace}.getItemFlags(_item);

	if (flags == null)
	{
		return false;
	}

	flags.set(::$bvvar{namespace}.ValkyrieSkinItemFlag, true);
	flags.set(::$bvvar{namespace}.ValkyrieSkinItemValkyrieIDFlag, _valkyrieID == null ? "" : _valkyrieID);
	flags.set(::$bvvar{namespace}.ValkyrieSkinItemSkinIDFlag, _skinID == null ? "" : _skinID);
	return ::$bvvar{namespace}.refreshValkyrieSkinItemDisplay(_item);
};

::$bvvar{namespace}.getValkyrieSkinItemTooltip <- function( _item )
{
	::$bvvar{namespace}.refreshValkyrieSkinItemDisplay(_item);

	return [
		{
			id = 1,
			type = "title",
			text = _item.getName()
		},
		{
			id = 2,
			type = "description",
			text = _item.getDescription()
		},
		{
			id = 3,
			type = "image",
			image = _item.getIconLarge() != null ? _item.getIconLarge() : _item.getIcon(),
			isLarge = true
		},
		{
			id = 4,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.valkyrie_skin.tooltip.apply}"
		},
		{
			id = 5,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.valkyrie_skin.tooltip.hide_weapons}"
		},
		{
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "$bv{item.valkyrie_skin.tooltip.replace}"
		}
	];
};
