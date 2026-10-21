::$bvvar{namespace}.ValkyrieOrder.push("aemeath");
::$bvvar{namespace}.Valkyries.aemeath <- {
 ID="aemeath", LegendsPerkProfile="melee_mobile", SkinID="aemeath_skin", SkinIDs=["aemeath_skin"],
 Name="$bv{valkyrie.aemeath.name}", Portrait="ui/valkyries/aemeath_card.png", WorldLeaderBrush="world_bv_aemeath_leader",
 BackgroundScript="scripts/skills/backgrounds/battle_valkyries/aemeath_background", BackgroundID="$bvvar{modId}.background.aemeath", BackgroundName="$bv{valkyrie.aemeath.background.name}", BackgroundDescription="$bv{valkyrie.aemeath.background.description}",
 TraitScript="scripts/skills/traits/battle_valkyries/aemeath_trait", TraitID="$bvvar{modId}.trait.aemeath", TraitName="$bv{valkyrie.aemeath.trait.name}", TraitDescription="$bv{valkyrie.aemeath.trait.description}", TraitIcon="ui/traits/$bvvar{iconPrefix}/aemeath_trait_icon.png",
 Level=1,XP=0,DailyWage=1,
 BaseAttributes={Hitpoints=65,Bravery=60,Stamina=110,MeleeSkill=65,RangedSkill=50,MeleeDefense=15,RangedDefense=10,Initiative=110},
 AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
 Talents={Hitpoints=2,Bravery=3,Stamina=2,MeleeSkill=3,RangedSkill=3,MeleeDefense=2,RangedDefense=1,Initiative=1},
 SkillLoadout=["aemeath_voyage","aemeath_interference","aemeath_trajectory","aemeath_starlight","aemeath_armament","aemeath_melody","aemeath_dawn","aemeath_ultimate"],Equipment={},Quests=[],
 HubDetails={Passive={Icon="aemeath_voyage",Name="$bv{skill.aemeath_voyage.name}",Description="$bv{skill.aemeath_voyage.description}\n$bv{skill.aemeath_interference.description}\n$bv{skill.aemeath_trajectory.description}"},Active={Icon="aemeath_ultimate",Name="$bv{aemeath.skills}",Description="$bv{skill.aemeath_starlight.description}\n$bv{skill.aemeath_armament.description}\n$bv{skill.aemeath_melody.description}\n$bv{skill.aemeath_dawn.description}\n$bv{skill.aemeath_ultimate.description}"}}
};
::$bvvar{namespace}.ValkyrieTraitData.aemeath <- {TraitTooltip="$bv{valkyrie.aemeath.trait.tooltip}",TraitBonuses={MeleeSkill=20,Bravery=20,Initiative=15,ActionPoints=5}};
::$bvvar{namespace}.Skins.aemeath_skin <- {ID="aemeath_skin",Name="$bv{skin.aemeath_skin.name}",TabName="$bv{skin.aemeath_skin.name}",Description="$bv{skin.aemeath_skin.description}",Brush="bust_bv_aemeath_skin",DeathBrush="bust_bv_aemeath_skin_dead",WorldLeaderBrush="world_bv_aemeath_leader",Portrait="ui/valkyries/aemeath_card.png",Preview="ui/valkyries/aemeath_skin_preview.png",TraitIcon="ui/traits/$bvvar{iconPrefix}/aemeath_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/aemeath_skin_icon.png"};
::$bvvar{namespace}.Skins.aemeath_mech_skin <- {ID="aemeath_mech_skin",Name="$bv{skin.aemeath_mech_skin.name}",TabName="$bv{skin.aemeath_mech_skin.name}",Description="$bv{skin.aemeath_mech_skin.description}",Brush="bust_bv_aemeath_mech_skin",DeathBrush="bust_bv_aemeath_mech_skin_dead",WorldLeaderBrush="world_bv_aemeath_mech_leader",Portrait="ui/valkyries/aemeath_card.png",Preview="ui/valkyries/aemeath_mech_skin_preview.png",TraitIcon="ui/traits/$bvvar{iconPrefix}/aemeath_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/aemeath_mech_skin_icon.png"};
::$bvvar{namespace}.Skins.aemeath_skin.DetailMedia <- {Poster="ui/valkyries/detail/aemeath_skin_poster.jpg",Video="ui/valkyries/detail/aemeath_skin_idle.webm",PositionX=0.30,PositionY=0.25};
