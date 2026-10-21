local bv=::$bvvar{namespace};
bv.ValkyrieOrder.push("rachel_alucard");
bv.Valkyries.rachel_alucard <- {
 ID="rachel_alucard",LegendsPerkProfile="ranged_support",SkinID="rachel_alucard_skin",SkinIDs=["rachel_alucard_skin"],Name="$bv{rachel.name}",
 Portrait="ui/valkyries/rachel_alucard_card.png",WorldLeaderBrush="world_bv_rachel_alucard_leader",
 BackgroundScript="scripts/skills/backgrounds/battle_valkyries/rachel_alucard_background",BackgroundID="$bvvar{modId}.background.rachel_alucard",
 BackgroundName="$bv{rachel.background.name}",BackgroundDescription="$bv{rachel.background.description}",
 TraitScript="scripts/skills/traits/battle_valkyries/rachel_alucard_trait",TraitID="$bvvar{modId}.trait.rachel_alucard",
 TraitName="$bv{rachel.trait.name}",TraitDescription="$bv{rachel.trait.description}",TraitIcon="ui/traits/$bvvar{iconPrefix}/rachel_alucard_trait_icon.png",
 Level=1,XP=0,DailyWage=1,
 BaseAttributes={Hitpoints=70,Bravery=70,Stamina=130,MeleeSkill=65,RangedSkill=80,MeleeDefense=15,RangedDefense=10,Initiative=110},
 AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
 Talents={Hitpoints=0,Bravery=0,Stamina=2,MeleeSkill=0,RangedSkill=3,MeleeDefense=2,RangedDefense=0,Initiative=0},
 // Complete base kit. Personal bond challenges permanently improve it;
 // the reward service projects completed stages onto the actor's progression flag.
 SkillLoadout=["rachel_alucard_wind_mastery", "rachel_alucard_tiny_lobelia", "rachel_alucard_sword_iris", "rachel_alucard_silpheed", "rachel_alucard_george_xiii", "rachel_alucard_lotus_barrel", "rachel_alucard_baden_baden_lily", "rachel_alucard_tempest_dahlia", "rachel_alucard_elfried", "rachel_alucard_nago_attack", "rachel_alucard_ivy_blossom", "rachel_alucard_gerbera_lute", "rachel_alucard_clownish_calendula"],
 Equipment={},Quests=[],HubDetails={Passive={Icon="rachel_alucard_wind",Name="$bv{rachel.state}",Description="$bv{rachel.trait.description}"},Active={Icon="rachel_alucard_sword_iris",Name="$bv{rachel.sword_iris.name}",Description="$bv{rachel.sword_iris.description}"}}
};
bv.ValkyrieTraitData.rachel_alucard <- {TraitTooltip="$bv{rachel.trait.description}",TraitBonuses={}};
bv.Skins.rachel_alucard_skin <- {ID="rachel_alucard_skin",ValkyrieID="rachel_alucard",IsOriginal=true,Name="$bv{rachel.skin.name}",TabName="$bv{rachel.skin.name}",Description="$bv{rachel.skin.description}",
 Brush="bust_bv_rachel_alucard_skin",DeathBrush="bust_bv_rachel_alucard_skin_dead",WorldLeaderBrush="world_bv_rachel_alucard_leader",Portrait="ui/valkyries/rachel_alucard_card.png",Preview="ui/valkyries/rachel_alucard_skin_preview.png",
 TraitIcon="ui/traits/$bvvar{iconPrefix}/rachel_alucard_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/rachel_alucard_skin_icon.png",
 DetailMedia={Poster="ui/valkyries/detail/rachel_alucard_skin_poster.jpg",Video="ui/valkyries/detail/rachel_alucard_skin_idle.webm",PositionX=0.5,PositionY=0.5}};
