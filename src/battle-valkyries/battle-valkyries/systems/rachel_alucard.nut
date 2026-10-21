// Initial Rachel kit. Identity is persistent; all resource and field state is combat-only.
::$bvvar{namespace}.Rachel <- {
	Owners = [], Epoch = 0,
	function api() { return ::$bvvar{namespace}; },
	function alive(a) { return a != null && !this.api().isActorDeadOrDying(a) && a.isPlacedOnMap(); },
	function owns(a) { return a != null && a.isPlayerControlled() && this.api().getActorValkyrieID(a) == "rachel_alucard"; },
	// Only a completed personal-bond reward may write this flag. Chapter rewards
	// and appearance never imply a bond stage; old actors remain at stage zero.
	function stage(a)
	{
		if(!this.owns(a))return 0;
		local n=a.getFlags().get("$bvvar{modId}.rachel.bond_stage");
		return typeof n=="integer"?::Math.max(0,::Math.min(5,n)):0;
	},
	function tuning(a)
	{
		local n=this.stage(a);
		return {Stage=n,SeedAP=n>=1?2:3,SeedFatigue=n>=1?8:10,SeedDamage=n>=5?55:40,Needles=n>=5?2:1,
			IrisFatigue=n>=2?10:12,IrisDamage=n>=5?55:40,WindRecovery=n>=2?2:1,OpeningHeat=n>=3?20:0,
			AstralDamage=n>=5?2400:(n>=3?1600:1200),GeorgeHP=n>=3?60:30,GeorgeDamage=n>=3?60:40,BatDamage=n>=3?25:15,IvyDamage=n>=3?15:10,
			SuperAP=n>=4?5:6,LilyFatigue=n>=4?25:30,LilyBody=n>=4?100:80,LilySource=n>=4?80:60,
			DahliaFatigue=n>=4?24:28,DahliaDamage=n>=4?120:90,Armor=n>=4?1.5:1.0,OD=n>=5?1.5:1.25,
			ChargeBonus=n>=5?0.50:(n>=3?0.35:0.25),AttachedBonus=n>=5?0.75:(n>=3?0.60:0.50)};
	},
	function charge(a,b)
	{
		if(!this.enemy(a,b))return;
		local e=b.getSkills().getSkillByID("$bvvar{modId}.effect.rachel_slow");
		if(e==null){e=::new("$bvvar{privateFolder}/skills/effects/rachel_alucard_slow_effect");b.getSkills().add(e);}
		e.setOwner(a,this.tuning(a).ChargeBonus);
		b.getSkills().update();b.setDirty(true);
	},
	function chargeBonus(a,b)
	{
		local e=b.getSkills().getSkillByID("$bvvar{modId}.effect.rachel_slow");
		return e!=null?e.bonusFor(a):0.0;
	},
	function thunder(a,b,source,amount,attached=false)
	{
		// Both familiar rewards add to the same multiplier. A source is still
		// consumed once; George cannot amplify his own discharge.
		return this.strike(a,b,source,amount*(1.0+this.chargeBonus(a,b)+(attached?this.tuning(a).AttachedBonus:0.0)),"lightning");
	},
	function able(a) { return this.owns(a) && this.api().EightValkyries.able(a); },
	function enemy(a,b) { return this.alive(a) && this.alive(b) && !a.isAlliedWith(b) && b.isAttackable(); },
	function state(a) { return a != null && "BVRachel" in a.m ? a.m.BVRachel : null; },
	function hud(a)
	{
		local s=this.state(a);if(!this.owns(a)||!this.alive(a)||s==null||!s.Active)return null;
		local sources=[];
		foreach(r in s.Rods)if(this.rodTile(r)!=null&&r.Until!=-1)
			sources.push({Kind=r.Host!=null?"attached":r.Kind,Label=r.Host!=null?"$bv{rachel.hud.attached}":(r.Kind=="bat"?"$bv{rachel.hud.bat}":"$bv{rachel.hud.rod}")});
		return {Wind=s.Wind,Heat=s.Heat,Sources=sources,OD=this.od(a),ODUsed=s.ODUsed,
			Title="$bv{rachel.hud.title}",WindLabel="$bv{rachel.hud.wind}",HeatLabel="$bv{rachel.hud.heat}",SourceLabel="$bv{rachel.hud.sources}",
			Ready=s.Heat>=50,ReadyLabel=s.Heat>=50?"$bv{rachel.hud.ready}": ::format("$bv{rachel.hud.charging}",50-s.Heat),
			ODLabel=this.od(a)?"$bv{rachel.hud.od_active}":(s.ODUsed?"$bv{rachel.hud.od_used}":"$bv{rachel.hud.od_ready}"),
			WindHint=s.WindRound==s.Turn?"$bv{rachel.hud.wind_used}":"$bv{rachel.hud.wind_ready}",
			Hint=s.Selection!=null?"$bv{rachel.hud.choose_landing}":(sources.len()>0?"$bv{rachel.hud.field_ready}":"$bv{rachel.hud.plant}"),
			EmptyLabel="$bv{rachel.hud.empty}"};
	},
	function start(a)
	{
		if (!this.owns(a) || !this.alive(a)) return;
		local s=this.state(a); if(s!=null){s.Active=true;return;}
		a.m.BVRachel <- { Active=true, Heat=this.tuning(a).OpeningHeat, Wind=4, Turn=0, LastRound=-1, EndRound=-1, WindRound=-1,
			ODUsed=false, ODUntil=0, AstralUsed=false, Rods=[], Ivy=null, George=null, GeorgeUntil=0, GeorgePaid=false,
			Selection=null, Move=null, Actions={}, DamageActions={}, ParasolGuard=false, ParasolReady=0, ParasolPending=null };
		this.Owners.push(this.api().makeValkyrieCombatWeakRef(a));
	},
	function gain(a,n) { local s=this.state(a); if(s!=null&&s.Active&&this.alive(a)){s.Heat=::Math.min(100,::Math.max(0,s.Heat+n));a.setDirty(true);} },
	function wind(a,n) { local s=this.state(a); if(s!=null&&s.Active&&this.alive(a)){s.Wind=::Math.min(4,::Math.max(0,s.Wind+n));a.setDirty(true);} },
	function od(a) { local s=this.state(a);return s!=null&&s.ODUntil>s.Turn; },
	function visual(t,cue) { if(t==null)return;local anchor={isAlive=function(){return true;},isDying=function(){return false;},isPlacedOnMap=function(){return true;},getTile=function(){return t;}};this.api().playValkyrieVisual(this,anchor,"rachel_"+cue); },
	function enemies(a) { local out=[];foreach(group in ::Tactical.Entities.getAllInstances())foreach(b in group)if(this.enemy(a,b))out.push(b);return out; },
	function nearest(a,t) { local chosen=null;foreach(b in this.enemies(a))if(b.getTile().IsVisibleForEntity&&(chosen==null||t.getDistanceTo(b.getTile())<t.getDistanceTo(chosen.getTile())))chosen=b;return chosen; },
	function rodTile(r) { if(r.Host!=null){local b=this.api().readValkyrieCombatWeakRef(r.Host);return this.alive(b)?b.getTile():null;}
return r.Tile; },
	function hide(r) { if(r!=null&&"Mark" in r&&r.Mark!=null){r.Mark.Visible=false;r.Mark.Alpha=0;r.Mark=null;} },
	function layoutRods(a)
	{
		local s=this.state(a);if(s==null)return;
		local groups={};
		foreach(r in s.Rods)
		{
			if(r.Kind!="rod"||r.Mark==null)continue;
			local t=this.rodTile(r);if(t==null)continue;
			if(!(t.ID in groups))groups[t.ID]<-[];
			groups[t.ID].push(r);
		}
		foreach(group in groups)
		{
			local count=group.len(),spacing=count==2?36.0:24.0;
			foreach(i,r in group)r.Mark.setOffset(::createVec((i-(count-1)*0.5)*spacing,0));
		}
	},
	function draw(a,r) { this.hide(r);local t=this.rodTile(r);if(t!=null)r.Mark=t.spawnDetail(r.Kind=="rod"?"entity_bv_rachel_alucard_rod":"entity_bv_rachel_alucard_bat",::Const.Tactical.DetailFlag.None,false,true);this.layoutRods(a); },
	function prune(a)
	{
		local s=this.state(a);if(s==null)return;
		for(local i=s.Rods.len()-1;i>=0;--i)if(this.rodTile(s.Rods[i])==null){this.hide(s.Rods[i]);s.Rods.remove(i);}
		this.layoutRods(a);
	},
	function plant(a,t)
	{
		local s=this.state(a);if(s==null||!s.Active||!this.alive(a))return;
		while(s.Rods.len()>=3){this.hide(s.Rods[0]);s.Rods.remove(0);}
		local r={Kind="rod",Tile=t,Host=null,Target=null,Until=0,Paid=false,Mark=null};s.Rods.push(r);this.draw(a,r);
	},
	function segment(a,source,amount,kind)
	{
		local skill=::new("$bvvar{privateFolder}/skills/actives/rachel_alucard_segment_skill");skill.setContainer(a.getSkills());
		skill.m.RachelDamage=amount;skill.m.RachelKind=kind;skill.m.BVSkillKey=source!=null&&"BVSkillKey" in source.m?source.m.BVSkillKey:null;
		skill.m.IsRanged=kind=="shot";skill.m.IsShieldRelevant=kind!="lightning"&&kind!="astral";skill.m.DirectDamageMult=kind=="lightning"||kind=="gerbera"||kind=="astral"?0.4:(kind=="shot"?0.25:0.2);
		return skill;
	},
	function strike(a,b,source,amount,kind)
	{
		if(!this.enemy(a,b))return {Hit=false,Damaged=false};
		local skill=this.segment(a,source,amount,kind),before=this.api().snapshotValkyrieDamageState(b),hit=false;
		if(kind!="lightning"&&kind!="astral")hit=skill.attackEntity(a,b,false);
		else
		{
			local route=this.api().prepareValkyrieAttackAttempt(a,skill,b);
			if(route==null)return {Hit=false,Damaged=false};
			try
			{
				local p=a.getSkills().buildPropertiesForUse(skill,b),info=clone ::Const.Tactical.HitInfo;
				info.DamageRegular=p.DamageRegularMin*p.DamageRegularMult*p.DamageTotalMult;info.DamageArmor=p.DamageRegularMin*p.DamageArmorMult*p.DamageTotalMult;
				info.DamageDirect=0.4;info.BodyPart=::Const.BodyPart.Body;info.BodyDamageMult=1.0;info.DamageFatigue=0;info.FatalityChanceMult=0.0;
				b.onDamageReceived(a,skill,info);local after=this.api().snapshotValkyrieDamageState(b);
				if(this.api().isPendingValkyrieAttempt(route.Attempt))this.api().resolveValkyrieTargetAttempt(route.Attempt,true,info.BodyPart,::Math.max(0,before.Hitpoints-after.Hitpoints),::Math.max(0,before.HeadArmor+before.BodyArmor-after.HeadArmor-after.BodyArmor));
				this.api().completeValkyrieAttackAttempt(route,true);hit=true;
			}
			catch(e){this.api().failValkyrieAttackAttempt(route,"rachel_direct_spell_exception");throw e;}
		}
		local after=this.api().snapshotValkyrieDamageState(b);
		return {Hit=hit,Damaged=after.Hitpoints<before.Hitpoints||after.HeadArmor+after.BodyArmor<before.HeadArmor+before.BodyArmor};
	},
	function area(a,source,center,amount)
	{
		local damaged=false;this.visual(center,"lightning");
		foreach(b in this.api().getValkyrieEnemyTargetsOnTiles(a,this.api().getValkyrieRadiusTiles(center,1,true)))
		{if(!this.alive(a))break;if(this.thunder(a,b,source,amount).Damaged)damaged=true;}
		return damaged;
	},
	function detonate(a,source,lily)
	{
		local s=this.state(a),rods=s.Rods,t=this.tuning(a);s.Rods=[];local damaged=false,mult=lily&&this.od(a)?t.OD:1.0;
		if(lily)damaged=this.area(a,source,a.getTile(),t.LilyBody*mult);
		foreach(r in rods)
		{
			local tile=this.rodTile(r);this.hide(r);if(!this.alive(a)||tile==null)continue;
			if(r.Host!=null){local b=this.api().readValkyrieCombatWeakRef(r.Host);if(this.enemy(a,b)&&this.thunder(a,b,source,(lily?t.LilySource:t.IrisDamage)*mult,true).Damaged)damaged=true;}
			else if(this.area(a,source,tile,(lily?t.LilySource:t.IrisDamage)*mult))damaged=true;
		}
		if(!lily&&damaged)this.gain(a,10);
	},
	function passable(from,t,fly=false) { return t!=null&&t.IsVisibleForEntity&&(t.IsEmpty||fly&&t.IsOccupiedByActor)&&::Math.abs(from.Level-t.Level)<=1; },
	function path(from,dest,max,fly=false)
	{
		if(from==null||dest==null||from.ID==dest.ID)return null;
		local queue=[{Tile=from,Path=[]}],seen={};seen[from.ID]<-true;
		for(local i=0;i<queue.len();++i)
		{
			local n=queue[i];if(n.Path.len()>=max)continue;
			for(local d=0;d<6;++d)if(n.Tile.hasNextTile(d))
			{local t=n.Tile.getNextTile(d);if(t.ID in seen||!this.passable(n.Tile,t,fly))continue;seen[t.ID]<-true;local p=clone n.Path;p.push(t);if(t.ID==dest.ID)return p;queue.push({Tile=t,Path=p});}
		}
		return null;
	},
	function toward(t,target,fly=false)
	{
		local chosen=null;for(local d=0;d<6;++d)if(t.hasNextTile(d)){local n=t.getNextTile(d);if(this.passable(t,n,fly)&&n.getDistanceTo(target)<t.getDistanceTo(target)&&(chosen==null||n.getDistanceTo(target)<chosen.getDistanceTo(target)))chosen=n;}
		return chosen;
	},
	function batStep(a,r,dest=null)
	{
		if(r.Host!=null)return;
		local b=this.api().readValkyrieCombatWeakRef(r.Target);if(!this.enemy(a,b))b=this.nearest(a,r.Tile);if(b==null)return;
		r.Target=this.api().makeValkyrieCombatWeakRef(b);local to=dest!=null?dest:(r.Tile.ID==b.getTile().ID?r.Tile:this.toward(r.Tile,b.getTile(),true));if(to==null)return;
		r.Tile=to;
		if(to.IsOccupiedByActor&&this.enemy(a,to.getEntity()))
		{
			b=to.getEntity();local result=this.strike(a,b,null,this.tuning(a).BatDamage,"shot");
			if(result.Damaged&&!r.HeatGroup.Paid){r.HeatGroup.Paid=true;this.gain(a,10);}
			if(result.Hit&&this.alive(b))r.Host=this.api().makeValkyrieCombatWeakRef(b);else{r.Host=this.api().makeValkyrieCombatWeakRef(b);r.Until=-1;}
		}
		this.draw(a,r);
	},
	function lotus(a,target)
	{
		local s=this.state(a),group={Paid=false};foreach(r in s.Rods)if(r.Kind=="rod"){r.Kind="bat";r.HeatGroup<-group;r.Target=this.api().makeValkyrieCombatWeakRef(target);r.Until=s.Turn+1;this.batStep(a,r);}
this.expire(a,false);
	},
	function ivy(a,target=null,forced=false,entry=null)
	{
		local s=this.state(a);if(s==null||s.Ivy==null||!s.Active||!this.alive(a))return;
		local cloud=s.Ivy;
		foreach(b in this.enemies(a))
		{
			if(target!=null&&b.getID()!=target.getID()||(entry!=null&&target!=null&&b.getID()==target.getID()?entry:b.getTile()).getDistanceTo(cloud.Tile)>1)continue;
			local id=b.getID();if(!forced&&id in cloud.Hits&&cloud.Hits[id]==::Time.getRound())continue;
			if(!forced)cloud.Hits[id]<-::Time.getRound();local loss=::Math.min(this.tuning(a).IvyDamage,::Math.max(0,b.getHitpoints()-1));if(loss<=0)continue;
			// Pure erosion has no attack callbacks, cannot kill, and never grants Heat.
			b.setHitpoints(b.getHitpoints()-loss);b.setDirty(true);this.visual(b.getTile(),"bat_cloud");
		}
	},
	function clearGeorge(a)
	{
		local s=this.state(a);if(s==null)return;local g=this.api().readValkyrieCombatWeakRef(s.George);s.George=null;
		if(this.alive(g))g.removeFromMap();
	},
	function george(a)
	{
		local s=this.state(a);if(s==null||!s.Active||!this.alive(a))return;local g=this.api().readValkyrieCombatWeakRef(s.George);if(!this.alive(g)){s.George=null;return;}
		local targets=this.api().getValkyrieEnemyTargetsOnTiles(a,this.api().getValkyrieRadiusTiles(g.getTile(),1,true));if(targets.len()==0)return;
		s.George=null;this.visual(g.getTile(),"george_shock");local damaged=false;
		foreach(b in targets)
		{
			if(!this.alive(a))break;local result=this.strike(a,b,null,this.tuning(a).GeorgeDamage,"lightning");if(result.Damaged)damaged=true;
			if(result.Damaged&&this.alive(b))this.charge(a,b);
		}
		if(damaged&&!s.GeorgePaid){s.GeorgePaid=true;this.gain(a,10);}
if(this.alive(g))g.removeFromMap();
	},
	function fieldEvent(target,entry=null)
	{
		foreach(ref in clone this.Owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(this.alive(a)){this.ivy(a,target,false,entry);this.george(a);}}
	},
	function expire(a,end)
	{
		local s=this.state(a);if(s==null)return;
		for(local i=s.Rods.len()-1;i>=0;--i){local r=s.Rods[i];if(this.rodTile(r)==null||r.Until==-1||end&&r.Kind=="bat"&&s.Turn>=r.Until){this.hide(r);s.Rods.remove(i);}}
		this.layoutRods(a);
		if(end&&s.Ivy!=null&&s.Turn>=s.Ivy.Until){this.hide(s.Ivy);s.Ivy=null;}
		if(end&&s.George!=null&&s.Turn>=s.GeorgeUntil)this.clearGeorge(a);
	},
	function tick(a)
	{
		local s=this.state(a);if(s==null||!s.Active||!this.alive(a)||!this.api().EightValkyries.normal(a)||s.LastRound==::Time.getRound())return;
		s.LastRound=::Time.getRound();s.Turn++;s.Selection=null;
		this.api().RachelEquipment.clearGuard(a);
		if(s.Turn>1)this.wind(a,this.od(a)?2:this.tuning(a).WindRecovery);
		foreach(r in clone s.Rods){if(!this.alive(a))break;if(r.Kind=="bat")this.batStep(a,r);}
		this.expire(a,false);local g=this.api().readValkyrieCombatWeakRef(s.George);
		if(this.alive(g)){local b=this.nearest(a,g.getTile()),to=b==null?null:this.toward(g.getTile(),b.getTile());if(to!=null)this.move(a,g,[to],null);else this.george(a);}
	},
	function end(a)
	{
		local s=this.state(a);if(s==null||!s.Active||!this.api().EightValkyries.normal(a)||s.EndRound==::Time.getRound())return;
		s.EndRound=::Time.getRound();this.expire(a,true);if(s.Turn>=s.ODUntil-1)s.ODUntil=0;
	},
	function onEvent(a,e)
	{
		local protected=this.api().RachelEquipment.resolveDamage(a,e);
		local s=this.state(a);if(s==null||!s.Active||e==null||e.Type!="DamageResolved"||e.Victim==null||e.Victim.getID()!=a.getID()||e.Attacker==null||a.isAlliedWith(e.Attacker)||e.HitpointDamage+e.ArmorDamage<=0||!this.api().isDirectAttack(e.Skill))return;
		local token=e.ActionToken;if(token!=null&&!(token in s.DamageActions)){s.DamageActions[token]<-true;this.gain(a,5);}
		if(protected)return;
		this.clearGeorge(a);if(s.Ivy!=null){this.hide(s.Ivy);s.Ivy=null;}
		for(local i=s.Rods.len()-1;i>=0;--i)if(s.Rods[i].Kind=="bat"&&s.Rods[i].Host==null){this.hide(s.Rods[i]);s.Rods.remove(i);}
	},
	function stop(a)
	{
		local s=this.state(a);if(s==null)return;s.Active=false;s.Heat=0;s.Wind=0;s.ODUntil=0;s.Selection=null;
		this.api().RachelEquipment.clearGuard(a);
		if(s.Move!=null)this.finishMove(s.Move);this.clearGeorge(a);foreach(r in s.Rods)this.hide(r);s.Rods=[];this.hide(s.Ivy);s.Ivy=null;
	},
	function reset(){this.Epoch++;foreach(ref in this.Owners){local a=this.api().readValkyrieCombatWeakRef(ref);if(a!=null){this.stop(a);a.m.BVRachel=null;}}
this.Owners=[];},
	function finishMove(j)
	{
		if(j==null||j.Done)return;j.Done=true;if(j.State.Move==j)j.State.Move=null;this.api().endValkyrieMovement(j.Hold);
		if(j.Continuation!=null)this.api().releaseValkyrieActionContinuation(j.Context,j.Continuation);
	},
	function move(owner,mover,path,context)
	{
		local s=this.state(owner);if(s==null||s.Move!=null||path==null||path.len()==0)return false;
		local j={Owner=this.api().makeValkyrieCombatWeakRef(owner),Mover=this.api().makeValkyrieCombatWeakRef(mover),State=s,Path=clone path,Index=0,Done=false,Step=null,Hold=null,Context=context,Continuation=null,Epoch=this.Epoch};
		local service=this;j.Hold=this.api().beginValkyrieMovement(mover,function(){service.finishMove(j);});if(j.Hold==null)return false;
		s.Move=j;if(context!=null)j.Continuation=this.api().reserveValkyrieActionContinuation(context,"rachel-wind");
		try{this.step(j);}
catch(e){this.finishMove(j);throw e;}
return true;
	},
	function step(j)
	{
		local a=this.api().readValkyrieCombatWeakRef(j.Owner),m=this.api().readValkyrieCombatWeakRef(j.Mover);
		if(j.Done||j.Epoch!=this.Epoch||!this.alive(a)||!this.alive(m)||!j.State.Active||m.getCurrentProperties().IsRooted||j.Index>=j.Path.len()){this.finishMove(j);return;}
		local to=j.Path[j.Index];if(!this.passable(m.getTile(),to)){this.finishMove(j);return;}
		local step={Job=j,Tile=to,Queued=false};j.Step=step;
		::Time.scheduleEvent(::TimeUnit.Virtual,1800,function(x){if(!x.Job.Done&&x.Job.Step==x)::$bvvar{namespace}.Rachel.finishMove(x.Job);},step);
		this.visual(m.getTile(),"wind");m.setCurrentMovementType(::Const.Tactical.MovementType.Involuntary);
		::Tactical.getNavigator().teleport(m,to,this.arrival.bindenv(this),step,false,3.0);
	},
	function arrival(m,step)
	{
		if(step.Job.Done||step.Job.Step!=step||step.Queued)return;step.Queued=true;
		this.api().queueValkyrieMovementArrival(step.Job.Hold,this.arrived.bindenv(this),step);
	},
	function arrived(m,step)
	{
		local j=step.Job;if(j.Done||j.Step!=step)return;
		try{if(!this.alive(m)||m.getTile().ID!=step.Tile.ID){this.finishMove(j);return;}
j.Index++;j.Step=null;local a=this.api().readValkyrieCombatWeakRef(j.Owner);if(this.alive(a))this.george(a);this.step(j);}
		catch(e){this.finishMove(j);throw e;}
	}
};

::$bvvar{namespace}.finalizeRachelProperties <- function(a,skill,target,p)
{
	if(!::$bvvar{namespace}.Rachel.owns(a)||skill==null||!("RachelDamage" in skill.m))return p;
	local kind=skill.m.RachelKind;
	p.DamageRegularMin=skill.m.RachelDamage;p.DamageRegularMax=skill.m.RachelDamage;p.DamageRegularMult=1.0;
	p.DamageArmorMult=kind=="astral"?1.5:(kind=="lightning"?::$bvvar{namespace}.Rachel.tuning(a).Armor:(kind=="gerbera"?1.3:0.8));
	p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
	p.DamageAdditionalWithEachTile=0;p.HitChanceAdditionalWithEachTile=0;
	if(kind=="shot")p.RangedSkill+=20;else p.MeleeSkill+=kind=="gerbera"?30:20;
	return p;
};
