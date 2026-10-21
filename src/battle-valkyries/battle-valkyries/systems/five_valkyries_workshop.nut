::$bvvar{namespace}.FiveValkyries.editable <- function(a)
{
    return this.supported(a)&&!a.isPlacedOnMap()&&::World!=null&&::World.State!=null;
};
::$bvvar{namespace}.FiveValkyries.dto <- function(a,id)
{
    if(id!="tohsaka_rin"&&id!="tokisaki_kurumi")return null;
    local d=this.api().FiveDefinitions[id],points=this.progress(a),options=[],load=this.loadout(a,id);
    foreach(o in d.Options)options.push({Key=o.Key,Name=o.Name,Description=o.Description,Icon="skills/$bvvar{iconPrefix}/"+o.Icon+".png",Unlock=o.Unlock,Unlocked=points>=o.Unlock});
    return {Title=id=="tohsaka_rin"?"$bv{five.workshop}":"$bv{five.clock}",ValkyrieID=id,Points=points,MaxPoints=180,Slots=d.Slots,Loadout=load,Options=options,Editable=this.editable(a),Description=id=="tohsaka_rin"?"$bv{five.progress_rin}":"$bv{five.progress_kurumi}"};
};
::$bvvar{namespace}.FiveValkyries.save <- function(request)
{
    local invalid={Success=false,Code="invalid",Message="$bv{five.invalid}"};
    if(typeof request!="table"||!("ValkyrieID" in request)||typeof request.ValkyrieID!="string"||!("Loadout" in request)||typeof request.Loadout!="array")return invalid;
    local id=request.ValkyrieID;if(id!="tohsaka_rin"&&id!="tokisaki_kurumi")return invalid;
    local actor=this.api().findValkyrieInRoster(id);
    if(!this.editable(actor))return {Success=false,Code="locked",Message="$bv{five.locked}"};
    local d=this.api().FiveDefinitions[id],seen={},points=this.progress(actor);
    if(request.Loadout.len()!=d.Slots)return invalid;
    foreach(k in request.Loadout)
    {
        if(typeof k!="string"||k in seen)return invalid;local allowed=false;
        foreach(o in d.Options)if(o.Key==k&&points>=o.Unlock)allowed=true;
        if(!allowed)return invalid;seen[k]<-true;
    }
    local flags=actor.getFlags(),name="$bvvar{modId}.five.loadout",before=flags.get(name),had=flags.has(name);
    flags.set(name,this.join(request.Loadout,"|"));
    local synced=null;try{synced=this.api().syncActorSkills(actor,"five-workshop-save");}
catch(ex){synced={Success=false};}
    if(synced==null||!synced.Success)
    {
        if(had)flags.set(name,before);else flags.remove(name);
        try{this.api().syncActorSkills(actor,"five-workshop-rollback");}
catch(ex){}
        return {Success=false,Code="sync_failed",Message="$bv{five.sync_failed}"};
    }
    // Battle state cannot be edited here; the next combat constructs it from flags.
    actor.m.BVFiveState<-null;actor.getSkills().update();actor.setDirty(true);
    return {Success=true,Code="success",Message="$bv{five.saved}",Workshop=this.dto(actor,id)};
};
