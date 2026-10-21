this.abigail_witchcraft_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m={Spec=null,Cast=null},
	function create()
	{
		this.valkyrie_active_skill.create();this.m.IsWeaponSkill=false;this.m.IsRanged=true;this.m.IsShieldRelevant=false;
		this.m.IsShowingProjectile=false;this.m.ProjectileType=0;this.m.IsDoingAttackMove=false;
		this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=99;
		this.m.InjuriesOnBody=this.Const.Injury.BluntBody;this.m.InjuriesOnHead=this.Const.Injury.BluntHead;
	}
	function onValkyrieSkillBound(d)
	{
		this.m.Spec=d.Spec;local s=d.Spec;
		this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.MinRange;this.m.MaxRange=s.MaxRange;
		this.m.IsAttack=s.Mode=="root" || s.Mode=="gate";this.m.IsUsingHitchance=this.m.IsAttack;
		this.m.IsTargeted=s.Mode!="prayer";this.m.IsTargetingActor=this.m.IsTargeted;
		this.m.IsAOE=s.Mode=="terror" || s.Mode=="prayer";this.m.DirectDamageMult=s.Pierce;
	}
	function owner() { return this.getContainer().getActor(); }
	function isUsable()
	{
		local bv=::$bvvar{namespace},a=this.owner(),s=bv.getAbigailState(a);
		return this.skill.isUsable() && bv.canAbigailAct(a) && bv.abigailCooldown(a,this.getBattleValkyriesSkillKey())==0
			&& (this.m.Spec.Mode!="gate" || s.Keys>=6);
	}
	function validEnemy(target)
	{
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(this.owner(),target) && !target.isHiddenToPlayer();
	}
	function targets(center)
	{
		local bv=::$bvvar{namespace},ret=[];if(center==null) return ret;
		local tiles=this.m.Spec.Mode=="terror"?bv.getValkyrieRadiusTiles(center,1,true):[center];
		foreach(target in bv.getValkyrieEnemyTargetsOnTiles(this.owner(),tiles))
			if(this.validEnemy(target) && center.hasLineOfSightTo(target.getTile(),1)
				&& this.owner().getTile().hasLineOfSightTo(target.getTile(),this.m.MaxRange+1)) ret.push(target);
		return ret;
	}
	function onVerifyTarget(origin,tile)
	{
		if (!this.m.IsTargeted) return true;
		if (origin==null || tile==null || !tile.IsOccupiedByActor || !tile.IsVisibleForEntity || !this.skill.onVerifyTarget(origin,tile)
			|| origin.getDistanceTo(tile)<this.m.MinRange || origin.getDistanceTo(tile)>this.m.MaxRange
			|| !this.validEnemy(tile.getEntity()) || !origin.hasLineOfSightTo(tile,this.m.MaxRange)) return false;
		local bv=::$bvvar{namespace};
		if (this.m.Spec.Mode=="trial") return bv.canReceiveAbigailEffect(tile.getEntity(),"trial");
		if (this.m.Spec.Mode=="terror")
		{
			foreach(a in this.targets(tile)) if(bv.canReceiveAbigailEffect(a,"terror") || bv.canReceiveAbigailEffect(a,"erosion")) return true;
			return false;
		}
		return true;
	}
	function onTargetSelected(tile)
	{
		if (!this.m.IsTargeted || !this.onVerifyTarget(this.owner().getTile(),tile)) return;
		foreach(a in this.targets(tile))
		{
			local bv=::$bvvar{namespace};
			if(this.m.Spec.Mode=="terror" && !bv.canReceiveAbigailEffect(a,"terror") && !bv.canReceiveAbigailEffect(a,"erosion")) continue;
			local t=a.getTile();this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
		}
	}
	function getHitFactors(tile)
	{
		return ::$bvvar{namespace}.getValkyrieHitFactorsWithoutCover(this,tile);
	}
	function finalizeSpellProperties(target,p)
	{
		local bv=::$bvvar{namespace},a=this.owner(),s=this.m.Spec;
		local resolve=this.m.Cast==null?a.getCurrentProperties().getBravery():this.m.Cast.Resolve;
		local marked=this.m.Cast==null?(bv.getAbigailEffect(target,"terror")!=null || bv.getAbigailEffect(target,"erosion")!=null):this.m.Cast.Marked;
		local damage=::Math.floor(s.Base+s.Resolve*resolve);
		if(s.Mode=="gate" && marked) damage=::Math.floor(damage*1.25);
		p.DamageRegularMin=damage;p.DamageRegularMax=damage;p.DamageRegularMult=1.0;p.DamageArmorMult=s.Armor;
		p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;p.RangedDamageMult=1.0;
		p.DamageAdditionalWithEachTile=0.0;p.HitChanceAdditionalWithEachTile=0.0;p.RangedSkill+=s.Hit;
		p.HitChance[::Const.BodyPart.Head]=0;p.HitChance[::Const.BodyPart.Body]=100;
		p.HitChanceMult[::Const.BodyPart.Head]=1.0;p.HitChanceMult[::Const.BodyPart.Body]=1.0;
		// Direct spells ignore cover; range and line of sight are checked separately.
	}
	function onUse(user,tile)
	{
		local bv=::$bvvar{namespace},ctx=bv.getCurrentValkyrieActionContext(user,this);
		if(!this.isUsable() || !this.onVerifyTarget(user.getTile(),tile) || ctx==null || ctx.IsFree || ctx.IsImplicit || ctx.Source!="managed_active") return false;
		local s=bv.getAbigailState(user),mode=this.m.Spec.Mode,key=this.getBattleValkyriesSkillKey();
		if(s.LastAction==ctx.ActionToken) return false;
		s.LastAction=ctx.ActionToken;s.Cooldowns[key] <- ::Time.getRound()+this.m.Spec.Cooldown;
		local resolve=user.getCurrentProperties().getBravery();
		if(mode=="prayer")
		{
			local memory=bv.getRuntimeSkillByKey(user,"painted_harbor_homeward_prayer");
			local homeward=memory!=null && memory.consumeMemory("abigail_williams");
			foreach(a in ::World.getPlayerRoster().getAll())
				if(!bv.isActorDeadOrDying(a) && a.isPlacedOnMap() && a.isPlayerControlled() && (a==user || bv.isEligibleRosterAlly(user,a)) && user.getTile().getDistanceTo(a.getTile())<=3
					&& user.getTile().hasLineOfSightTo(a.getTile(),3) && bv.applyAbigailEffect(user,a,"prayer",resolve))
				{
					if(homeward) a.setFatigue(::Math.max(0,a.getFatigue()-10));
					bv.playValkyrieVisual(this,a,"abigail_prayer_ring");
				}
			bv.addAbigailKeys(user,2,this);bv.playValkyrieSkillAudio(user,"abigail_prayer_cast");return true;
		}
		if(mode=="terror")
		{
			bv.playValkyrieSkillAudio(user,"abigail_hysteria_cast");
			foreach(a in this.targets(tile))
			{
				if(bv.isActorDeadOrDying(user) || !user.isPlacedOnMap()) break;
				local applied=bv.applyAbigailEffect(user,a,"erosion",resolve);
				if(bv.applyAbigailEffect(user,a,"terror",resolve)) applied=true;
				if(applied) bv.playValkyrieVisual(this,a,"abigail_terror_sigil");
			}
			return true;
		}
		local target=tile.getEntity(),position=bv.captureValkyrieSkillAudioPosition(target);
		if(mode=="trial")
		{
			if(bv.applyAbigailEffect(user,target,"trial",resolve))
			{
				bv.addAbigailKeys(user,1,this);bv.playValkyrieVisual(this,target,"abigail_trial_chains");
				bv.playValkyrieSkillAudio(user,"abigail_trial_apply",position);
			}
			return true;
		}
		this.m.Cast={Resolve=resolve,Marked=bv.getAbigailEffect(target,"terror")!=null || bv.getAbigailEffect(target,"erosion")!=null};
		if(mode=="gate") s.Keys-=6;s.Busy=true;
		try
		{
			bv.playValkyrieSkillAudio(user,mode=="gate"?"abigail_qliphoth_cast":"abigail_root_cast");
			if(mode=="gate")
			{
				bv.playValkyrieVisual(this,target,"abigail_qliphoth_gate");
				if(bv.dispelAbigailBuffs(target)>0) bv.playValkyrieSkillAudio(user,"abigail_qliphoth_dispel",position);
			}
			if(!bv.isActorDeadOrDying(user) && user.isPlacedOnMap() && this.validEnemy(target))
			{
				local policy=bv.pushValkyrieWeaponAttackPolicy(user,this,target,null,{Source="managed_active",IgnoreShield=true},this),hit=false;
				try { hit=this.attackEntity(user,target,false); }
				catch(e) { bv.popValkyrieWeaponAttackPolicy(policy.Token);throw e; }
				bv.popValkyrieWeaponAttackPolicy(policy.Token);
				if(hit)
				{
					bv.playValkyrieSkillAudio(user,mode=="gate"?"abigail_qliphoth_impact":"abigail_root_impact",position);
					if(!bv.isActorDeadOrDying(target)) bv.playValkyrieVisual(this,target,mode=="gate"?"abigail_qliphoth_impact":"abigail_root_impact");
					if(mode=="root" && s.HitRound!=::Time.getRound()) { s.HitRound=::Time.getRound();bv.addAbigailKeys(user,1,this); }
				}
				// Both outcomes consume only this system's marks; dispel is not rolled back.
				if(mode=="gate" && !bv.isActorDeadOrDying(target))
				{
					foreach(kind in ["terror","erosion"]) { local e=bv.getAbigailEffect(target,kind);if(e!=null)e.removeSelf(); }
					bv.refreshAbigailActor(target);
				}
			}
		}
		catch(e) { this.m.Cast=null;s.Busy=false;throw e; }
		this.m.Cast=null;s.Busy=false;user.setDirty(true);return true;
	}
	function getTooltip()
	{
		local bv=::$bvvar{namespace},a=this.owner();
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},
			{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/special.png",text=bv.getAbigailStateText(a)},
			{id=5,type="text",icon="ui/icons/turns.png",text="$bv{abigail.cooldown}"+bv.abigailCooldown(a,this.getBattleValkyriesSkillKey())}];
		if(this.m.IsAttack) ret.push({id=6,type="text",icon="ui/icons/regular_damage.png",text="$bv{abigail.spell_rules}"});
		if(!this.isUsable()) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{abigail.blocked}"});
		return ret;
	}
});
