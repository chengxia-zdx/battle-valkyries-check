::$bvvar{namespace}.getLilySpiritRecord <- function( _actor )
{
	if(_actor==null)return null;
	try{return _actor.getSkills().getSkillByID(::$bvvar{namespace}.LilySpiritRecordTraitID);}catch(e){return null;}
};

::$bvvar{namespace}.removeLilyForbiddenCombatSkills <- function( _actor )
{
	if(_actor==null||::$bvvar{namespace}.getActorValkyrieID(_actor)!="lily")return 0;
	local skills=null;try{skills=_actor.getSkills();}catch(e){return 0;}
	local removed=0;
	foreach(id in ["actives.hand_to_hand","actives.legend_kick","actives.legend_grapple","actives.legend_choke","actives.legend_tackle","actives.legend_unarmed_lunge"])
	{
		while(skills.hasSkill(id)){skills.removeByID(id);removed++;}
	}
	return removed;
};

::$bvvar{namespace}.syncLilySpiritLoadout <- function( _actor, _reason="sync" )
{
	if(_actor==null||::$bvvar{namespace}.getActorValkyrieID(_actor)!="lily")return {Success=true,Code="not_lily",Added=0,Removed=0};
	local record=::$bvvar{namespace}.getLilySpiritRecord(_actor);
	if(record==null)return {Success=false,Code="record_missing",Added=0,Removed=0};
	local loadout=record.getLoadout(), selected={};
	foreach(index,key in loadout)selected[key]<-index;
	local added=0,removed=0;
	foreach(spirit in ::$bvvar{namespace}.LilySpirits)
	{
		local key="lily_spirit_"+spirit.Key, token=::$bvvar{namespace}.LilySpiritOwnerPrefix+spirit.Key;
		if(spirit.Key in selected)
		{
			local result=::$bvvar{namespace}.attachTransientSkill(_actor,key,token);
			if(!result.Success)return {Success=false,Code=result.Code,Added=added,Removed=removed};
			added+=result.Added;
			local runtime=::$bvvar{namespace}.getRuntimeSkillByKey(_actor,key);
			if(runtime!=null&&"setLilySlotIndex" in runtime)runtime.setLilySlotIndex(selected[spirit.Key]);
		}
		else
		{
			local runtime=::$bvvar{namespace}.getRuntimeSkillByKey(_actor,key);
			if(runtime!=null&&runtime.hasTransientOwner(token))
			{
				local result=::$bvvar{namespace}.detachTransientSkill(_actor,key,token);
				if(!result.Success)return {Success=false,Code=result.Code,Added=added,Removed=removed};
				removed+=result.Removed;
			}
		}
	}
	::$bvvar{namespace}.removeLilyForbiddenCombatSkills(_actor);
	::$bvvar{namespace}.dirtyValkyrieSkillActor(_actor);
	return {Success=true,Code="success",Added=added,Removed=removed};
};

local lilyBaseSyncActorSkills=::$bvvar{namespace}.syncActorSkills;
::$bvvar{namespace}.syncActorSkills <- function( _actor, _reason )
{
	local result=lilyBaseSyncActorSkills(_actor,_reason);
	if(!result.Success)return result;
	local lily=::$bvvar{namespace}.syncLilySpiritLoadout(_actor,_reason);
	if(!lily.Success){result.Success=false;result.Code=lily.Code;return result;}
	result.Added+=lily.Added;result.Removed+=lily.Removed;return result;
};

::$bvvar{namespace}.isLilySpiritLoadoutEditable <- function( _actor )
{
	if(_actor==null||::$bvvar{namespace}.getActorValkyrieID(_actor)!="lily")return false;
	try{if(_actor.isPlacedOnMap())return false;}catch(e){}
	return ::World!=null && ::World.State!=null;
};

::$bvvar{namespace}.setLilySpiritLoadout <- function( _request )
{
	local actor=::$bvvar{namespace}.findValkyrieInRoster("lily");
	if(actor==null)return {Success=false,Code="not_owned",Message="$bv{lily.spirits.error.not_owned}"};
	if(!::$bvvar{namespace}.isLilySpiritLoadoutEditable(actor))return {Success=false,Code="combat_locked",Message="$bv{lily.spirits.error.combat_locked}"};
	if(typeof _request!="table"||!("Loadout" in _request)||typeof _request.Loadout!="array")return {Success=false,Code="invalid",Message="$bv{lily.spirits.error.invalid}"};
	local record=::$bvvar{namespace}.getLilySpiritRecord(actor);
	if(record==null||!record.setLoadout(_request.Loadout))return {Success=false,Code="invalid",Message="$bv{lily.spirits.error.invalid}"};
	local sync=::$bvvar{namespace}.syncLilySpiritLoadout(actor,"hub-save");
	if(!sync.Success)return {Success=false,Code=sync.Code,Message="$bv{lily.spirits.error.sync}"};
	actor.getSkills().update();actor.setDirty(true);
	return {Success=true,Code="success",Message="$bv{lily.spirits.saved}"};
};

::$bvvar{namespace}.makeLilySpiritDTO <- function( _actor )
{
	local record=::$bvvar{namespace}.getLilySpiritRecord(_actor), points=record==null?0:record.getPurificationPoints();
	local loadout=record==null?clone ::$bvvar{namespace}.LilySpiritInitialLoadout:record.getLoadout(),spirits=[],next=null;
	foreach(spirit in ::$bvvar{namespace}.LilySpirits)
	{
		local unlocked=record==null?spirit.Unlock==0:record.isSpiritUnlocked(spirit.Key);
		if(!unlocked&&(next==null||spirit.Unlock<next.Unlock))next=spirit;
		spirits.push({Key=spirit.Key,SkillKey="lily_spirit_"+spirit.Key,Name=spirit.Name,Description=spirit.Description,Icon="skills/$bvvar{iconPrefix}/lily_spirit_"+spirit.Key+".png",Type=spirit.Type,Unlock=spirit.Unlock,Unlocked=unlocked,AP=spirit.AP,Fatigue=spirit.Fatigue,MinRange=spirit.MinRange,MaxRange=spirit.MaxRange});
	}
	return {Available=_actor!=null,Editable=::$bvvar{namespace}.isLilySpiritLoadoutEditable(_actor),Points=points,PendingPoints=record==null?0:record.getPendingPoints(),MaxPoints=310,Loadout=loadout,Spirits=spirits,Next=next==null?null:{Key=next.Key,Name=next.Name,Unlock=next.Unlock,Remaining=::Math.max(0,next.Unlock-points)}};
};

::$bvvar{namespace}.finalizeLilyPurificationProgress <- function()
{
	local actor=::$bvvar{namespace}.findValkyrieInRoster("lily"),record=::$bvvar{namespace}.getLilySpiritRecord(actor);
	if(actor==null||record==null)return 0;
	local added=record.commitPendingProgress();
	if(added>0)
	{
		actor.getSkills().update();
		actor.setDirty(true);
	}
	return added;
};
