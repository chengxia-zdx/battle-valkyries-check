this.tenka_festival_examiner <- this.inherit("scripts/entity/tactical/enemies/bandit_leader",{
    m={Examiner="onigawara_rin"},
    function create(){this.bandit_leader.create();this.m.XP=0;this.getFlags().add("BVTenkaExaminer");}
    function onInit()
    {
        this.bandit_leader.onInit();local b=this.m.BaseProperties;
        b.ActionPoints=9;b.Hitpoints=this.m.Examiner=="onigawara_rin"?360:280;b.Stamina=180;b.Bravery=150;
        b.MeleeSkill=90;b.MeleeDefense=25;b.RangedDefense=20;b.Initiative=this.m.Examiner=="inaba_tsukuyo"?150:115;
        b.IsAffectedByNight=false;this.m.Hitpoints=b.Hitpoints;this.m.ActionPoints=b.ActionPoints;this.m.CurrentProperties=clone b;
        
        this.m.Skills.add(this.new("scripts/skills/effects/battle_valkyries/tenka_festival_sword_form"));
        this.m.Skills.removeByID("actives.rotation");this.refreshFestivalVisual();
    }
    function refreshFestivalVisual()
    {
        if(!this.hasSprite("body"))return;
        ::$bvvar{namespace}.hideWholeBustCompatibilitySprites(this,true);
        foreach(name in ["charm_body","charm_armor","charm_head","charm_hair","armor","surcoat","head","face","beard","beard_top","hair","helmet","helmet_damage","helmet_top","body_blood","body_injury","head_blood","dirt","injury_body","injury","closed_eyes","bandage_1","bandage_2","bandage_3","shaft","quiver","shield_icon","arms_icon","tattoo_body","tattoo_head","accessory","accessory_special"])
            if(this.hasSprite(name)){this.getSprite(name).Visible=false;this.getSprite(name).Alpha=0;}
        local body=this.getSprite("body");body.setBrush("bust_bv_"+this.m.Examiner+"_skin");body.Visible=true;body.Alpha=255;
        body.Color=this.createColor("#ffffff");body.Saturation=1.0;body.Scale=1.0;
        body.setHorizontalFlipping(!this.isAlliedWithPlayer());this.setSpriteOffset("body",this.createVec(0,0));
    }
    function onAppearanceChanged(appearance,dirty=true){this.actor.onAppearanceChanged(appearance,false);this.refreshFestivalVisual();if(dirty)this.setDirty(true);}
    function onFactionChanged(){this.actor.onFactionChanged();this.refreshFestivalVisual();}
    function assignRandomEquipment()
    {
        local w=::$bvvar{namespace}.TenkaGokenWeapons[this.m.Examiner];
        this.m.Items.equip(this.new(w.Starter));this.m.Items.equip(this.new("scripts/items/armor/mail_hauberk"));
        foreach(item in this.m.Items.getAllItems())if(item!=null)item.m.IsDroppedAsLoot=false;
        // Only native single-target techniques, understood by the existing AI.
        foreach(id in ["actives.split","actives.swing","actives.split_shield"])this.m.Skills.removeByID(id);
        this.refreshFestivalVisual();
    }
});
