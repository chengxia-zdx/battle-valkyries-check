::$bvvar{namespace}.TheHertaResearchQuotaRules <- {
	purple_to_red = { Interval = 5, Max = 3 },
	red_to_prismatic = { Interval = 15, Max = 1 }
};

::$bvvar{namespace}.getTheHertaResearchFlag <- function( _suffix ) { return "$bvvar{modId}.the_herta_research." + _suffix; };
::$bvvar{namespace}.getTheHertaResearchWorldInt <- function( _suffix, _fallback )
{
	if(::World==null||::World.Flags==null)return _fallback;
	local key=::$bvvar{namespace}.getTheHertaResearchFlag(_suffix); if(!::World.Flags.has(key))return _fallback;
	local value=::World.Flags.get(key); return typeof value=="integer"?value:_fallback;
};
::$bvvar{namespace}.setTheHertaResearchWorldInt <- function( _suffix, _value )
{
	if(::World==null||::World.Flags==null)return false; ::World.Flags.set(::$bvvar{namespace}.getTheHertaResearchFlag(_suffix),_value); return true;
};
::$bvvar{namespace}.getTheHertaResearchAPI <- function()
{
	return "BattleValkyriesEquipmentResearchAPI" in ::getroottable()?::BattleValkyriesEquipmentResearchAPI:null;
};
::$bvvar{namespace}.isTheHertaResearchAvailable <- function()
{
	local api=::$bvvar{namespace}.getTheHertaResearchAPI();
	return api!=null && api.Version>=1 && api.isEnabled() && ::$bvvar{namespace}.findValkyrieInRoster("the_herta")!=null;
};
::$bvvar{namespace}.updateTheHertaResearchQuotas <- function()
{
	if(!::$bvvar{namespace}.isTheHertaResearchAvailable()||::World==null||::World.Flags==null)return;
	local day=0; try{day=::World.getTime().Days;}catch(e){}
	local initialized=::$bvvar{namespace}.getTheHertaResearchWorldInt("initialized",0);
	if(initialized!=1)
	{
		::$bvvar{namespace}.setTheHertaResearchWorldInt("initialized",1);
		foreach(id,rule in ::$bvvar{namespace}.TheHertaResearchQuotaRules){::$bvvar{namespace}.setTheHertaResearchWorldInt(id+".charges",0);::$bvvar{namespace}.setTheHertaResearchWorldInt(id+".anchor",day);}
		return;
	}
	foreach(id,rule in ::$bvvar{namespace}.TheHertaResearchQuotaRules)
	{
		local charges=::$bvvar{namespace}.getTheHertaResearchWorldInt(id+".charges",0), anchor=::$bvvar{namespace}.getTheHertaResearchWorldInt(id+".anchor",day);
		if(charges>=rule.Max){::$bvvar{namespace}.setTheHertaResearchWorldInt(id+".anchor",day);continue;}
		local gained=::Math.floor(::Math.max(0,day-anchor)/rule.Interval).tointeger();
		if(gained<=0)continue;
		charges=::Math.min(rule.Max,charges+gained); ::$bvvar{namespace}.setTheHertaResearchWorldInt(id+".charges",charges);
		::$bvvar{namespace}.setTheHertaResearchWorldInt(id+".anchor",charges>=rule.Max?day:anchor+gained*rule.Interval);
	}
};
::$bvvar{namespace}.getTheHertaResearchQuotaDTO <- function( _id )
{
	local rule=::$bvvar{namespace}.TheHertaResearchQuotaRules[_id], day=0;try{day=::World.getTime().Days;}catch(e){}
	local charges=::$bvvar{namespace}.getTheHertaResearchWorldInt(_id+".charges",0),anchor=::$bvvar{namespace}.getTheHertaResearchWorldInt(_id+".anchor",day);
	return {ID=_id,Charges=charges,Max=rule.Max,Interval=rule.Interval,DaysRemaining=charges>=rule.Max ? 0 : ::Math.max(1,rule.Interval-::Math.max(0,day-anchor))};
};
::$bvvar{namespace}.getTheHertaResearchDTO <- function()
{
	local api=::$bvvar{namespace}.getTheHertaResearchAPI(), owned=::$bvvar{namespace}.findValkyrieInRoster("the_herta")!=null;
	local enabled=api!=null&&api.Version>=1&&api.isEnabled(); if(owned&&enabled)::$bvvar{namespace}.updateTheHertaResearchQuotas();
	local quotas={};foreach(id,rule in ::$bvvar{namespace}.TheHertaResearchQuotaRules)quotas[id]<-::$bvvar{namespace}.getTheHertaResearchQuotaDTO(id);
	return {Owned=owned,Available=owned&&enabled,EquipmentEnabled=enabled,Items=owned&&enabled?api.getItems():[],Materials=owned&&enabled?api.getMaterials():[],Money=owned&&enabled?api.getMoney():0,Quotas=quotas};
};
::$bvvar{namespace}.getTheHertaResearchErrorText <- function( _code )
{
	local map={disabled="$bv{research.the_herta.error.disabled}",invalid_mode="$bv{research.the_herta.error.invalid_mode}",invalid_item="$bv{research.the_herta.error.invalid_item}",locked="$bv{research.the_herta.error.locked}",max_rarity="$bv{research.the_herta.error.max_rarity}",materials="$bv{research.the_herta.error.materials}",money="$bv{research.the_herta.error.money}",quota="$bv{research.the_herta.error.quota}",generation_failed="$bv{research.the_herta.error.failed}"};
	return _code in map?map[_code]:map.generation_failed;
};
::$bvvar{namespace}.performTheHertaResearch <- function( _request )
{
	if(typeof _request!="table"||!("InstanceID" in _request)||!("Mode" in _request))return {Success=false,Code="invalid_item",Message=::$bvvar{namespace}.getTheHertaResearchErrorText("invalid_item")};
	if(!::$bvvar{namespace}.isTheHertaResearchAvailable())return {Success=false,Code="disabled",Message=::$bvvar{namespace}.getTheHertaResearchErrorText("disabled")};
	::$bvvar{namespace}.updateTheHertaResearchQuotas(); local api=::$bvvar{namespace}.getTheHertaResearchAPI();
	local selected=null;foreach(item in api.getItems())if(item.InstanceID==_request.InstanceID){selected=item;break;}
	if(selected==null)return {Success=false,Code="invalid_item",Message=::$bvvar{namespace}.getTheHertaResearchErrorText("invalid_item")};
	local quotaID=selected.Research.Quota;
	if(quotaID!=null&&::$bvvar{namespace}.getTheHertaResearchWorldInt(quotaID+".charges",0)<=0)return {Success=false,Code="quota",Message=::$bvvar{namespace}.getTheHertaResearchErrorText("quota")};
	local result=api.upgrade(_request.InstanceID,_request.Mode);
	if(result==null||!("Success" in result)||!result.Success){local code=result!=null&&"Code" in result?result.Code:"generation_failed";return {Success=false,Code=code,Message=::$bvvar{namespace}.getTheHertaResearchErrorText(code)};}
	if(quotaID!=null)
	{
		local day=0;try{day=::World.getTime().Days;}catch(e){}
		local charges=::$bvvar{namespace}.getTheHertaResearchWorldInt(quotaID+".charges",0);::$bvvar{namespace}.setTheHertaResearchWorldInt(quotaID+".charges",::Math.max(0,charges-1));::$bvvar{namespace}.setTheHertaResearchWorldInt(quotaID+".anchor",day);
	}
	return {Success=true,Code="ok",Message="$bv{research.the_herta.success}"};
};
