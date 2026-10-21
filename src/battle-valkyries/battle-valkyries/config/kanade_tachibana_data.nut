local bv = ::$bvvar{namespace};
bv.ValkyrieOrder.push("kanade_tachibana");
bv.Valkyries.kanade_tachibana <- {
 ID="kanade_tachibana", LegendsPerkProfile="melee_mobile", SkinID="kanade_tachibana_skin", SkinIDs=[],
 Name="$bv{kanade.name}", Portrait="ui/valkyries/kanade_tachibana_bond_00_card.png", WorldLeaderBrush="world_bv_kanade_tachibana_leader",
 BackgroundScript="scripts/skills/backgrounds/battle_valkyries/kanade_tachibana_background", BackgroundID="$bvvar{modId}.background.kanade_tachibana",
 BackgroundName="$bv{kanade.background.name}", BackgroundDescription="$bv{kanade.background.description}",
 TraitScript="scripts/skills/traits/battle_valkyries/kanade_tachibana_trait", TraitID="$bvvar{modId}.trait.kanade_tachibana",
 TraitName="$bv{kanade.trait.name}", TraitDescription="$bv{kanade.trait.description}", TraitIcon="ui/traits/$bvvar{iconPrefix}/kanade_tachibana_trait_icon.png",
 Level=1, XP=0, DailyWage=1,
 BaseAttributes={Hitpoints=110,Bravery=90,Stamina=150,MeleeSkill=100,RangedSkill=60,MeleeDefense=35,RangedDefense=25,Initiative=125},
 AttributeAdjustments={Hitpoints=[0,0],Bravery=[0,0],Stamina=[0,0],MeleeSkill=[0,0],RangedSkill=[0,0],MeleeDefense=[0,0],RangedDefense=[0,0],Initiative=[0,0]},
 Talents={Hitpoints=2,Bravery=3,Stamina=3,MeleeSkill=3,RangedSkill=0,MeleeDefense=3,RangedDefense=2,Initiative=3},
 SkillLoadout=["kanade_overdrive","kanade_hand_sonic_slash","kanade_hand_sonic_pierce","kanade_hand_sonic_sweep","kanade_distortion","kanade_delay","kanade_harmonics","kanade_absorb","kanade_howling"],
 Equipment={}, Quests=[],
 HubDetails={Passive={Icon="kanade_tachibana_overdrive",Name="$bv{kanade.overdrive.name}",Description="$bv{kanade.overdrive.description}"},
 Active={Icon="kanade_tachibana_harmonics",Name="$bv{kanade.actives}",Description="$bv{kanade.actives.description}"}}
};
bv.ValkyrieTraitData.kanade_tachibana <- {TraitTooltip="$bv{kanade.trait.description}",TraitBonuses={}};
local outfits=[
 [0,"","$bv{kanade.skin.0.name}","$bv{kanade.skin.0.description}"],
 [20,"_campfire","$bv{kanade.skin.20.name}","$bv{kanade.skin.20.description}"],
 [40,"_whitewing","$bv{kanade.skin.40.name}","$bv{kanade.skin.40.description}"],
 [60,"_harmonics","$bv{kanade.skin.60.name}","$bv{kanade.skin.60.description}"],
 [80,"_lamplight","$bv{kanade.skin.80.name}","$bv{kanade.skin.80.description}"],
 [100,"_whitefeather","$bv{kanade.skin.100.name}","$bv{kanade.skin.100.description}"]
];
foreach (row in outfits)
{
 local key="kanade_tachibana"+row[1], id=key+"_skin", stage=row[0];
 bv.Valkyries.kanade_tachibana.SkinIDs.push(id);
 bv.Skins[id] <- {ID=id,ValkyrieID="kanade_tachibana",IsOriginal=stage==0,UnlockKanadeBond=stage,
  Name=row[2],TabName=row[2],Description=row[3],Brush="bust_bv_"+id,DeathBrush="bust_bv_"+id+"_dead",WorldLeaderBrush="world_bv_"+key+"_leader",
  Portrait="ui/valkyries/kanade_tachibana_bond_"+(stage==0?"00":stage.tostring())+"_card.png",
  Preview="ui/valkyries/"+key+"_skin_preview.png",TraitIcon="ui/traits/$bvvar{iconPrefix}/kanade_tachibana_trait_icon.png",ItemIcon="$bvvar{iconPrefix}/"+key+"_skin_icon.png",
  DetailMedia={Poster="ui/valkyries/detail/"+key+"_poster.jpg",Video="ui/valkyries/detail/"+key+"_idle.webm",PositionX=0.5,PositionY=0.5}};
}
