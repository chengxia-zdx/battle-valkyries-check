this.the_herta_signature_weapon <- this.inherit("scripts/items/weapons/weapon", {
    m = { HertaSword = false },
    function create()
    {
        this.weapon.create();
        local sword=this.m.HertaSword;
        this.m.ID="$bvvar{modId}.weapon."+(sword?"the_herta_answer_foreordained":"the_herta_unending_inquiry");
        this.m.Name=sword?"$bv{item.the_herta_answer_foreordained.name}":"$bv{item.the_herta_unending_inquiry.name}";
        this.m.Description=sword?"$bv{item.the_herta_answer_foreordained.description}":"$bv{item.the_herta_unending_inquiry.description}";
        this.m.Categories=sword?"$bv{item.the_herta.sword_category}":"$bv{item.the_herta.staff_category}";
        this.m.SlotType=this.Const.ItemSlot.Mainhand; this.m.BlockedSlotType=this.Const.ItemSlot.Offhand;
        this.m.ItemType=this.Const.Items.ItemType.Weapon|this.Const.Items.ItemType.TwoHanded|this.Const.Items.ItemType.Named
            |(sword?this.Const.Items.ItemType.MeleeWeapon:this.Const.Items.ItemType.RangedWeapon);
        this.m.IsDoubleGrippable=false; this.m.AddGenericSkill=true; this.m.ShowQuiver=false;
        this.m.RegularDamage=sword?80:65;this.m.RegularDamageMax=sword?100:85;
        this.m.ArmorDamageMult=sword?1.25:1.0;this.m.DirectDamageMult=sword?0.30:0.25;
        this.m.StaminaModifier=sword?-16:-8;this.m.Condition=sword?120.0:100.0;this.m.ConditionMax=this.m.Condition;
        this.m.Value=sword?18000:12000;this.m.IsUnique=true;
        this.m.RangeMin=1;this.m.RangeMax=sword?2:6;this.m.RangeIdeal=this.m.RangeMax;
        this.updateVariant();
    }
    function updateVariant()
    {
        local key=this.m.HertaSword?"the_herta_answer_foreordained":"the_herta_unending_inquiry";
        this.m.Icon="$bvvar{iconPrefix}/"+key+".png";this.m.IconLarge="$bvvar{iconPrefix}/"+key+"_large.png";
        this.m.ShowArmamentIcon=true;this.m.ArmamentIcon="icon_bv_"+key;
    }
    function onEquip() { this.weapon.onEquip(); ::$bvvar{namespace}.HertaCombat.syncWeapon(this.getContainer().getActor()); }
    function onUnequip()
    {
        local a=this.getContainer()==null?null:this.getContainer().getActor();
        if(a!=null) foreach(key in ["the_herta_starlit_query","the_herta_verdict_slash","the_herta_star_step","the_herta_orbit_cleave","the_herta_final_verdict","the_herta_weapon_mastery"])
            ::$bvvar{namespace}.detachTransientSkill(a,key,"$bvvar{modId}.owner.herta.weapon");
        this.weapon.onUnequip();
    }
    function getTooltip()
    {
        local ret=this.weapon.getTooltip();
        ret.push({id=90,type="text",icon="ui/icons/special.png",text=this.m.HertaSword?"$bv{skill.the_herta_weapon_mastery.sword}":"$bv{skill.the_herta_weapon_mastery.staff}"});
        return ret;
    }
});
