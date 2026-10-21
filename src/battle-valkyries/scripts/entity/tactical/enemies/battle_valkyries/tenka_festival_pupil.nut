this.tenka_festival_pupil <- this.inherit("scripts/entity/tactical/enemies/bandit_raider",{
    function create(){this.bandit_raider.create();this.m.XP=0;this.m.Name="$bv{chapter.tenka_festival.pupil}";this.getFlags().add("BVTenkaPupil");}
    function onInit(){this.bandit_raider.onInit();this.m.BaseProperties.Bravery=120;this.m.Skills.update();}
    function assignRandomEquipment()
    {
        this.m.Items.equip(this.new("scripts/items/weapons/arming_sword"));this.m.Items.equip(this.new("scripts/items/armor/mail_shirt"));
        foreach(item in this.m.Items.getAllItems())if(item!=null)item.m.IsDroppedAsLoot=false;
    }
});
