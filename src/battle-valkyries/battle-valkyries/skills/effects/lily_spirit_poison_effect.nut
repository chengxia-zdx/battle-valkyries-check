this.lily_spirit_poison_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={Kind="fungal",TurnsLeft=3,Damage=20,Source=null},
	function create(){this.valkyrie_effect_skill.create();this.m.ID="$bvvar{modId}.effects.lily_fungal_poison";this.m.Name="$bv{effect.lily_spirit_poison.name}";this.m.Description="$bv{effect.lily_spirit_poison.description}";this.m.Icon="skills/$bvvar{iconPrefix}/lily_spirit_fungal_sorcerer.png";this.m.IconDisabled="skills/$bvvar{iconPrefix}/lily_spirit_fungal_sorcerer_sw.png";this.m.IconMini<-"status_effect_54_mini";this.m.IsStacking=false;this.m.IsSerialized=false;this.m.IsRemovedAfterBattle=true;}
	function configure(_kind,_damage,_source){this.m.Kind=_kind;this.m.Damage=_damage;this.m.Source=_source==null?null:this.WeakTableRef(_source);this.m.TurnsLeft=3;this.m.ID="$bvvar{modId}.effects.lily_"+_kind+"_poison";return this;}
	function onRefresh(){this.m.TurnsLeft=3;}
	function source(){return this.m.Source==null||this.m.Source.isNull()?null:this.m.Source;}
	function onTurnEnd()
	{
		local target=this.getContainer()==null?null:this.getContainer().getActor(),source=this.source();if(target!=null&&!::$bvvar{namespace}.isActorDeadOrDying(target))
		{
			local otherID=this.m.Kind=="fungal"?"$bvvar{modId}.effects.lily_fellwyrm_poison":"$bvvar{modId}.effects.lily_fungal_poison";
			local other=target.getSkills().getSkillByID(otherID),dealHP=other==null||this.m.Damage>=other.m.Damage;
			if(dealHP&&source!=null)::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(source,this,target,this.m.Damage);
			else if(!dealHP&&source!=null&&target.getArmor(this.Const.BodyPart.Body)>0)::$bvvar{namespace}.applyValkyrieFixedArmorDamage(source,this,target,this.Const.BodyPart.Body,this.m.Damage);
		}
		if(--this.m.TurnsLeft<=0)this.removeSelf();
	}
});
