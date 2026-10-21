local bv=::$bvvar{namespace};
bv.ValkyrieSkillCatalog.kanade_overdrive <- {
 RuntimeScript="$bvvar{privateFolder}/skills/passives/kanade_tachibana_passive_skill",Name="$bv{kanade.overdrive.name}",Description="$bv{kanade.overdrive.description}",Icon="kanade_tachibana_overdrive",
 Kind="passive",Lifetime="persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={}
};
local specs={
 hand_sonic_slash={AP=3,Fatigue=10,Range=1,Cooldown=0,Damage=1.30,Armor=1.30,Pierce=0.35,Hit=15,Attack=true},
 hand_sonic_pierce={AP=4,Fatigue=15,Range=1,Cooldown=0,Damage=1.10,Armor=2.00,Pierce=0.50,Hit=10,Attack=true},
 hand_sonic_sweep={AP=4,Fatigue=18,Range=1,Cooldown=0,Damage=0.90,Armor=1.30,Pierce=0.35,Hit=5,Attack=true},
 distortion={AP=2,Fatigue=12,Range=1,Cooldown=2,Damage=0.0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false},
 delay={AP=1,Fatigue=10,Range=6,Cooldown=0,Damage=0.0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false},
 harmonics={AP=4,Fatigue=25,Range=1,Cooldown=4,Damage=0.0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false},
 absorb={AP=2,Fatigue=0,Range=0,Cooldown=0,Damage=0.0,Armor=1.0,Pierce=0.0,Hit=0,Attack=false},
 howling={AP=4,Fatigue=25,Range=0,Cooldown=3,Damage=0.0,Armor=1.0,Pierce=0.0,Hit=20,Attack=false},
 sonic_rotation={AP=6,Fatigue=35,Range=2,Cooldown=4,Damage=1.70,Armor=1.80,Pierce=0.40,Hit=15,Attack=true}
};
local names={hand_sonic_slash="$bv{kanade.hand_sonic_slash.name}",hand_sonic_pierce="$bv{kanade.hand_sonic_pierce.name}",hand_sonic_sweep="$bv{kanade.hand_sonic_sweep.name}",distortion="$bv{kanade.distortion.name}",delay="$bv{kanade.delay.name}",harmonics="$bv{kanade.harmonics.name}",absorb="$bv{kanade.absorb.name}",howling="$bv{kanade.howling.name}",sonic_rotation="$bv{kanade.sonic_rotation.name}"};
local descriptions={hand_sonic_slash="$bv{kanade.hand_sonic_slash.description}",hand_sonic_pierce="$bv{kanade.hand_sonic_pierce.description}",hand_sonic_sweep="$bv{kanade.hand_sonic_sweep.description}",distortion="$bv{kanade.distortion.description}",delay="$bv{kanade.delay.description}",harmonics="$bv{kanade.harmonics.description}",absorb="$bv{kanade.absorb.description}",howling="$bv{kanade.howling.description}",sonic_rotation="$bv{kanade.sonic_rotation.description}"};
foreach(k,s in specs) bv.ValkyrieSkillCatalog["kanade_"+k] <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/kanade_tachibana_active_skill",Name=names[k],Description=descriptions[k],Icon="kanade_tachibana_"+k,IconDisabled="skills/$bvvar{iconPrefix}/kanade_tachibana_"+k+"_sw.png",
 Kind="active",Lifetime=k=="sonic_rotation"?"transient":"persistent",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec=s
};
