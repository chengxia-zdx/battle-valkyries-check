// The cast is independent of roster eligibility; all durable progress uses Chapters flags.
::$bvvar{namespace}.TenkaFestival <- {
    ID = "tenka_goken_festival", RewardBusy = false,
    function chapters(){return ::$bvvar{namespace}.Chapters;}
    function context()
    {
        local b=this.chapters().Battle;
        return b!=null&&b.ID==this.ID&&"TrialStage" in b?b:null;
    }
    function active(){return this.context()!=null&&"Tactical" in getroottable()&&::Tactical!=null&&::Tactical.isActive();}
    function examiner(node){local d=this.chapters().definition(this.ID);return d!=null&&node in d.Nodes&&"Examiner" in d.Nodes[node]?d.Nodes[node].Examiner:null;}
    function canEnter(node)
    {
        local c=this.chapters(),s=c.stage(this.ID),found=false,challengers=0,who=this.examiner(node);
        if(s==null||who==null)return false;
        foreach(g in s.Goals)if(g.Node==node&&g.Battle&&c.read(this.ID,"goal."+g.Key)!=1)found=true;
        if(!found)return false;
        foreach(a in ::World.getPlayerRoster().getAll())
        {
            if(::$bvvar{namespace}.Roster.reserve(a)||!::$bvvar{namespace}.Roster.eligible(a))continue;
            if(::$bvvar{namespace}.getActorValkyrieID(a)==who)return false;
            ++challengers;
        }
        return challengers>0;
    }
    function begin(location)
    {
        local c=this.chapters();
        c.Battle={ID=this.ID,Node=location.node(),Participants={},TrialStage=c.completed(this.ID)+1,LocationID=location.getID(),Entrants=[],Won=false,Invalid=false};
    }
    function enroll(a)
    {
        local b=this.context();if(b==null||!a.isPlacedOnMap()||!a.isAlive()||a.getHitpoints()<=0)return;
        if(::$bvvar{namespace}.getActorValkyrieID(a)==this.examiner(b.Node)){b.Invalid=true;return;}
        if(b.Entrants.find(a.getID())==null)b.Entrants.push(a.getID());
    }
    function rewards()
    {
        local c=this.chapters(),d=c.definition(this.ID);
        if(d==null||c.completed(this.ID)<d.Stages.len()||this.RewardBusy)return;
        this.RewardBusy=true;
        try { this.deliver(); }
        catch(e) { this.RewardBusy=false;::logError("[Battle Valkyries] Festival sword delivery pending: "+e);return; }
        this.RewardBusy=false;
    }
    function deliver()
    {
        local c=this.chapters(),stash=::World.Assets.getStash();
        foreach(owner,w in ::$bvvar{namespace}.TenkaGokenWeapons)
        {
            if(c.read(this.ID,"delivered."+w.Key)==1)continue;
            if(!stash.isResizable()&&stash.getNumberOfEmptySlots()<=0)break;
            local item=null,added=false;
            try
            {
                item=::new("scripts/items/weapons/battle_valkyries/"+w.Key);
                if(item==null||item.getID()!="$bvvar{modId}.weapon."+w.Key)throw "Invalid sword reward: "+w.Key;
                if(stash.add(item)==null)continue;
                added=true;c.write(this.ID,"delivered."+w.Key,1);
            }
            catch(e)
            {
                if(added){stash.remove(item);c.write(this.ID,"delivered."+w.Key,0);}
                throw e;
            }
        }
    }
};
local c=::$bvvar{namespace}.Chapters;
local oldRewards=c.syncRewards;
c.syncRewards=function(id){oldRewards.call(this,id);if(id=="tenka_goken_festival")::$bvvar{namespace}.TenkaFestival.rewards();};
local oldDTO=c.dto;
c.dto=function(id)
{
    local result=oldDTO.call(this,id);if(id!="tenka_goken_festival"||result==null)return result;
    result.StartHint<-"$bv{chapter.tenka_festival.start_hint}";
    local pending=0;foreach(owner,w in ::$bvvar{namespace}.TenkaGokenWeapons)if(this.read(id,"delivered."+w.Key)!=1)++pending;
    result.PendingWeapon=result.Finished&&pending>0;
    local stage=this.stage(id);if(stage!=null)foreach(g in stage.Goals)if(g.Battle&&!::$bvvar{namespace}.TenkaFestival.canEnter(g.Node)&&this.read(id,"goal."+g.Key)!=1)result.Brief+="\n$bv{chapter.tenka_festival.blocked}";
    result.PendingWeaponText<-"$bv{chapter.tenka_festival.pending}";
    return result;
};
local oldWin=c.battleWon;
c.battleWon=function(id,node)
{
    if(id!="tenka_goken_festival")return oldWin.call(this,id,node);
    local b=::$bvvar{namespace}.TenkaFestival.context();
    if(b==null||b.Node!=node||!b.Won||b.Invalid||b.TrialStage!=this.completed(id)+1||b.Entrants.len()==0)return;
    local survivor=false;foreach(a in ::World.getPlayerRoster().getAll())
        if(b.Entrants.find(a.getID())!=null&&a.isAlive()&&!a.isDying()&&a.getHitpoints()>0)survivor=true;
    if(survivor)oldWin.call(this,id,node);
};
local oldSpawn=c.spawnTile;
c.spawnTile=function(id,maxDistance=10)
{
    if(id!="tenka_goken_festival")return oldSpawn.call(this,id,maxDistance);
    local player=::World.State.getPlayer();if(player==null)return null;
    local center=player.getTile();
    if(this.read(id,"anchor_x",-1)>=0)center=::World.getTileSquare(this.read(id,"anchor_x"),this.read(id,"anchor_y"));
    else{this.write(id,"anchor_x",center.SquareCoords.X);this.write(id,"anchor_y",center.SquareCoords.Y);}
    for(local radius=2;radius<=maxDistance;++radius)
        for(local x=center.SquareCoords.X-radius;x<=center.SquareCoords.X+radius;++x)
            for(local y=center.SquareCoords.Y-radius;y<=center.SquareCoords.Y+radius;++y)
            {
                if(!::World.isValidTileSquare(x,y))continue;local tile=::World.getTileSquare(x,y);
                if(tile.IsOccupied||tile.Type==::Const.World.TerrainType.Ocean||tile.Type==::Const.World.TerrainType.Shore||tile.Type==::Const.World.TerrainType.Mountains||tile.getDistanceTo(center)<2||this.hasLocationAtTile(tile))continue;
                return tile;
            }
    return null;
};

// Greeting changes only the returned DTO, never the saved scene definition.
local oldScene=c.scene;
c.scene=function(id,key)
{
    local result=oldScene.call(this,id,key);if(id!="tenka_goken_festival"||result==null)return result;
    local greetings={
        onigawara_rin="$bv{chapter.tenka_festival.returning.rin}",
        kikakujo_mary="$bv{chapter.tenka_festival.returning.mary}",
        tamaba_satori="$bv{chapter.tenka_festival.returning.satori}",
        hanasaka_warabi="$bv{chapter.tenka_festival.returning.warabi}",
        inaba_tsukuyo="$bv{chapter.tenka_festival.returning.tsukuyo}"
    };
    if(["opening","stage1","stage3","stage5","stage7","stage9"].find(key)!=null)
        foreach(line in result.Lines)if(line.Speaker in greetings&&this.actor(line.Speaker)!=null){line.Text=greetings[line.Speaker];break;}
    return result;
};
