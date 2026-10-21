local bv=::$bvvar{namespace};
bv.ValkyrieSkillCatalog.si_myriad <- {
 RuntimeScript="$bvvar{privateFolder}/skills/passives/si_passive_skill",Name="$bv{skill.si_myriad.name}",Description="$bv{skill.si_myriad.description}",Icon="si_myriad",
 Kind="passive",Lifetime="persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},
 Spec={StartInk=2,MaxInk=6,MarkLimit=3,EchoFraction=0.30,EchoCap=40}
};
local specs={
 si_brush={AP=3,Fatigue=12,Ink=0,Range=5,Cooldown=0,Low=70,High=90,Armor=1.0,Pierce=0.30,Attack=true,Hit=15},
 si_landscape={AP=4,Fatigue=20,Ink=1,Range=5,Cooldown=2,Low=0,High=0,Armor=1.0,Pierce=0.0,Attack=false,Hit=0},
 si_sanctuary={AP=3,Fatigue=18,Ink=2,Range=4,Cooldown=3,Low=0,High=0,Armor=1.0,Pierce=0.0,Attack=false,Hit=0},
 si_dragon={AP=6,Fatigue=32,Ink=5,Range=5,Cooldown=4,Low=180,High=220,Armor=1.25,Pierce=0.40,Attack=true,Hit=0}
};
local names={si_brush="$bv{skill.si_brush.name}",si_landscape="$bv{skill.si_landscape.name}",si_sanctuary="$bv{skill.si_sanctuary.name}",si_dragon="$bv{skill.si_dragon.name}"};
local descs={si_brush="$bv{skill.si_brush.description}",si_landscape="$bv{skill.si_landscape.description}",si_sanctuary="$bv{skill.si_sanctuary.description}",si_dragon="$bv{skill.si_dragon.description}"};
foreach(key,spec in specs) bv.ValkyrieSkillCatalog[key] <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/si_active_skill",Name=names[key],Description=descs[key],Icon=key,IconDisabled="skills/$bvvar{iconPrefix}/"+key+"_sw.png",
 Kind="active",Lifetime="persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec=spec
};
