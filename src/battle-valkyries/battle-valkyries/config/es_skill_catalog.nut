local bv=::$bvvar{namespace};
bv.ValkyrieSkillCatalog.es_azure_guardian <- {RuntimeScript="$bvvar{privateFolder}/skills/passives/es_azure_guardian_skill",Name="$bv{es.azure_guardian.name}",Description="$bv{es.azure_guardian.description}",Icon="es_heat",Kind="passive",Lifetime="persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={}};
bv.EsCrestRules <- {Base=1.0,Enhancement=0.5};
local rows=[
 ["crest_arts",0,4,12,0,1,1,1.0,1.3,0.25,10,"$bv{es.crest_arts.name}","$bv{es.crest_arts.description}"],
 ["breunor",0,4,14,0,2,4,0.9,1.1,0.25,5,"$bv{es.breunor.name}","$bv{es.breunor.description}"],
 ["galahad",0,4,22,50,1,3,0.8,1.5,0.35,15,"$bv{es.galahad.name}","$bv{es.galahad.description}"],
 ["mordred",20,3,12,0,1,3,0.9,1.3,0.25,5,"$bv{es.mordred.name}","$bv{es.mordred.description}"],
 ["bors",20,2,8,0,0,0,0.0,1.0,0.0,0,"$bv{es.bors.name}","$bv{es.bors.description}"],
 ["griflet",40,3,16,0,0,0,0.0,1.0,0.0,0,"$bv{es.griflet.name}","$bv{es.griflet.description}"],
 ["gawain",60,4,18,0,1,1,1.5,1.7,0.30,10,"$bv{es.gawain.name}","$bv{es.gawain.description}"],
 ["gawain_charged",60,6,26,0,1,1,2.0,1.9,0.35,15,"$bv{es.gawain_charged.name}","$bv{es.gawain_charged.description}"],
 ["percival",80,2,10,50,0,0,0.0,1.0,0.0,0,"$bv{es.percival.name}","$bv{es.percival.description}"],
 ["artorius",100,4,30,100,1,1,1.0,1.8,0.40,15,"$bv{es.artorius.name}","$bv{es.artorius.description}"]
];
foreach(r in rows)bv.ValkyrieSkillCatalog["es_"+r[0]] <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/es_active_skill",Name=r[11],Description=r[12],Icon="es_"+(r[0]=="gawain_charged"?"gawain":r[0]),IconDisabled="skills/$bvvar{iconPrefix}/es_"+(r[0]=="gawain_charged"?"gawain":r[0])+"_sw.png",
 Kind="active",Lifetime="persistent",Learnable=false,Tags=[],EsStage=r[1],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
 Spec={Key=r[0],Stage=r[1],AP=r[2],Fatigue=r[3],Heat=r[4],Min=r[5],Range=r[6],Damage=r[7],Armor=r[8],Pierce=r[9],Hit=r[10],Attack=r[7]>0,
  CrestPower=r[0]=="griflet"?1.1:r[7]*(r[0]=="galahad"||r[0]=="artorius"?3.0:1.0),
  CrestRadius=r[0]=="artorius"?2:1,Head=r[0]=="gawain_charged"}
};
