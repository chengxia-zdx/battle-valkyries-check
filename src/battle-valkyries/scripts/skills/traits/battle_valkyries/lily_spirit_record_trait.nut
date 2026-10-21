this.lily_spirit_record_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		PurificationPoints = 0,
		UnlockedMask = 0,
		Loadout = null,
		PendingPoints = 0,
		CombatCredits = null
	},

	function create()
	{
		this.character_trait.create();
		this.m.ID = ::$bvvar{namespace}.LilySpiritRecordTraitID;
		this.m.Name = "$bv{lily.spirit_record.name}";
		this.m.Description = "$bv{lily.spirit_record.description}";
		this.m.Icon = "ui/traits/$bvvar{iconPrefix}/lily_trait_icon.png";
		this.m.IsHidden = true;
		this.m.IsSerialized = true;
		this.m.Loadout = clone ::$bvvar{namespace}.LilySpiritInitialLoadout;
		this.m.CombatCredits = {};
		this.rebuildUnlockedMask();
	}

	function getPurificationPoints() { return this.m.PurificationPoints; }
	function getPendingPoints() { return this.m.PendingPoints; }
	function getLoadout() { return clone this.m.Loadout; }
	function getSpiritIndex( _key ) { foreach(i,s in ::$bvvar{namespace}.LilySpirits) if(s.Key==_key)return i; return -1; }
	function isSpiritUnlocked( _key )
	{
		local spirit=::$bvvar{namespace}.getLilySpirit(_key);
		return spirit!=null && this.m.PurificationPoints>=spirit.Unlock;
	}
	function rebuildUnlockedMask()
	{
		this.m.UnlockedMask=0;
		foreach(i,spirit in ::$bvvar{namespace}.LilySpirits) if(this.m.PurificationPoints>=spirit.Unlock)this.m.UnlockedMask=this.m.UnlockedMask|(1<<i);
	}
	function setLoadout( _loadout )
	{
		if(typeof _loadout!="array"||_loadout.len()>::$bvvar{namespace}.LilySpiritSlotCount)return false;
		local seen={}; local clean=[];
		foreach(key in _loadout)
		{
			if(typeof key!="string"||key in seen||!this.isSpiritUnlocked(key))return false;
			seen[key]<-true; clean.push(key);
		}
		this.m.Loadout=clean;
		return true;
	}

	function getTargetToken( _target ) { try{return "entity-"+_target.getID().tostring();}catch(e){return "object-"+_target.tostring();} }
	function getTargetPurificationValue( _target )
	{
		if(_target==null)return 0;
		local xp=0; try{xp=_target.getXPValue();}catch(e){return 0;}
		if(xp<=0)return 0;
		try{if("isSummoned" in _target&&_target.isSummoned())return 0;}catch(e){}
		try
		{
			local flags=_target.getFlags();
			foreach(flag in ["IsSummoned","IsIllusion","BattleValkyriesDebugSpawn"])if(flags!=null&&flags.has(flag))return 0;
		}
		catch(e){}
		local value=xp>=400?5:(xp>=200?3:(xp>=100?2:1));
		try{if("IsMiniboss" in _target.m&&_target.m.IsMiniboss)value+=3;}catch(e){}
		return value;
	}
	function recordPurificationCredit( _target, _direct )
	{
		local value=this.getTargetPurificationValue(_target); if(value<=0)return 0;
		local token=this.getTargetToken(_target), amount=_direct?value:this.Math.floor((value+1)/2);
		if(token in this.m.CombatCredits)
		{
			local old=this.m.CombatCredits[token];
			if(!_direct||old.Direct)return 0;
			local delta=this.Math.max(0,amount-old.Points); old.Direct=true; old.Points=amount;
			this.m.PendingPoints=this.Math.min(20,this.m.PendingPoints+delta); return delta;
		}
		this.m.CombatCredits[token]<-{Direct=_direct,Points=amount};
		local before=this.m.PendingPoints; this.m.PendingPoints=this.Math.min(20,this.m.PendingPoints+amount); return this.m.PendingPoints-before;
	}
	function commitPendingProgress()
	{
		local before=this.m.PurificationPoints;
		this.m.PurificationPoints=this.Math.min(310,this.m.PurificationPoints+this.m.PendingPoints);
		local added=this.m.PurificationPoints-before;
		this.m.PendingPoints=0; this.m.CombatCredits={}; this.rebuildUnlockedMask();
		return added;
	}
	function discardPendingProgress() { this.m.PendingPoints=0; this.m.CombatCredits={}; }
	function onCombatStarted() { this.m.PendingPoints=0; this.m.CombatCredits={}; }

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out); _out.writeU8(1); _out.writeU32(this.m.PurificationPoints); _out.writeU32(this.m.UnlockedMask);
		_out.writeU8(this.m.Loadout.len());
		foreach(key in this.m.Loadout){local index=this.getSpiritIndex(key);_out.writeU8(index<0?255:index);}
	}
	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in); local version=_in.readU8();
		this.m.PurificationPoints=this.Math.min(310,_in.readU32()); this.m.UnlockedMask=_in.readU32(); this.m.Loadout=[];
		local count=this.Math.min(::$bvvar{namespace}.LilySpiritSlotCount,_in.readU8()),seen={};
		for(local i=0;i<count;i++)
		{
			local index=_in.readU8(); if(index<0||index>=::$bvvar{namespace}.LilySpirits.len())continue;
			local key=::$bvvar{namespace}.LilySpirits[index].Key; if(key in seen||!this.isSpiritUnlocked(key))continue;
			seen[key]<-true;this.m.Loadout.push(key);
		}
		if(this.m.Loadout.len()==0)this.m.Loadout=clone ::$bvvar{namespace}.LilySpiritInitialLoadout;
		this.m.PendingPoints=0;this.m.CombatCredits={};this.rebuildUnlockedMask();
	}
});
