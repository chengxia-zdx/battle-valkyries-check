local bv=::$bvvar{namespace};
bv.ValkyrieOrder.push("es");
bv.Valkyries.es <- {
 ID="es",LegendsPerkProfile="melee_mobile",SkinID="es_skin",SkinIDs=["es_skin"],Name="$bv{es.name}",
 Portrait="ui/valkyries/es_card.png",WorldLeaderBrush="world_bv_es_leader",
 BackgroundScript="scripts/skills/backgrounds/battle_valkyries/es_background",BackgroundID="$bvvar{modId}.background.es",
 BackgroundName="$bv{es.background.name}",BackgroundDescription="$bv{es.background.description}",
 TraitScript="scripts/skills/traits/battle_valkyries/es_trait",TraitID="$bvvar{modId}.trait.es",
 TraitName="$bv{es.trait.name}",TraitDescription="$bv{es.trait.description}",TraitIcon="ui/traits/$bvvar{iconPrefix}/es_trait_icon.png",
 Level=1,XP=0,DailyWage=1,
 BaseAttributes={Hitpoints=85,Bravery=65,Stamina=140,MeleeSkill=80,RangedSkill=45,MeleeDefense=15,RangedDefense=10,Initiative=110},
 AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
 Talents={Hitpoints=0,Bravery=0,Stamina=2,MeleeSkill=3,RangedSkill=0,MeleeDefense=2,RangedDefense=0,Initiative=0},
 // Entitlement filtering keeps the seven challenge skills out until completion.
 SkillLoadout=["es_azure_guardian","es_crest_arts","es_breunor","es_galahad","es_mordred","es_bors","es_griflet","es_gawain","es_gawain_charged","es_percival","es_artorius"],
 Equipment={},Quests=[],HubDetails={Passive={Icon="es_heat",Name="$bv{es.azure_guardian.name}",Description="$bv{es.azure_guardian.description}"},
 Active={Icon="es_crest_arts",Name="$bv{es.actives.name}",Description="$bv{es.actives.description}"}}
};
bv.ValkyrieTraitData.es <- {TraitTooltip="$bv{es.trait.description}",TraitBonuses={}};
bv.Skins.es_skin <- {ID="es_skin",ValkyrieID="es",IsOriginal=true,Name="$bv{es.skin.name}",TabName="$bv{es.skin.name}",Description="$bv{es.skin.description}",
 Brush="bust_bv_es_skin",DeathBrush="bust_bv_es_skin_dead",WorldLeaderBrush="world_bv_es_leader",Portrait="ui/valkyries/es_card.png",Preview="ui/valkyries/es_skin_preview.png",
 TraitIcon="ui/traits/$bvvar{iconPrefix}/es_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/es_skin_icon.png",
 DetailMedia={Poster="ui/valkyries/detail/es_skin_poster.jpg",Video="ui/valkyries/detail/es_skin_idle.webm",PositionX=0.5,PositionY=0.5}};
