this.cartethyia_blade_howling_squall_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create(){this.valkyrie_active_skill.create();this.m.IsTargeted=true;this.m.IsTargetingActor=true;this.m.IsAttack=true;this.m.IsWeaponSkill=false;this.m.IsRanged=false;this.m.ActionPointCost=6;this.m.FatigueCost=30;this.m.MinRange=2;this.m.MaxRange=6;this.m.MaxRangeBonus=0;}
	function owner(){local c=this.getContainer();return c==null?null:c.getActor();}
	function manifest(){local c=this.getContainer();return c==null?null:c.getSkillByID("$bvvar{modId}.effects.cartethyia_fleurdelys_manifest");}
	function melee(){local a=this.owner();if(a==null)return false;local w=a.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);return w!=null&&w.isItemType(this.Const.Items.ItemType.MeleeWeapon);}
	function erosion(t){return t!=null&&t.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion")!=null;}
	function isUsable(){return this.skill.isUsable()&&this.manifest()!=null&&this.melee();}
	function onVerifyTarget(_originTile,_targetTile){if(!this.skill.onVerifyTarget(_originTile,_targetTile)||_targetTile==null||!_targetTile.IsOccupiedByActor)return false;local owner=this.owner();local target=_targetTile.getEntity();return ::$bvvar{namespace}.isEligibleValkyrieEnemyTarget(owner,target,this.m.MaxRange,true)&&owner.getTile().getDistanceTo(target.getTile())>=this.m.MinRange;}
	function clearAllErosion(){local owner=this.owner();if(owner==null)return;foreach(t in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner,::$bvvar{namespace}.getValkyrieRadiusTiles(owner.getTile(),99,true))){local e=t.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion");if(e!=null)t.getSkills().remove(e);}}
	function finish(_user){this.clearAllErosion();if(_user!=null)_user.setHitpoints(::Math.min(_user.getHitpointsMax(),_user.getHitpoints()+::Math.floor(_user.getHitpointsMax()*0.5)));local m=this.manifest();if(m!=null)this.getContainer().remove(m);}
	function onUse( _user, _targetTile )
	{
		if (_user == null || !this.isUsable() || !this.onVerifyTarget(_user.getTile(), _targetTile)) return false;
		foreach (target in ::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(_user, ::$bvvar{namespace}.getValkyrieRadiusTiles(_targetTile, 1, true)))
		{
			local eroded = this.erosion(target);
			local result = ::$bvvar{namespace}.applyValkyrieWeaponAttack(_user, this, target, { WeaponDamageMult = 1.50, ArmorDamageMult = 2.0, HitChance = 30, IgnoreDistance = true, IgnoreShield = true, Source = "cartethyia_finale" });
			if (eroded && result.Hit && !::$bvvar{namespace}.isActorDeadOrDying(target))
			{
				::$bvvar{namespace}.applyValkyrieFixedArmorDamage(_user, this, target, this.Const.BodyPart.Body, 80);
				if (!::$bvvar{namespace}.isActorDeadOrDying(target)) ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(_user, this, target, 40);
			}
			if ("playValkyrieHitVisual" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieHitVisual(this, target, "cartethyia_settlement", result);
		}
		this.finish(_user);
		return true;
	}
	function onCombatFinished(){local a=this.owner();if(a!=null)::$bvvar{namespace}.clearActorTemporaryValkyrieSkin(a);this.skill.onCombatFinished();}
	function getTooltip(){return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",text=this.getCostString()},{id=4,type="text",icon="ui/icons/special.png",text="$bv{skill.cartethyia_blade_howling_squall.tooltip}"}];}
});
