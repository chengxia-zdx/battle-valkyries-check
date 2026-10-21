::$bvvar{namespace}.ValkyrieOrder.push("si");
::$bvvar{namespace}.Valkyries.si <- {
 ID = "si", LegendsPerkProfile = "ranged_support", SkinID = "si_skin", SkinIDs = ["si_skin"],
 Name = "$bv{valkyrie.si.name}", Portrait = "ui/valkyries/si_card.png", WorldLeaderBrush = "world_bv_si_leader",
 BackgroundScript = "scripts/skills/backgrounds/battle_valkyries/si_background", BackgroundID = "$bvvar{modId}.background.si",
 BackgroundName = "$bv{valkyrie.si.background.name}", BackgroundDescription = "$bv{valkyrie.si.background.description}",
 TraitScript = "scripts/skills/traits/battle_valkyries/si_trait", TraitID = "$bvvar{modId}.trait.si",
 TraitName = "$bv{valkyrie.si.trait.name}", TraitDescription = "$bv{valkyrie.si.trait.description}", TraitIcon = "ui/traits/$bvvar{iconPrefix}/si_trait_icon.png",
 Level = 1, XP = 0, DailyWage = 1,
 BaseAttributes = { Hitpoints = 90, Bravery = 90, Stamina = 135, MeleeSkill = 55, RangedSkill = 85, MeleeDefense = 15, RangedDefense = 20, Initiative = 110 },
 AttributeAdjustments = { Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0] },
 Talents = { Hitpoints=2,Bravery=3,Stamina=3,MeleeSkill=0,RangedSkill=3,MeleeDefense=1,RangedDefense=2,Initiative=2 },
 SkillLoadout = ["si_myriad", "si_brush", "si_landscape", "si_sanctuary", "si_dragon"], Equipment = {}, Quests = [],
 HubDetails = {
  Passive = { Icon="si_myriad",Name="$bv{skill.si_myriad.name}",Description="$bv{skill.si_myriad.description}" },
  Active = { Icon="si_dragon",Name="$bv{si.actives}",Description="$bv{skill.si_brush.name}: $bv{skill.si_brush.description}\n$bv{skill.si_landscape.name}: $bv{skill.si_landscape.description}\n$bv{skill.si_sanctuary.name}: $bv{skill.si_sanctuary.description}\n$bv{skill.si_dragon.name}: $bv{skill.si_dragon.description}" }
 }
};
::$bvvar{namespace}.ValkyrieTraitData.si <- { TraitTooltip="$bv{valkyrie.si.trait.tooltip}",TraitBonuses={} };
::$bvvar{namespace}.Skins.si_skin <- {
 ID="si_skin",Name="$bv{skin.si_skin.name}",TabName="$bv{skin.si_skin.name}",Description="$bv{skin.si_skin.description}",
 Brush="bust_bv_si_skin",DeathBrush="bust_bv_si_skin_dead",WorldLeaderBrush="world_bv_si_leader",
 Portrait="ui/valkyries/si_card.png",Preview="ui/valkyries/si_skin_preview.png",
 TraitIcon="ui/traits/$bvvar{iconPrefix}/si_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/si_skin_icon.png",
 DetailMedia={Poster="ui/valkyries/detail/si_skin_poster.jpg",Video="ui/valkyries/detail/si_skin_idle.webm",PositionX=0.30,PositionY=0.25}
};
