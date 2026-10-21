local bv=::$bvvar{namespace};
bv.ValkyrieSkillCatalog.hu_tao_unbind <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/hu_tao_unbind_skill",Name="$bv{hu_tao.challenge.interact.name}",Description="$bv{hu_tao.challenge.interact.description}",
 Icon="hu_tao_blood_blossom",Kind="active",Lifetime="transient",Learnable=false,Tags=[],Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={}
};
bv.ValkyrieSkillCatalog.hu_tao_sanguine_rouge <- {
 RuntimeScript="$bvvar{privateFolder}/skills/passives/hu_tao_sanguine_rouge_skill",Name="$bv{hu_tao.sanguine_rouge.name}",Description="$bv{hu_tao.sanguine_rouge.description}",
 Icon="hu_tao_sanguine_rouge",IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_sanguine_rouge_sw.png",Kind="passive",Lifetime="persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={Key="sanguine_rouge",AP=0,Fatigue=0}
};
bv.ValkyrieSkillCatalog.hu_tao_guide_to_afterlife <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/hu_tao_active_skill",Name="$bv{hu_tao.guide_to_afterlife.name}",Description="$bv{hu_tao.guide_to_afterlife.description}",
 Icon="hu_tao_guide_to_afterlife",IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_guide_to_afterlife_sw.png",Kind="active",Lifetime="persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={Key="guide_to_afterlife",AP=1,Fatigue=5}
};
bv.ValkyrieSkillCatalog.hu_tao_wangsheng_dash <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/hu_tao_active_skill",Name="$bv{hu_tao.wangsheng_dash.name}",Description="$bv{hu_tao.wangsheng_dash.description}",
 Icon="hu_tao_wangsheng_dash",IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_wangsheng_dash_sw.png",Kind="active",Lifetime="persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={Key="wangsheng_dash",AP=4,Fatigue=16}
};
bv.ValkyrieSkillCatalog.hu_tao_basic_thrust <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/hu_tao_active_skill",Name="$bv{hu_tao.basic_thrust.name}",Description="$bv{hu_tao.basic_thrust.description}",
 Icon="hu_tao_basic_thrust",IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_basic_thrust_sw.png",Kind="active",Lifetime="persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={Key="basic_thrust",AP=3,Fatigue=8}
};
bv.ValkyrieSkillCatalog.hu_tao_spirit_soother <- {
 RuntimeScript="$bvvar{privateFolder}/skills/actives/hu_tao_active_skill",Name="$bv{hu_tao.spirit_soother.name}",Description="$bv{hu_tao.spirit_soother.description}",
 Icon="hu_tao_spirit_soother",IconDisabled="skills/$bvvar{iconPrefix}/hu_tao_spirit_soother_sw.png",Kind="active",Lifetime="persistent",Learnable=false,Tags=[],
 Requirements={MinLevel=1,RequiredSkills=[],ForbiddenSkills=[]},Spec={Key="spirit_soother",AP=6,Fatigue=30}
};
