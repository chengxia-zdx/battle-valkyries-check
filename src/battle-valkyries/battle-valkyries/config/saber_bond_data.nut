::$bvvar{namespace}.SaberBondStages <- [
	{
		Value = 20, Name = "$bv{event.saber_bond.20.name}", Title = "$bv{event.saber_bond.20.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_20_intro.png", CGImage = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_20_cg.png",
		Text = "$bv{event.saber_bond.20.text}", RevealText = "$bv{event.saber_bond.20.reveal}", VictoryText = "$bv{event.saber_bond.20.victory}",
		RevealOption = "$bv{event.saber_bond.20.option}", ChallengeOption = "$bv{event.saber_bond.20.challenge_option}", RewardText = "$bv{event.saber_bond.20.reward}",
		LocationName = "$bv{location.saber_bond.20.name}", LocationDescription = "$bv{location.saber_bond.20.description}",
		Brush = "world_bandit_camp_01", Template = "tactical.human_camp",
		Troops = [["BanditRaider", 5, 1], ["BanditMarksman", 2, 0], ["BanditLeader", 1, 0]],
		Item = null, Money = 0, Tools = 0, Medicine = 0
	},
	{
		Value = 40, Name = "$bv{event.saber_bond.40.name}", Title = "$bv{event.saber_bond.40.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_40_intro.png", CGImage = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_40_cg.png",
		Text = "$bv{event.saber_bond.40.text}", RevealText = "$bv{event.saber_bond.40.reveal}", VictoryText = "$bv{event.saber_bond.40.victory}",
		RevealOption = "$bv{event.saber_bond.40.option}", ChallengeOption = "$bv{event.saber_bond.40.challenge_option}", RewardText = "$bv{event.saber_bond.40.reward}",
		LocationName = "$bv{location.saber_bond.40.name}", LocationDescription = "$bv{location.saber_bond.40.description}",
		Brush = "world_bandit_camp_01", Template = "tactical.human_camp",
		Troops = [["BanditRaider", 6, 1], ["BanditMarksman", 2, 2], ["BanditLeader", 1, 0]],
		Item = null, Money = 1000, Tools = 30, Medicine = 0
	},
	{
		Value = 60, Name = "$bv{event.saber_bond.60.name}", Title = "$bv{event.saber_bond.60.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_60_intro.png", CGImage = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_60_cg.png",
		Text = "$bv{event.saber_bond.60.text}", RevealText = "$bv{event.saber_bond.60.reveal}", VictoryText = "$bv{event.saber_bond.60.victory}",
		RevealOption = "$bv{event.saber_bond.60.option}", ChallengeOption = "$bv{event.saber_bond.60.challenge_option}", RewardText = "$bv{event.saber_bond.60.reward}",
		LocationName = "$bv{location.saber_bond.60.name}", LocationDescription = "$bv{location.saber_bond.60.description}",
		Brush = "world_bandit_camp_01", Template = "tactical.human_camp",
		Troops = [["BanditRaider", 6, 1], ["BanditLeader", 2, 2], ["HedgeKnight", 1, 0]],
		Item = "scripts/items/weapons/battle_valkyries/saber_oath_excalibur", Money = 0, Tools = 0, Medicine = 0
	},
	{
		Value = 80, Name = "$bv{event.saber_bond.80.name}", Title = "$bv{event.saber_bond.80.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_80_intro.png", CGImage = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_80_cg.png",
		Text = "$bv{event.saber_bond.80.text}", RevealText = "$bv{event.saber_bond.80.reveal}", VictoryText = "$bv{event.saber_bond.80.victory}",
		RevealOption = "$bv{event.saber_bond.80.option}", ChallengeOption = "$bv{event.saber_bond.80.challenge_option}", RewardText = "$bv{event.saber_bond.80.reward}",
		LocationName = "$bv{location.saber_bond.80.name}", LocationDescription = "$bv{location.saber_bond.80.description}",
		Brush = "world_ruins_01", Template = "tactical.ruins",
		Troops = [["BanditRaider", 6, 1], ["Swordmaster", 1, 2], ["HedgeKnight", 1, 0]],
		Item = null, Money = 1500, Tools = 0, Medicine = 30
	},
	{
		Value = 100, Name = "$bv{event.saber_bond.100.name}", Title = "$bv{event.saber_bond.100.title}",
		Image = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_100_intro.png", CGImage = "gfx/ui/events/$bvvar{iconPrefix}/saber_bond_100_cg.png",
		Text = "$bv{event.saber_bond.100.text}", RevealText = "$bv{event.saber_bond.100.reveal}", VictoryText = "$bv{event.saber_bond.100.victory}",
		RevealOption = "$bv{event.saber_bond.100.option}", ChallengeOption = "$bv{event.saber_bond.100.challenge_option}", RewardText = "$bv{event.saber_bond.100.reward}",
		LocationName = "$bv{location.saber_bond.100.name}", LocationDescription = "$bv{location.saber_bond.100.description}",
		Brush = "world_ruins_01", Template = "tactical.ruins",
		Troops = [["SkeletonLight", 3, 1], ["SkeletonMedium", 5, 1], ["SkeletonMediumPolearm", 2, 0], ["SkeletonHeavy", 2, 2]],
		Item = null, Money = 0, Tools = 0, Medicine = 0
	},
];

::$bvvar{namespace}.ValkyrieSkillCatalog.saber_mana_release <- {
 RuntimeScript = "$bvvar{privateFolder}/skills/actives/saber_mana_release_skill",
 Name = "$bv{skill.saber_mana_release.name}", Description = "$bv{skill.saber_mana_release.description}",
 Icon = "saber_mana_release", Kind = "active", Lifetime = "persistent", Learnable = false,
 Tags = ["saber_full_bond"], Requirements = { MinLevel = 1, RequiredSkills = [], ForbiddenSkills = [] }, Spec = {}
};
::$bvvar{namespace}.Valkyries.saber.SkillLoadout.push("saber_mana_release");
::$bvvar{namespace}.Skins.saber_royal_bunny_skin <- {
 ID="saber_royal_bunny_skin", ValkyrieID="saber", IsOriginal=false, UnlockSaberBond=100,
 Name="$bv{skin.saber_royal_bunny_skin.name}", TabName="$bv{skin.saber_royal_bunny_skin.tab_name}", Description="$bv{skin.saber_royal_bunny_skin.description}",
 Brush="bust_bv_saber_royal_bunny_skin", DeathBrush="bust_bv_saber_royal_bunny_skin_dead", WorldLeaderBrush="world_bv_saber_royal_bunny_leader",
 Portrait="ui/valkyries/saber_royal_bunny_card.png", Preview="ui/valkyries/saber_royal_bunny_skin_preview.png",
 TraitIcon="ui/traits/$bvvar{iconPrefix}/saber_bond_trait.png", ItemIcon="$bvvar{iconPrefix}/saber_royal_bunny_skin_icon.png",
 DetailMedia={Poster="ui/valkyries/detail/saber_royal_bunny_skin_poster.jpg",Video="ui/valkyries/detail/saber_royal_bunny_skin_idle.webm",PositionX=0.5,PositionY=0.15}
};
if (!("SkinIDs" in ::$bvvar{namespace}.Valkyries.saber)) ::$bvvar{namespace}.Valkyries.saber.SkinIDs <- ["saber_skin"];
::$bvvar{namespace}.Valkyries.saber.SkinIDs.push("saber_royal_bunny_skin");
