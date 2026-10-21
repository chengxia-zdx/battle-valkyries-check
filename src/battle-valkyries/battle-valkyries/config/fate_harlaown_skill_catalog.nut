local bv=::$bvvar{namespace};
bv.ValkyrieSkillCatalog.fate_lightning <- {
 RuntimeScript="$bvvar{privateFolder}/skills/passives/fate_harlaown_passive_skill",
 Name="$bv{skill.fate_lightning.name}",Description="$bv{skill.fate_lightning.description}",Icon="fate_lightning",
 Kind="passive",Lifetime="persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={}
};
local specs={
 fate_scythe={AP=4,Fatigue=15,Min=1,Range=1,Cooldown=0,Low=65,High=85,Armor=1.2,Pierce=0.25,Hit=0,Attack=true,Ranged=false,Strikes=1},
 fate_move={AP=2,Fatigue=12,Min=1,Range=3,Cooldown=2,Low=0,High=0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false,Ranged=false,Strikes=0},
 fate_lancer={AP=4,Fatigue=22,Min=2,Range=5,Cooldown=1,Low=25,High=35,Armor=1.0,Pierce=0.25,Hit=10,Attack=true,Ranged=true,Strikes=3},
 fate_form={AP=2,Fatigue=20,Min=0,Range=0,Cooldown=0,Low=0,High=0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false,Ranged=false,Strikes=0},
 fate_blade={AP=4,Fatigue=18,Min=1,Range=1,Cooldown=0,Low=40,High=50,Armor=1.2,Pierce=0.25,Hit=0,Attack=true,Ranged=false,Strikes=2},
 fate_zanber={AP=6,Fatigue=35,Min=1,Range=3,Cooldown=0,Low=150,High=190,Armor=1.8,Pierce=0.35,Hit=15,Attack=true,Ranged=false,Strikes=1}
};
local names={fate_scythe="$bv{skill.fate_scythe.name}",fate_move="$bv{skill.fate_move.name}",fate_lancer="$bv{skill.fate_lancer.name}",fate_form="$bv{skill.fate_form.name}",fate_blade="$bv{skill.fate_blade.name}",fate_zanber="$bv{skill.fate_zanber.name}"};
local descs={fate_scythe="$bv{skill.fate_scythe.description}",fate_move="$bv{skill.fate_move.description}",fate_lancer="$bv{skill.fate_lancer.description}",fate_form="$bv{skill.fate_form.description}",fate_blade="$bv{skill.fate_blade.description}",fate_zanber="$bv{skill.fate_zanber.description}"};
foreach(key,spec in specs)bv.ValkyrieSkillCatalog[key]<-{
 RuntimeScript="$bvvar{privateFolder}/skills/actives/fate_harlaown_active_skill",Name=names[key],Description=descs[key],Icon=key,IconDisabled="skills/$bvvar{iconPrefix}/"+key+"_sw.png",
 Kind="active",Lifetime=(key=="fate_blade"||key=="fate_zanber")?"transient":"persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec=spec
};
