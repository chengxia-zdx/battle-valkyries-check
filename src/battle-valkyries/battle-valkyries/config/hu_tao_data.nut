local bv=::$bvvar{namespace};
bv.ValkyrieOrder.push("hu_tao");
bv.Valkyries.hu_tao <- {
 ID="hu_tao",LegendsPerkProfile="melee_mobile",SkinID="hu_tao_skin",SkinIDs=["hu_tao_skin","hu_tao_mei_lantern_skin"],Name="$bv{hu_tao.name}",
 Portrait="ui/valkyries/hu_tao_card.png",WorldLeaderBrush="world_bv_hu_tao_leader",
 BackgroundScript="scripts/skills/backgrounds/battle_valkyries/hu_tao_background",BackgroundID="$bvvar{modId}.background.hu_tao",
 BackgroundName="$bv{hu_tao.background.name}",BackgroundDescription="$bv{hu_tao.background.description}",
 TraitScript="scripts/skills/traits/battle_valkyries/hu_tao_trait",TraitID="$bvvar{modId}.trait.hu_tao",
 TraitName="$bv{hu_tao.trait.name}",TraitDescription="$bv{hu_tao.trait.description}",TraitIcon="ui/traits/$bvvar{iconPrefix}/hu_tao_trait_icon.png",
 Level=1,XP=0,DailyWage=1,
 BaseAttributes={Hitpoints=140,Bravery=95,Stamina=150,MeleeSkill=100,RangedSkill=40,MeleeDefense=30,RangedDefense=20,Initiative=115},
 AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
 Talents={Hitpoints=3,MeleeSkill=3,RangedSkill=0,MeleeDefense=2,RangedDefense=1,Bravery=2,Fatigue=2,Initiative=2},
 // All four active skills are available on recruitment; challenges improve their rules.
 SkillLoadout=["hu_tao_sanguine_rouge","hu_tao_guide_to_afterlife","hu_tao_wangsheng_dash","hu_tao_basic_thrust","hu_tao_spirit_soother"],
 Equipment={},Quests=[],HubDetails={Passive={Icon="hu_tao_sanguine_rouge",Name="$bv{hu_tao.sanguine_rouge.name}",Description="$bv{hu_tao.sanguine_rouge.description}"},
 Active={Icon="hu_tao_wangsheng_dash",Name="$bv{hu_tao.actives.name}",Description="$bv{hu_tao.actives.description}"}}
};
bv.ValkyrieTraitData.hu_tao <- {TraitTooltip="$bv{hu_tao.trait.description}",TraitBonuses={}};
bv.Skins.hu_tao_skin <- {ID="hu_tao_skin",ValkyrieID="hu_tao",IsOriginal=true,Name="$bv{hu_tao.skin.name}",TabName="$bv{hu_tao.skin.name}",Description="$bv{hu_tao.skin.description}",
 Brush="bust_bv_hu_tao_skin",DeathBrush="bust_bv_hu_tao_skin_dead",WorldLeaderBrush="world_bv_hu_tao_leader",Portrait="ui/valkyries/hu_tao_card.png",Preview="ui/valkyries/hu_tao_skin_preview.png",
 TraitIcon="ui/traits/$bvvar{iconPrefix}/hu_tao_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/hu_tao_skin_icon.png",
 DetailMedia={Poster="ui/valkyries/detail/hu_tao_skin_poster.jpg",Video="ui/valkyries/detail/hu_tao_skin_idle.webm",PositionX=0.35,PositionY=0.1}};

local dress=clone bv.Skins.hu_tao_skin;
dress.ID="hu_tao_mei_lantern_skin";dress.IsOriginal=false;dress.UnlockHuTaoBond<-100;
dress.Name="$bv{hu_tao.dress.name}";dress.TabName="$bv{hu_tao.dress.tab}";dress.Description="$bv{hu_tao.dress.description}";
dress.Brush="bust_bv_hu_tao_mei_lantern_skin";dress.DeathBrush="bust_bv_hu_tao_mei_lantern_skin_dead";dress.WorldLeaderBrush="world_bv_hu_tao_mei_lantern_leader";
dress.Portrait="ui/valkyries/hu_tao_mei_lantern_card.png";dress.Preview="ui/valkyries/hu_tao_mei_lantern_skin_preview.png";
dress.ItemIcon="$bvvar{iconPrefix}/hu_tao_mei_lantern_skin_icon.png";
dress.DetailMedia={Poster="ui/valkyries/detail/hu_tao_mei_lantern_skin_poster.jpg",Video="ui/valkyries/detail/hu_tao_mei_lantern_skin_idle.webm",PositionX=0.35,PositionY=0.1};
bv.Skins.hu_tao_mei_lantern_skin <- dress;
