::$bvvar{namespace}.ValkyrieOrder.push("fate_harlaown");
::$bvvar{namespace}.Valkyries.fate_harlaown <- {
 ID = "fate_harlaown", LegendsPerkProfile = "melee_mobile", SkinID = "fate_harlaown_skin", SkinIDs = ["fate_harlaown_skin"],
 Name = "$bv{valkyrie.fate_harlaown.name}", Portrait = "ui/valkyries/fate_harlaown_card.png", WorldLeaderBrush = "world_bv_fate_harlaown_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/fate_harlaown_background", BackgroundID = "$bvvar{modId}.background.fate_harlaown",
 BackgroundName = "$bv{valkyrie.fate_harlaown.background.name}", BackgroundDescription = "$bv{valkyrie.fate_harlaown.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/fate_harlaown_trait", TraitID = "$bvvar{modId}.trait.fate_harlaown",
 TraitName = "$bv{valkyrie.fate_harlaown.trait.name}", TraitDescription = "$bv{valkyrie.fate_harlaown.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/fate_harlaown_trait_icon.png",
 Level = 1, XP = 0, DailyWage = 1,
 BaseAttributes = { Hitpoints = 80, Bravery = 70, Stamina = 140, MeleeSkill = 85, RangedSkill = 80, MeleeDefense = 20, RangedDefense = 15, Initiative = 120 },
 AttributeAdjustments = { Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0] },
 Talents = { Hitpoints=2,Bravery=3,Stamina=3,MeleeSkill=3,RangedSkill=2,MeleeDefense=1,RangedDefense=2,Initiative=2 },
 SkillLoadout = ["fate_lightning", "fate_scythe", "fate_move", "fate_lancer", "fate_form"], Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon="fate_lightning",Name="$bv{skill.fate_lightning.name}",Description="$bv{skill.fate_lightning.description}" },
  Active = { Icon="fate_form",Name="$bv{fate_harlaown.actives}",Description="$bv{skill.fate_scythe.name}: $bv{skill.fate_scythe.description}\n$bv{skill.fate_move.name}: $bv{skill.fate_move.description}\n$bv{skill.fate_lancer.name}: $bv{skill.fate_lancer.description}\n$bv{skill.fate_form.name}: $bv{skill.fate_form.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.fate_harlaown <- { TraitTooltip="$bv{valkyrie.fate_harlaown.trait.tooltip}",TraitBonuses={} };
::$bvvar{namespace}.Skins.fate_harlaown_skin <- {
 ID="fate_harlaown_skin",Name="$bv{skin.fate_harlaown_skin.name}",TabName="$bv{skin.fate_harlaown_skin.name}",Description="$bv{skin.fate_harlaown_skin.description}",
 Brush="bust_bv_fate_harlaown_skin",DeathBrush="bust_bv_fate_harlaown_skin_dead",WorldLeaderBrush="world_bv_fate_harlaown_leader",
 Portrait="ui/valkyries/fate_harlaown_card.png",Preview="ui/valkyries/fate_harlaown_skin_preview.png",
 DetailMedia={Poster="ui/valkyries/detail/fate_harlaown_skin_poster.jpg",Video="ui/valkyries/detail/fate_harlaown_skin_idle.webm",PositionX=0.30,PositionY=0.25},
 TraitIcon="ui/traits/$bvvar{iconPrefix}/fate_harlaown_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/fate_harlaown_skin_icon.png"
};
