this.saber_excalibur_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = { Spec=null, IsSpent=false, Uses=0 },
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsAttack=false;this.m.IsWeaponSkill=true;this.m.ActionPointCost=7;this.m.FatigueCost=40;this.m.MinRange=1;this.m.MaxRange=8;this.m.IsSpent=false; this.m.Uses <- 0;}
	function onValkyrieSkillBound(_d){this.m.Spec=_d.Spec;this.m.ActionPointCost=this.m.Spec.ActionPointCost;this.m.FatigueCost=this.m.Spec.FatigueCost;this.m.MinRange=this.m.Spec.MinRange;this.m.MaxRange=this.m.Spec.MaxRange;}
	function getManaEffect(){local c=this.getContainer();return c==null?null:c.getSkillByID("$bvvar{modId}.effects.saber_mana");}
	function hasMeleeWeapon(){local a=this.getContainer()==null?null:this.getContainer().getActor();if(a==null||a.getItems()==null)return false;local w=a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);return w!=null&&w.isItemType(this.Const.Items.ItemType.MeleeWeapon);}
	function isUsable(){local e=this.getManaEffect();return this.skill.isUsable()&&this.m.Uses < (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 2 : 1)&&e!=null&&e.getCount()==4&&this.hasMeleeWeapon();}
	function onVerifyTarget(_o,_t){if(!this.skill.onVerifyTarget(_o,_t)||_t==null||!_t.IsOccupiedByActor)return false;local a=this.getContainer()==null?null:this.getContainer().getActor();local target=_t.getEntity();return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(a,target,this.m.MaxRange,true)&&a.getTile().getDistanceTo(target.getTile())>=this.m.MinRange&&::$bvvar{namespace}.getValkyrieSixDirectionLineTiles(a.getTile(),target.getTile()).len()>0;}
	function getTargets(_user,_targetTile){local tiles=::$bvvar{namespace}.getValkyrieWideLineTiles(_user.getTile(),_targetTile,1);return ::$bvvar{namespace}.sortValkyrieTargetsByDistance(_user.getTile(),::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,tiles),false);}
	function isOwnWeaponAttack(_skill,_target){local a=this.getContainer()==null?null:this.getContainer().getActor();local p=::$bvvar{namespace}.getCurrentValkyrieWeaponAttackPolicy(a,_skill,_target);return p!=null&&"SourceSkillRef" in p&&::$bvvar{namespace}.readValkyrieCombatWeakRef(p.SourceSkillRef)==this;}
	function onAnySkillUsed(_skill,_target,_properties){if(_properties!=null&&this.isOwnWeaponAttack(_skill,_target))_properties.MeleeSkill+=this.m.Spec==null?50:this.m.Spec.HitChance;}
	function getFixedDamage(_bravery){return 50+this.Math.floor(_bravery*0.25);}
	function getTooltip(){local r=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/hitchance.png",text="$bv{skill.saber_excalibur.tooltip.hit}"},{id=5,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.saber_excalibur.tooltip.damage}"},{id=6,type="text",icon="ui/icons/direct_damage.png",text="$bv{skill.saber_excalibur.tooltip.fixed}"},{id=7,type="text",icon="ui/icons/special.png",text="$bv{skill.saber_excalibur.tooltip.beam}"}];if("hasSaberBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberBondUpgrade(this.getContainer().getActor(),100))r.push({id=10,type="text",icon="ui/icons/fatigue.png",text="$bv{skill.saber_excalibur.bond_refund}"});if(this.m.IsSpent)r.push({id=8,type="text",icon="ui/tooltips/warning.png",text="$bv{skill.saber_excalibur.tooltip.spent}"});return r;}
	function onUse(_user,_targetTile)
	{
		local e=this.getManaEffect();if(_user==null||_targetTile==null||e==null||e.getCount()!=4||this.m.Uses >= (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 2 : 1)||!this.hasMeleeWeapon())return false;
		local targets=this.getTargets(_user,_targetTile);if(targets.len()==0)return false;local bravery=_user.getCurrentProperties().Bravery;local fixedDamage=this.getFixedDamage(bravery);local context=::$bvvar{namespace}.getCurrentValkyrieActionContext(_user,this);local actionToken=context!=null&&"ActionToken" in context?context.ActionToken:null;
		e.setCount(0);this.m.Uses++;this.m.IsSpent=this.m.Uses >= (("hasGrailBlessing" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) ? 2 : 1);
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "saber_excalibur_cast");
		if ("playValkyrieVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieVisual(this, _user, "saber_excalibur_cast");
		if ("playSaberLineVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playSaberLineVisual(this,_user,_targetTile,true);
		local hitSounds = 0;
		foreach (t in targets)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user)) break;
			if (::$bvvar{namespace}.isActorDeadOrDying(t)) continue;
			local soundPosition = "captureValkyrieSkillAudioPosition" in ::$bvvar{namespace} ? ::$bvvar{namespace}.captureValkyrieSkillAudioPosition(t) : null;

			local result=::$bvvar{namespace}.applyValkyrieWeaponAttack(_user,this,t,{WeaponDamageMult=2.0,ArmorDamageMult=2.0,DirectDamageAdd=0.30,IgnoreDistance=true,IgnoreShield=true,ParentActionToken=actionToken});
			if (result!=null && result.Hit && soundPosition!=null && hitSounds<2 && "playValkyrieSkillAudio" in ::$bvvar{namespace})
			{
				if (::$bvvar{namespace}.playValkyrieSkillAudio(_user,"saber_excalibur_impact",soundPosition)) hitSounds++;
			}
			if(result!=null&&result.Hit&&!::$bvvar{namespace}.isActorDeadOrDying(t))::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user,this,t,fixedDamage,{ActionToken=actionToken,Source="saber_excalibur_fixed"});
		}
		if (!::$bvvar{namespace}.isActorDeadOrDying(_user) && "hasSaberBondUpgrade" in ::$bvvar{namespace} && ::$bvvar{namespace}.hasSaberBondUpgrade(_user,100)) e.addCount(1);
		return true;
	}
	function onCombatStarted(){this.m.IsSpent=false; this.m.Uses=0;}
	function onCombatFinished(){this.m.IsSpent=false; this.m.Uses=0;this.skill.onCombatFinished();}
});
