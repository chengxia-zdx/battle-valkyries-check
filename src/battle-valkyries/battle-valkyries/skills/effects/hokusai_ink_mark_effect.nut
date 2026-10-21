this.hokusai_ink_mark_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill",{
	m={Sources=null,ExpiresAfterTurn=0},
	function create()
	{
		this.valkyrie_effect_skill.create();this.m.Sources=[];this.m.IsStacking=false;
		this.m.ID=::$bvvar{namespace}.HokusaiInkID;
		this.m.Name="$bv{effect.hokusai_ink_mark.name}";this.m.Description="$bv{effect.hokusai_ink_mark.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/hokusai_ink_mark.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/hokusai_ink_mark_sw.png";
		this.m.IconMini="status_effect_111_mini";
	}
	function pruneSources()
	{
		local bv=::$bvvar{namespace},keep=[];
		foreach(s in this.m.Sources)
		{
			local a=bv.readValkyrieCombatWeakRef(s.Ref),state=bv.getHokusaiState(a);
			if (a!=null && !bv.isActorDeadOrDying(a) && a.isPlacedOnMap() && state!=null && state.Active) keep.push(s);
		}
		this.m.Sources=keep;
	}
	function removeSource(id)
	{
		for(local i=this.m.Sources.len()-1;i>=0;i--) if(this.m.Sources[i].ID==id) this.m.Sources.remove(i);
		if(this.m.Sources.len()==0) this.removeSelf();
	}
	function onUpdate(p)
	{
		this.pruneSources();
		if (this.m.Sources.len()==0) { this.removeSelf();return; }
		p.MeleeDefense-=4*this.m.Sources.len();p.RangedDefense-=4*this.m.Sources.len();
	}
	function onBeforeDamageReceived(a,skill,hit,p)
	{
		local bv=::$bvvar{namespace},target=this.getContainer().getActor();
		if (!bv.isDirectAttack(skill) || bv.getValkyrieFixedDamageFrameForHit(hit,target,a,skill)!=null) return;
		local frame=bv.getCurrentValkyrieCombatSource(a,skill);
		if (frame!=null && (frame.Source=="dot" || frame.Source=="damage_over_time" || frame.Source=="terrain" || frame.Source=="reflection" || frame.Source.find("fixed")!=null)) return;
		local mult=1.0+0.06*this.m.Sources.len();
		p.DamageReceivedRegularMult*=mult;p.DamageReceivedArmorMult*=mult;
	}
	function getName() { return this.m.Name+" ("+this.m.Sources.len()+"/3)"; }
	function getTooltip()
	{
		local t=::$bvvar{namespace}.getHokusaiTurn(this.getContainer().getActor());
		local remaining=::Math.min(2,::Math.max(0,this.m.ExpiresAfterTurn-t.Serial+(t.Normal?1:0)));
		return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/turns.png",text="$bv{hokusai.ink.remaining}"+remaining}];
	}
	function onDeath(fatality) { this.m.Sources.clear();this.removeSelf(); }
});
