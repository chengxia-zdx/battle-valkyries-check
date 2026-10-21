this.abigail_status_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={Kind="",Sources=null,Epoch=0,AppliedSerial=0,ExpiresAfterTurn=0,BoostReady=true,BoostAction=null,Recoveries=2,Attempts=0,APUsed=false},
	function create()
	{
		this.valkyrie_effect_skill.create();this.m.IsStacking=false;this.m.Sources={};
		this.m.Epoch=::$bvvar{namespace}.ValkyrieCombatEvents.Epoch;this.m.IconMini="status_effect_111_mini";
	}
	function setup(kind)
	{
		this.m.Kind=kind;this.m.ID=::$bvvar{namespace}.AbigailEffectIDs[kind];
		local names={prayer="$bv{effect.abigail_prayer.name}",erosion="$bv{effect.abigail_erosion.name}",terror="$bv{effect.abigail_terror.name}",trial="$bv{effect.abigail_trial.name}"};
		local descriptions={prayer="$bv{effect.abigail_prayer.description}",erosion="$bv{effect.abigail_erosion.description}",terror="$bv{effect.abigail_terror.description}",trial="$bv{effect.abigail_trial.description}"};
		local icons={prayer="abigail_faithful_prayer",erosion="abigail_erosion_effect",terror="abigail_mass_hysteria",trial="abigail_witch_trial"};
		this.m.Name=names[kind];this.m.Description=descriptions[kind];
		this.m.Icon="skills/$bvvar{iconPrefix}/"+icons[kind]+".png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/"+icons[kind]+"_sw.png";
	}
	function hasSource()
	{
		local bv=::$bvvar{namespace},remove=[];
		foreach(id,source in this.m.Sources)
		{
			local a=bv.readValkyrieCombatWeakRef(source.Ref),s=bv.getAbigailState(a);
			if (a==null || bv.isActorDeadOrDying(a) || !a.isPlacedOnMap() || s==null || !s.Active || bv.getActorValkyrieID(a)!="abigail_williams") remove.push(id);
		}
		foreach(id in remove) delete this.m.Sources[id];
		if (this.m.Epoch!=bv.ValkyrieCombatEvents.Epoch || this.m.Sources.len()==0) { this.removeSelf();return false; }
		return !this.isGarbage();
	}
	function removeSource(id) { if (id in this.m.Sources) delete this.m.Sources[id];if (this.m.Sources.len()==0) this.removeSelf(); }
	function strongestSource()
	{
		local best=null;foreach(id,s in this.m.Sources) if (best==null || s.Resolve>best.Resolve) best=s;
		return best;
	}
	function terrorChance()
	{
		local s=this.strongestSource();if (s==null) return 0;
		return ::Math.min(65,::Math.max(15,45+0.5*(s.Resolve-this.getContainer().getActor().getCurrentProperties().getBravery())));
	}
	function onUpdate(p)
	{
		if (!this.hasSource()) return;
		local a=this.getContainer().getActor();
		if (this.m.Kind=="erosion" && ::$bvvar{namespace}.canReceiveAbigailEffect(a,"erosion")) { p.MeleeDefense-=10;p.RangedDefense-=10; }
	}
	function onNormalTurnStart(turn)
	{
		local bv=::$bvvar{namespace},a=this.getContainer().getActor();
		if (this.m.Kind=="prayer" && this.m.Recoveries>0)
		{
			this.m.Recoveries--;a.setFatigue(::Math.max(0,a.getFatigue()-10));
		}
		else if (this.m.Kind=="trial" && !this.m.APUsed)
		{
			this.m.APUsed=true;
			if (bv.canReceiveAbigailEffect(a,"trial") && !bv.abigailHasImmunity(a,["IsImmuneToActionPointReduction"]))
				a.setActionPoints(a.getActionPoints()-::Math.min(2,::Math.max(0,a.getActionPoints()-6)));
		}
		else if (this.m.Kind=="terror")
		{
			if (!bv.canReceiveAbigailEffect(a,"terror")) { this.removeSelf();return; }
			this.m.Attempts++;
			if (!a.getSkills().hasSkill("effects.stunned") && ::Math.rand(1,100)<=this.terrorChance())
			{
				local source=this.strongestSource(),stun=::new("scripts/skills/effects/stunned_effect");
				a.getSkills().add(stun);
				// Native onAdded may reject due to immunity or status resistance.
				if (!stun.isGarbage() && a.getSkills().getSkillByID("effects.stunned")==stun)
				{
					turn.TerrorUsed=true;a.setActionPoints(0);this.removeSelf();
					local owner=bv.readValkyrieCombatWeakRef(source.Ref);
					bv.playValkyrieSkillAudio(owner,"abigail_terror_trigger",bv.captureValkyrieSkillAudioPosition(a));
					bv.playValkyrieVisual(this,a,"abigail_terror_sigil");
				}
			}
			if (this.m.Attempts>=2) this.removeSelf();
		}
	}
	function getTooltip()
	{
		local t=::$bvvar{namespace}.getAbigailTurn(this.getContainer().getActor());
		local remaining=::Math.min(2,::Math.max(0,this.m.ExpiresAfterTurn-t.Serial+(t.Normal?1:0)));
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/turns.png",text="$bv{abigail.remaining}"+remaining}];
		if (this.m.Kind=="prayer") ret.push({id=4,type="text",icon="ui/icons/fatigue.png",text="$bv{abigail.recoveries}"+this.m.Recoveries+"\n"+(this.m.BoostReady?"$bv{abigail.boost_ready}":"$bv{abigail.boost_used}")});
		if (this.m.Kind=="terror") ret.push({id=5,type="text",icon="ui/icons/bravery.png",text="$bv{abigail.terror_chance}"+this.terrorChance()+"%\n$bv{abigail.attempts}"+(2-this.m.Attempts)});
		if (this.m.Kind=="trial") ret.push({id=6,type="text",icon="ui/icons/action_points.png",text=this.m.APUsed?"$bv{abigail.ap_used}":"$bv{abigail.ap_pending}"});
		return ret;
	}
	function onDeath(fatality) { this.removeSelf(); }
});
