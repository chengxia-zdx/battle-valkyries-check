::$bvvar{namespace}.ChapterDefinitions.shu_granary <- {
	ID = "shu_granary", Repeatable = true,
	Name = "$bv{chapter.shu_granary.name}", Description = "$bv{chapter.shu_granary.description}",
	Poster = "ui/chapters/shu_granary/cover.jpg", Actors = ["shu"], PortraitOrder = [], Portraits = {}, Videos = {},
	LocationScript = "scripts/entity/world/locations/battle_valkyries/shu_granary_chapter_location",
	Difficulties = [
		{ ID = "easy", Name = "$bv{chapter.shu_granary.easy}", Minimum = 600, Days = 1.5, Troops = [["BanditThug", 8]] },
		{ ID = "normal", Name = "$bv{chapter.shu_granary.normal}", Minimum = 1200, Days = 3.0, Troops = [["BanditRaider", 8], ["BanditThug", 2], ["BanditMarksman", 2]] },
		{ ID = "hard", Name = "$bv{chapter.shu_granary.hard}", Minimum = 1800, Days = 4.5, Troops = [["BanditRaider", 13], ["BanditMarksman", 4], ["BanditLeader", 1]] }
	],
	Nodes = { granary = { Name = "$bv{chapter.shu_granary.location}", Brush = "world_bandit_camp_01", Battle = true } },
	Scenes = {
		opening = { Title = "$bv{chapter.shu_granary.opening}", Background = "ui/chapters/shu_granary/fields.jpg", Video = "", Lines = [
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.opening.1}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.opening.2}" },
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.opening.3}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.opening.4}" },
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.opening.5}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.opening.6}" }
		] },
		guard = { Title = "$bv{chapter.shu_granary.guard}", Background = "ui/chapters/shu_granary/guard.jpg", Video = "", Lines = [
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.guard.1}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.guard.2}" },
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.guard.3}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.guard.4}" }
		] },
		ending = { Title = "$bv{chapter.shu_granary.ending}", Background = "ui/chapters/shu_granary/meal.jpg", Video = "", Lines = [
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.ending.1}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.ending.2}" },
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.ending.3}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.ending.4}" },
			{ Speaker = "narrator", Text = "$bv{chapter.shu_granary.ending.5}" },
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.ending.6}" }
		] },
		delivery = { Title = "$bv{chapter.shu_granary.ending}", Background = "ui/chapters/shu_granary/meal.jpg", Video = "", Lines = [
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.delivery}" }
		] },
		repeat = { Title = "$bv{chapter.shu_granary.guard}", Background = "ui/chapters/shu_granary/guard.jpg", Video = "", Lines = [
			{ Speaker = "shu", Text = "$bv{chapter.shu_granary.repeat}" }
		] }
	},
	Stages = [{ ID = "guard_the_granary", Name = "$bv{chapter.shu_granary.guard}", Brief = "$bv{chapter.shu_granary.rules}", Scene = "ending",
		Money = 0, Tools = 0, Medicine = 0, PerksEach = 0, Special = "", Materials = [], Goals = [{Key = "granary_victory", Node = "granary", Name = "$bv{chapter.shu_granary.guard}", Battle = true}] }],
	Gallery = [
		{ ID = "fields", Stage = 1, Title = "$bv{chapter.shu_granary.opening}", Caption = "$bv{chapter.shu_granary.cg.fields}", Image = "ui/chapters/shu_granary/fields.jpg" },
		{ ID = "guard", Stage = 1, Title = "$bv{chapter.shu_granary.guard}", Caption = "$bv{chapter.shu_granary.cg.guard}", Image = "ui/chapters/shu_granary/guard.jpg" },
		{ ID = "meal", Stage = 1, Title = "$bv{chapter.shu_granary.ending}", Caption = "$bv{chapter.shu_granary.cg.meal}", Image = "ui/chapters/shu_granary/meal.jpg" }
	]
};
