this.tenka_festival_sword_form <- this.inherit("scripts/skills/skill",{
    m={Round=-1,Spent=false,Bear=0,Target=null,Chain=0},
    function create()
    {
        this.m.ID="$bvvar{modId}.effects.tenka_festival_sword_form";this.m.Name="$bv{chapter.tenka_festival.enemy_skill}";
        this.m.Description="$bv{chapter.tenka_festival.enemy_description}";
        this.m.Icon="skills/$bvvar{iconPrefix}/onigawara_rin_mastery.png";
        this.m.Type=::Const.SkillType.StatusEffect;this.m.Order=::Const.SkillOrder.Last;this.m.IsSerialized=false;
    }
    function getTooltip()
    {
        local descriptions={
            onigawara_rin="$bv{chapter.tenka_festival.form.rin}",
            kikakujo_mary="$bv{chapter.tenka_festival.form.mary}",
            tamaba_satori="$bv{chapter.tenka_festival.form.satori}",
            hanasaka_warabi="$bv{chapter.tenka_festival.form.warabi}",
            inaba_tsukuyo="$bv{chapter.tenka_festival.form.tsukuyo}"
        };
        return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=descriptions[this.getContainer().getActor().m.Examiner]}];
    }
    function resetRound(){if(this.m.Round!=::Time.getRound()){this.m.Round=::Time.getRound();this.m.Spent=false;}}
    function onTurnStart(){this.resetRound();}
    function onAnySkillUsed(skill,target,p)
    {
        if(skill==null||!skill.isAttack()||skill.isRanged()||!skill.m.IsWeaponSkill)return;
        this.resetRound();local a=this.getContainer().getActor(),id=a.m.Examiner,mult=1.0;
        if(id=="kikakujo_mary"){p.MeleeSkill+=10;p.DamageDirectAdd+=0.10;}
        if(id=="hanasaka_warabi"&&this.m.Bear<2)mult=1.30;
        if(id=="tamaba_satori"&&target!=null&&this.m.Target==target.getID())mult+=0.15*this.m.Chain;
        if(id=="onigawara_rin"&&::Time.getRound()%2==0){mult=1.50;p.DamageArmorMult*=1.20;}
        if(id=="inaba_tsukuyo"&&!this.m.Spent){mult=1.35;p.MeleeSkill+=10;}
        p.DamageRegularMult*=mult;p.DamageArmorMult*=mult;
    }
    function used(skill,target)
    {
        if(skill==null||!skill.isAttack()||skill.isRanged()||!skill.m.IsWeaponSkill)return;
        this.resetRound();this.m.Spent=true;this.m.Bear++;
        if(target!=null){this.m.Chain=this.m.Target==target.getID()?::Math.min(2,this.m.Chain+1):1;this.m.Target=target.getID();}
    }
    function onTargetHit(skill,target,bodyPart,damageHP,damageArmor){this.used(skill,target);}
    function onTargetMissed(skill,target){this.used(skill,target);}
});
