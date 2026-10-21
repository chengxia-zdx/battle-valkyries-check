this.tenka_goken_festival_location <- this.inherit("scripts/entity/world/locations/battle_valkyries/yunki_chapter_location",{
    function create(){this.yunki_chapter_location.create();this.m.TypeID="$bvvar{modId}.location.tenka_goken_festival";}
    function getChapterFactionType(){return this.Const.FactionType.Bandits;}
    function configure()
    {
        this.yunki_chapter_location.configure();local d=this.data();if(d==null)return;
        if(d.Battle)this.m.Description="$bv{chapter.tenka_festival.location_battle}";
        // Native ruins, open line deployment. Scene art is not a tactical map.
        this.m.CombatLocation.Template=["tactical.ruins",null];this.m.CombatLocation.AdditionalRadius=1;
    }
    function reinforceDefenders(){}
    function populateDefenders()
    {
        if(this.getFlags().get("BVTenkaPopulated"))return;
        local d=this.data();if(d==null||!d.Battle)return;
        if(this.m.Troops.len()>0){this.getFlags().set("BVTenkaPopulated",true);return;}
        local boss=clone this.Const.World.Spawn.Troops.BanditLeader;
        boss.Script="scripts/entity/tactical/enemies/battle_valkyries/tenka_festival_"+d.Examiner;boss.Variant=0;
        local added=this.Const.World.Common.addTroop(this,{Type=boss},false,0);added.Name=::$bvvar{namespace}.Valkyries[d.Examiner].Name;
        local pupil=clone this.Const.World.Spawn.Troops.BanditRaider;
        pupil.Script="scripts/entity/tactical/enemies/battle_valkyries/tenka_festival_pupil";pupil.Variant=0;
        for(local i=0;i<3+d.Order;++i){local t=this.Const.World.Common.addTroop(this,{Type=pupil},false,0);t.Name="$bv{chapter.tenka_festival.pupil}";}
        this.getFlags().set("BVTenkaPopulated",true);this.updateStrength();
    }
    function onEnter()
    {
        local d=this.data();
        if(d!=null&&d.Battle&&!::$bvvar{namespace}.TenkaFestival.canEnter(this.node()))
        {
            ::World.State.m.WorldScreen.getTopbarOptionsModule().showBattleValkyrieChapter(this.chapter());return false;
        }
        return this.yunki_chapter_location.onEnter();
    }
    function onBeforeCombatStarted()
    {
        this.populateDefenders();::$bvvar{namespace}.TenkaFestival.begin(this);this.location.onBeforeCombatStarted();
    }
    function onCombatLost()
    {
        local b=::$bvvar{namespace}.TenkaFestival.context();
        if(b!=null&&b.LocationID==this.getID())::$bvvar{namespace}.Chapters.battleWon(this.chapter(),this.node());
        if(this.hasSprite("selection"))this.getSprite("selection").Visible=false;
        this.location.onCombatLost();
    }
});
