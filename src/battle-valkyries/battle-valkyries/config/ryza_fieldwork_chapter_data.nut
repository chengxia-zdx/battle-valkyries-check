// Fixed supplies are delivered from the cycle ledger, never random beast drops.
local bv = ::$bvvar{namespace};
bv.RyzaFieldRewards <- {
 wolf = { Item = "accessory.warwolf", Script = "scripts/items/accessory/wolf_item", Name = "$bv{chapter.ryza_fieldwork.wolf}" },
 werewolf_pelt = { Item = "misc.werewolf_pelt", Script = "scripts/items/misc/werewolf_pelt_item", Name = "$bv{ryza.material.werewolf_pelt}" },
 adrenaline_gland = { Item = "misc.adrenaline_gland", Script = "scripts/items/misc/adrenaline_gland_item", Name = "$bv{ryza.material.adrenaline_gland}" },
 hyena_fur = { Item = "misc.hyena_fur", Script = "scripts/items/misc/hyena_fur_item", Name = "$bv{ryza.material.hyena_fur}" },
 spider_silk = { Item = "misc.spider_silk", Script = "scripts/items/misc/spider_silk_item", Name = "$bv{ryza.material.spider_silk}" },
 poison_gland = { Item = "misc.poison_gland", Script = "scripts/items/misc/poison_gland_item", Name = "$bv{ryza.material.poison_gland}" },
 unhold_hide = { Item = "misc.unhold_hide", Script = "scripts/items/misc/unhold_hide_item", Name = "$bv{ryza.material.unhold_hide}" },
 unhold_bones = { Item = "misc.unhold_bones", Script = "scripts/items/misc/unhold_bones_item", Name = "$bv{ryza.material.unhold_bones}" },
 unhold_heart = { Item = "misc.unhold_heart", Script = "scripts/items/misc/unhold_heart_item", Name = "$bv{ryza.material.unhold_heart}" },
 lindwurm_bones = { Item = "misc.lindwurm_bones", Script = "scripts/items/misc/lindwurm_bones_item", Name = "$bv{ryza.material.lindwurm_bones}" },
 lindwurm_scales = { Item = "misc.lindwurm_scales", Script = "scripts/items/misc/lindwurm_scales_item", Name = "$bv{ryza.material.lindwurm_scales}" },
};
bv.ChapterDefinitions.ryza_fieldwork <- {
 ID = "ryza_fieldwork", Repeatable = true,
 Name = "$bv{chapter.ryza_fieldwork.name}", Description = "$bv{chapter.ryza_fieldwork.description}",
 Poster = "ui/chapters/ryza_fieldwork/cover.jpg", Actors = ["ryza"], PortraitOrder = [], Portraits = {}, Videos = {},
 LocationScript = "scripts/entity/world/locations/battle_valkyries/ryza_fieldwork_chapter_location",
 Difficulties = [
  { ID = "rescue", Name = "$bv{chapter.ryza_fieldwork.rescue}", Brief = "$bv{chapter.ryza_fieldwork.rescue.brief}", EnemyText = "$bv{chapter.ryza_fieldwork.rescue.enemies}", Troops = [["BanditRaider", 8], ["BanditMarksman", 2]], Rewards = [{ Key = "wolf", Count = 1 }] },
  { ID = "hunt", Name = "$bv{chapter.ryza_fieldwork.hunt}", Brief = "$bv{chapter.ryza_fieldwork.hunt.brief}", EnemyText = "$bv{chapter.ryza_fieldwork.hunt.enemies}", Troops = [["Direwolf", 6], ["Hyena", 4]], Rewards = [{ Key = "werewolf_pelt", Count = 4 }, { Key = "adrenaline_gland", Count = 4 }, { Key = "hyena_fur", Count = 4 }] },
  { ID = "silk", Name = "$bv{chapter.ryza_fieldwork.silk}", Brief = "$bv{chapter.ryza_fieldwork.silk.brief}", EnemyText = "$bv{chapter.ryza_fieldwork.silk.enemies}", Troops = [["Spider", 12]], Rewards = [{ Key = "spider_silk", Count = 6 }, { Key = "poison_gland", Count = 4 }] },
  { ID = "giants", Name = "$bv{chapter.ryza_fieldwork.giants}", Brief = "$bv{chapter.ryza_fieldwork.giants.brief}", EnemyText = "$bv{chapter.ryza_fieldwork.giants.enemies}", Troops = [["Unhold", 3]], Rewards = [{ Key = "unhold_hide", Count = 4 }, { Key = "unhold_bones", Count = 4 }, { Key = "unhold_heart", Count = 3 }] },
  { ID = "dragon", Name = "$bv{chapter.ryza_fieldwork.dragon}", Brief = "$bv{chapter.ryza_fieldwork.dragon.brief}", EnemyText = "$bv{chapter.ryza_fieldwork.dragon.enemies}", Troops = [["Lindwurm", 2]], Rewards = [{ Key = "lindwurm_bones", Count = 2 }, { Key = "lindwurm_scales", Count = 2 }] },
 ],
 Nodes = { fieldsite = { Name = "$bv{chapter.ryza_fieldwork.location}", Brush = "world_bandit_camp_01", Battle = true } },
 Scenes = {
  opening = { Title = "$bv{chapter.ryza_fieldwork.opening}", Background = "ui/chapters/ryza_fieldwork/journal.jpg", Video = "", Lines = [
   { Speaker = "narrator", Text = "$bv{chapter.ryza_fieldwork.opening.1}" },
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.opening.2}" },
   { Speaker = "narrator", Text = "$bv{chapter.ryza_fieldwork.opening.3}" },
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.opening.4}" },
  ] },
  guard = { Title = "$bv{chapter.ryza_fieldwork.guard}", Background = "ui/chapters/ryza_fieldwork/journal.jpg", Video = "", Lines = [
   { Speaker = "narrator", Text = "$bv{chapter.ryza_fieldwork.guard.1}" },
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.guard.2}" },
  ] },
  ending = { Title = "$bv{chapter.ryza_fieldwork.ending}", Background = "ui/chapters/ryza_fieldwork/workshop.jpg", Video = "", Lines = [
   { Speaker = "narrator", Text = "$bv{chapter.ryza_fieldwork.ending.1}" },
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.ending.2}" },
  ] },
  rescue_scene = { Title = "$bv{chapter.ryza_fieldwork.rescue_scene}", Background = "ui/chapters/ryza_fieldwork/rescue.jpg", Video = "", Lines = [
   { Speaker = "narrator", Text = "$bv{chapter.ryza_fieldwork.rescue_scene.1}" },
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.rescue_scene.2}" },
  ] },
  repeat = { Title = "$bv{chapter.ryza_fieldwork.guard}", Background = "ui/chapters/ryza_fieldwork/journal.jpg", Video = "", Lines = [
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.repeat}" },
  ] },
  delivery = { Title = "$bv{chapter.ryza_fieldwork.ending}", Background = "ui/chapters/ryza_fieldwork/workshop.jpg", Video = "", Lines = [
   { Speaker = "ryza", Text = "$bv{chapter.ryza_fieldwork.delivery}" },
  ] },
 },
 Stages = [{ ID = "fieldwork", Name = "$bv{chapter.ryza_fieldwork.stage}", Brief = "$bv{chapter.ryza_fieldwork.rules}", Scene = "ending",
  Money = 0, Tools = 0, Medicine = 0, PerksEach = 0, Special = "", Materials = [], Goals = [{Key = "field_victory", Node = "fieldsite", Name = "$bv{chapter.ryza_fieldwork.stage}", Battle = true}] }],
 Gallery = [
  { ID = "journal", Stage = 1, Title = "$bv{chapter.ryza_fieldwork.opening}", Caption = "$bv{chapter.ryza_fieldwork.cg.journal}", Image = "ui/chapters/ryza_fieldwork/journal.jpg" },
  { ID = "rescue", Stage = 1, Title = "$bv{chapter.ryza_fieldwork.rescue_scene}", Caption = "$bv{chapter.ryza_fieldwork.cg.rescue}", Image = "ui/chapters/ryza_fieldwork/rescue.jpg" },
  { ID = "workshop", Stage = 1, Title = "$bv{chapter.ryza_fieldwork.ending}", Caption = "$bv{chapter.ryza_fieldwork.cg.workshop}", Image = "ui/chapters/ryza_fieldwork/workshop.jpg" }
 ]
};
