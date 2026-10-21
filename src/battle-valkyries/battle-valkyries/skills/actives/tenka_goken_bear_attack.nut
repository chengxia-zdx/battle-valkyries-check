// Ephemeral ordinary physical attack. Final properties exclude equipment/perks.
this.tenka_goken_bear_attack <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_neutral_weapon_attack_skill", {
    m={BVTenkaBear=true},
    function create(){this.valkyrie_neutral_weapon_attack_skill.create();this.m.IsWeaponSkill=false;this.m.DirectDamageMult=0.15;this.m.Name="$bv{tenka.bear_attack}";this.m.Icon="skills/$bvvar{iconPrefix}/hanasaka_warabi_bear.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/hanasaka_warabi_bear_sw.png";}
    function configure(a,source){this.setContainer(a.getSkills());this.m.MinRange=1;this.m.MaxRange=1;this.m.IsRanged=false;}
    function finalizeProperties(p)
    {
        p.DamageRegularMin=100;p.DamageRegularMax=120;p.DamageRegularMult=1.0;p.DamageArmorMult=1.3;
        p.DamageTotalMult=1.0;p.MeleeDamageMult=1.0;p.RangedDamageMult=1.0;
        p.DamageDirectMult=1.0;p.DamageDirectAdd=0;p.DamageDirectMeleeAdd=0;p.DamageDirectRangedAdd=0;
        p.MeleeSkill=this.getContainer().getActor().getCurrentProperties().getMeleeSkill()-10;
        p.HitChanceAdditionalWithEachTile=0;p.DamageAdditionalWithEachTile=0;
    }
});
