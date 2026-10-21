this.hokusai_painting_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill",{
	m={Spec=null,Cast=null},
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsWeaponSkill=false;this.m.IsRanged=true;this.m.IsUsingHitchance=true;
		this.m.IsShowingProjectile=false;this.m.ProjectileType=0;this.m.IsDoingAttackMove=false;
		this.m.IsIgnoredAsAOO=true;this.m.IsVisibleTileNeeded=true;this.m.MaxRangeBonus=0;this.m.MaxLevelDifference=99;
		this.m.InjuriesOnBody=this.Const.Injury.BluntBody;this.m.InjuriesOnHead=this.Const.Injury.BluntHead;
	}
	function onValkyrieSkillBound(d)
	{
		this.m.Spec=d.Spec;local s=this.m.Spec;
		this.m.ActionPointCost=s.AP;this.m.FatigueCost=s.Fatigue;this.m.MinRange=s.MinRange;this.m.MaxRange=s.MaxRange;
		this.m.IsAttack=s.Mode=="brush" || s.Mode=="alien" || s.Mode=="wave";
		this.m.IsTargeted=this.m.IsAttack;this.m.IsTargetingActor=this.m.IsAttack;
		this.m.IsAOE=s.Mode=="alien" || s.Mode=="wave";
		this.m.IsShieldRelevant=s.Mode!="wave";this.m.DirectDamageMult=s.Pierce;
	}
	function owner() { return this.getContainer().getActor(); }
	function isUsable()
	{
		local bv=::$bvvar{namespace},a=this.owner(),s=bv.getHokusaiState(a);
		return this.skill.isUsable() && bv.canHokusaiAct(a) && bv.hokusaiCooldown(a,this.getBattleValkyriesSkillKey())==0
			&& (this.m.Spec.Mode!="wave" || s.Inspiration>=6);
	}
	function validEnemy(target)
	{
		local a=this.owner();
		return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(a,target,this.m.MaxRange,true) && !target.isHiddenToPlayer()
			&& a.getTile().hasLineOfSightTo(target.getTile(),this.m.MaxRange);
	}
	function targets(origin,center)
	{
		local bv=::$bvvar{namespace},ret=[];
		if(center==null) return ret;
		local tiles=this.m.IsAOE?bv.getValkyrieRadiusTiles(center,1,true):[center];
		foreach(target in bv.getValkyrieEnemyTargetsOnTiles(this.owner(),tiles)) if(this.validEnemy(target)) ret.push(target);
		ret.sort(function(a,b) {
			local da=a.getTile().getDistanceTo(center),db=b.getTile().getDistanceTo(center);
			return da==db?(a.getID()<b.getID()?-1:(a.getID()==b.getID()?0:1)):(da<db?-1:1);
		});
		if(this.m.Spec.Mode=="alien" && ret.len()>3) ret.resize(3);
		return ret;
	}
	function onVerifyTarget(origin,tile)
	{
		if(!this.m.IsAttack) return true;
		return origin!=null && tile!=null && tile.IsOccupiedByActor && this.skill.onVerifyTarget(origin,tile)
			&& origin.getDistanceTo(tile)>=this.m.MinRange && this.validEnemy(tile.getEntity());
	}
	function onTargetSelected(tile)
	{
		if(!this.m.IsAttack || !this.onVerifyTarget(this.owner().getTile(),tile)) return;
		foreach(target in this.targets(this.owner().getTile(),tile))
		{
			local t=target.getTile();
			this.Tactical.getHighlighter().addOverlayIcon(this.Const.Tactical.Settings.AreaOfEffectIcon,t,t.Pos.X,t.Pos.Y);
		}
	}
	function getHitFactors(tile)
	{
		return ::$bvvar{namespace}.getValkyrieHitFactorsWithoutCover(this,tile);
	}
	function finalizePaintingProperties(target,p)
	{
		local bv=::$bvvar{namespace},a=this.owner(),spec=this.m.Spec,s=bv.getHokusaiState(a),cast=this.m.Cast;
		local resolve=cast==null?a.getCurrentProperties().getBravery():cast.Resolve;
		local damage=::Math.floor(spec.Base+resolve*spec.Resolve);
		local ink=target==null?null:bv.getHokusaiInk(target),count=ink==null?0:ink.m.Sources.len();
		local human=bv.isHokusaiHuman(target);
		if(cast!=null && target!=null && target.getID() in cast.Targets)
		{
			count=cast.Targets[target.getID()].Ink;human=cast.Targets[target.getID()].Human;
		}
		if(spec.Mode=="wave") damage=::Math.floor(damage*(1.0+0.15*count));
		p.DamageRegularMin=damage;p.DamageRegularMax=damage;p.DamageRegularMult=1.0;p.DamageArmorMult=spec.Armor;
		p.DamageDirectMult=1.0;p.DamageDirectAdd=0.0;p.DamageDirectMeleeAdd=0.0;p.DamageDirectRangedAdd=0.0;
		p.DamageAdditionalWithEachTile=0.0;p.HitChanceAdditionalWithEachTile=0.0;
		p.RangedSkill+=spec.Hit;
		p.HitChance[::Const.BodyPart.Head]=0;p.HitChance[::Const.BodyPart.Body]=100;
		p.HitChanceMult[::Const.BodyPart.Head]=1.0;p.HitChanceMult[::Const.BodyPart.Body]=1.0;
		// Generic damage perks remain in DamageTotalMult; finalization occurs once,
		// after all onAnySkillUsed callbacks (including Legends' duplicate dispatch).
		if(cast!=null?cast.Bond:(s!=null && s.Active && s.BondUntil>=0)) p.DamageTotalMult*=1.2;
		if(spec.Mode=="wave" && human) p.DamageTotalMult*=1.2;
		// Direct spells ignore cover; range and line of sight are checked separately.
	}
	function onUse(user,tile)
	{
		local bv=::$bvvar{namespace},context=bv.getCurrentValkyrieActionContext(user,this);
		if(!this.isUsable() || !this.onVerifyTarget(user.getTile(),tile) || context==null || context.IsFree || context.IsImplicit || context.Source!="managed_active") return false;
		local s=bv.getHokusaiState(user),key=this.getBattleValkyriesSkillKey(),mode=this.m.Spec.Mode;
		if(s.LastAction==context.ActionToken) return false;
		local targets=this.m.IsAttack?this.targets(user.getTile(),tile):[];
		if(this.m.IsAttack && targets.len()==0) return false;
		s.LastAction=context.ActionToken;s.Cooldowns[key] <- ::Time.getRound()+this.m.Spec.Cooldown;
		if(!this.m.IsAttack)
		{
			local turn=bv.getHokusaiTurn(user);
			if(mode=="nature")
			{
				s.NatureUntil=turn.Serial+1;bv.addHokusaiInspiration(user,2,this);
				bv.playValkyrieVisual(this,user,"hokusai_observation_ring");bv.playValkyrieSkillAudio(user,"hokusai_nature_cast");
			}
			else
			{
				s.BondUntil=turn.Serial+1;s.MoraleGuards=2;
				bv.playValkyrieVisual(this,user,"hokusai_toto_companion");bv.playValkyrieSkillAudio(user,"hokusai_bond_cast");
			}
			bv.refreshHokusaiActor(user);return true;
		}
		this.m.Cast={Resolve=user.getCurrentProperties().getBravery(),Bond=s.BondUntil>=0,Targets={}};
		foreach(target in targets)
		{
			local ink=bv.getHokusaiInk(target);
			this.m.Cast.Targets[target.getID()] <- {Ink=ink==null?0:ink.m.Sources.len(),Human=bv.isHokusaiHuman(target)};
		}
		if(mode=="wave") s.Inspiration-=6;
		s.Busy=true;
		local hitAny=false,impactPlayed=false,survivors=[],centerPosition=bv.captureValkyrieSkillAudioPosition(tile.getEntity());
		try
		{
			bv.playValkyrieSkillAudio(user,"hokusai_"+mode+"_cast");
			foreach(target in targets)
			{
				if(bv.isActorDeadOrDying(user) || !user.isPlacedOnMap()) break;
				if(!this.validEnemy(target)) continue;
				local position=bv.captureValkyrieSkillAudioPosition(target);
				bv.playValkyrieVisual(this,target,mode=="wave"?"hokusai_fuji_wave":(mode=="alien"?"hokusai_alien_ink":"hokusai_brush_slash"));
				// Reuse the existing attack policy to suppress held-item onDamageDealt.
				local policy=bv.pushValkyrieWeaponAttackPolicy(user,this,target,null,{Source="managed_active",IgnoreShield=mode=="wave"},this);
				local hit=false;
				try { hit=this.attackEntity(user,target,false); }
				catch(e) { bv.popValkyrieWeaponAttackPolicy(policy.Token);throw e; }
				bv.popValkyrieWeaponAttackPolicy(policy.Token);
				if(!hit) continue;
				hitAny=true;
				if(!impactPlayed) { bv.playValkyrieSkillAudio(user,"hokusai_"+mode+"_impact",this.m.IsAOE?centerPosition:position);impactPlayed=true; }
				if(bv.isActorDeadOrDying(user) || !user.isPlacedOnMap()) break;
				if(!bv.isEligibleValkyrieEnemyTarget(user,target)) continue;
				if(mode=="wave")
				{
					local ink=bv.getHokusaiInk(target);
					if(ink!=null) { ink.removeSelf();bv.refreshHokusaiActor(target); }
				}
				else
				{
					local applied=bv.applyHokusaiInk(user,target,this);survivors.push(target);
					local memory=bv.getRuntimeSkillByKey(user,"painted_harbor_human_stroke");
					if(applied && memory!=null && memory.consumeMemory("katsushika_hokusai"))
					{
						bv.applyHokusaiInk(user,target,this);
					}
				}
			}
			if(mode!="wave" && hitAny && s.Active && !bv.isActorDeadOrDying(user) && user.isPlacedOnMap())
			{
				if(s.IncomeRound!=::Time.getRound()) { s.IncomeRound=::Time.getRound();s.Income=0; }
				if(s.Income<2) { s.Income++;bv.addHokusaiInspiration(user,1,this); }
				if(this.m.Cast.Bond && s.BondUntil>=0 && s.FatherRound!=::Time.getRound())
				{
					foreach(target in survivors) if(bv.isEligibleValkyrieEnemyTarget(user,target))
					{
						local existing=bv.getHokusaiInk(target);
						if(existing!=null && existing.m.Sources.len()>=3) continue;
						if(bv.applyHokusaiInk(user,target,this))
						{
							s.FatherRound=::Time.getRound();bv.playValkyrieVisual(this,target,"hokusai_toto_companion");
							bv.playValkyrieSkillAudio(user,"hokusai_toto_assist",bv.captureValkyrieSkillAudioPosition(target));
						}
						break;
					}
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
			{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/special.png",text=bv.getHokusaiStateText(a)},
			{id=5,type="text",icon="ui/icons/turns.png",text="$bv{hokusai.cooldown}"+bv.hokusaiCooldown(a,this.getBattleValkyriesSkillKey())}];
		if(this.m.IsAttack) ret.push({id=6,type="text",icon="ui/icons/regular_damage.png",text="$bv{hokusai.spell.rules}"});
		if(!this.isUsable()) ret.push({id=7,type="text",icon="ui/tooltips/warning.png",text="$bv{hokusai.blocked}"});
		return ret;
	}
});
