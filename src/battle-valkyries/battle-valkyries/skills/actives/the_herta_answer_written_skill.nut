this.the_herta_answer_written_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	m = {},
	function create()
	{
		this.valkyrie_active_skill.create();
		this.m.IsTargeted = true; this.m.IsTargetingActor = true; this.m.IsAttack = true; this.m.IsRanged = true; this.m.IsWeaponSkill = true;
		this.m.ActionPointCost = 5; this.m.FatigueCost = 30; this.m.MinRange = 1; this.m.MaxRange = 7; this.m.MaxRangeBonus = 0; this.m.IsShieldRelevant = false;
	}
	function getPassive() { local c = this.getContainer(); return c == null ? null : c.getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("the_herta_optimal_solution")); }
	function hasWeapon() { local a=this.getContainer()==null?null:this.getContainer().getActor(); local w=null; try{w=a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);}catch(e){} return w!=null&&w.isItemType(this.Const.Items.ItemType.Weapon); }
	function isUsable() { local p=this.getPassive(); return this.skill.isUsable() && this.hasWeapon() && p!=null && p.hasFullInspiration(); }
	function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile) || _targetTile == null || !_targetTile.IsOccupiedByActor) return false;
		local actor=this.getContainer()==null?null:this.getContainer().getActor(); return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(actor,_targetTile.getEntity(),this.m.MaxRange,true);
	}
	function getLowerArmorPart( _target )
	{
		local head=0, body=0; try{head=_target.getArmor(this.Const.BodyPart.Head); body=_target.getArmor(this.Const.BodyPart.Body);}catch(e){}
		return head < body ? this.Const.BodyPart.Head : this.Const.BodyPart.Body;
	}
	function strike( _user, _target, _primary )
	{
		local spec = _primary
			? { WeaponDamageMult=1.80, ArmorDamageMult=2.0, DirectDamageAdd=0.30, HitChance=35, PostFixedHP=40 }
			: { WeaponDamageMult=1.30, ArmorDamageMult=1.50, DirectDamageAdd=0.15, HitChance=25, PostFixedHP=15 };
		spec.IgnoreDistance <- true; spec.IgnoreShield <- true; spec.HighOfTwoDamageRoll <- true; spec.ForcedBodyPart <- this.getLowerArmorPart(_target); spec.Source <- "the_herta_answer_written";
		::$bvvar{namespace}.applyValkyrieWeaponAttack(_user,this,_target,spec);
	}
	function onUse( _user, _targetTile )
	{
		local passive=this.getPassive(); if(_user==null||passive==null||!passive.hasFullInspiration()||!this.hasWeapon()||!this.onVerifyTarget(_user.getTile(),_targetTile))return false;
		local primary=_targetTile.getEntity(); local targets=::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user,::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile,2,true));
		if (::$bvvar{namespace}.isActorDeadOrDying(_user)) return false;
		passive.consumeAllInspiration();
		::$bvvar{namespace}.playValkyrieVisual(this,_user,"the_herta_cast");
		::$bvvar{namespace}.playValkyrieVisual(this,primary,::$bvvar{namespace}.HertaCombat.sword(_user) ? "the_herta_greatsword" : "the_herta_pillar");
		this.strike(_user,primary,true);
		foreach(target in targets)
		{
			if (::$bvvar{namespace}.isActorDeadOrDying(_user)) break;
			if(target!=primary && ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(_user,target,9,true))
			{
				::$bvvar{namespace}.playValkyrieVisual(this,target,"the_herta_query");
				this.strike(_user,target,false);
			}
		}
		local s=::$bvvar{namespace}.HertaCombat.state(_user);
		if (!::$bvvar{namespace}.isActorDeadOrDying(_user) && s!=null && !s.UltimateRefundSpent
			&& ::$bvvar{namespace}.HertaCombat.weapon(_user)!=null && ::$bvvar{namespace}.hasHertaBondUpgrade(_user,80))
		{ s.UltimateRefundSpent=true; passive.addInspiration(1); }
		return true;
	}
	function getTooltip()
	{
		local p=this.getPassive(); local count=p==null?0:p.getInspiration();
		return [ {id=1,type="title",text=this.getName()+"  ["+count+"/4]"},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/regular_damage.png",text="$bv{skill.the_herta_answer_written.tooltip.primary}"},{id=5,type="text",icon="ui/icons/armor_damage.png",text="$bv{skill.the_herta_answer_written.tooltip.area}"},{id=6,type="text",icon="ui/icons/special.png",text="$bv{skill.the_herta_answer_written.tooltip.calculation}"}];
	}
});
