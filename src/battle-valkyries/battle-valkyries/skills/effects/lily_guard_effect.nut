this.lily_guard_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={Mode="front",CounterMult=1.40,Available=true},
	function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.lily_guard";this.m.Name="$bv{effect.lily_guard.name}";this.m.Description="$bv{effect.lily_guard.description}";this.m.Icon="skills/$bvvar{iconPrefix}/lily_spirit_headless_defender.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/lily_spirit_headless_defender_sw.png";this.m.IconMini<-"status_effect_88_mini";this.m.IsStacking=false;this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;}
	function configure(_mode,_mult){this.m.Mode=_mode;this.m.CounterMult=_mult;this.m.Available=true;return this;}
	function onBeforeDamageReceived(_attacker,_skill,_hitInfo,_properties)
	{
		if(!this.m.Available||_attacker==null||_skill==null||_hitInfo==null||!::$bvvar{namespace}.isDirectAttack(_skill))return;
		local owner=this.getContainer()==null?null:this.getContainer().getActor();if(owner==null||_attacker.isAlliedWith(owner)||::$bvvar{namespace}.isActorDeadOrDying(owner))return;
		if(this.m.Mode=="front")
		{
			try{local facing=owner.getDirection();local incoming=owner.getTile().getDirectionTo(_attacker.getTile());if(incoming!=facing&&incoming!=(facing+1)%6&&incoming!=(facing+5)%6)return;}catch(e){}
		}
		this.m.Available=false;_hitInfo.DamageRegular=0;_hitInfo.DamageArmor=0;_hitInfo.DamageFatigue=0;
		local controller=owner.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));
		if(controller!=null&&!::$bvvar{namespace}.isActorDeadOrDying(_attacker))
		{
			local targets=[];if(this.m.Mode=="all")targets=::$bvvar{namespace}.getValkyrieEnemyTargetsOnTiles(owner,::$bvvar{namespace}.getValkyrieRadiusTiles(_attacker.getTile(),1,true));
			else if(owner.getTile().getDistanceTo(_attacker.getTile())<=2)targets=[_attacker];
			local p=controller.getSpiritPower(),hit=[];foreach(target in targets){::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner,this,target,this.Math.floor((p.Min+p.Max)*0.5*this.m.CounterMult));hit.push(target);}if(hit.len()>0)controller.onSpiritResolved(hit);
		}
		this.removeSelf();
	}
});
