this.lily_pending_purification_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { TurnsLeft=2, Lily=null, LilyID=0, Credited=false },
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID="$bvvar{modId}.effects.lily_pending_purification";
		this.m.Name="$bv{effect.lily_pending_purification.name}"; this.m.Description="$bv{effect.lily_pending_purification.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/lily_blight_controller.png"; this.m.IconDisabled="skills/$bvvar{iconPrefix}/lily_blight_controller_sw.png";
		this.m.IconMini<-"status_effect_111_mini"; this.m.Type=this.Const.SkillType.StatusEffect; this.m.IsStacking=false; this.m.IsSerialized=false; this.m.IsRemovedAfterBattle=true;
	}
	function setup( _lily ) { this.m.Lily=_lily==null?null:this.WeakTableRef(_lily);this.m.LilyID=_lily==null?0:_lily.getID();this.m.TurnsLeft=2; }
	function getLily(){if(this.m.Lily==null||this.m.Lily.isNull())return null;return this.m.Lily;}
	function onRefresh(){this.m.TurnsLeft=2;}
	function getName(){return this.m.Name+" ("+this.m.TurnsLeft+")";}
	function creditAssist()
	{
		if(this.m.Credited)return; local lily=this.getLily(),target=this.getContainer()==null?null:this.getContainer().getActor();
		if(lily==null||target==null)return; local record=::$bvvar{namespace}.getLilySpiritRecord(lily); if(record!=null)record.recordPurificationCredit(target,false); this.m.Credited=true;
	}
	function onDeath( _fatalityType )
	{
		this.creditAssist();
		local lily=this.getLily(),target=this.getContainer()==null?null:this.getContainer().getActor();
		if(lily==null||target==null)return;
		local controller=lily.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));
		if(controller!=null)controller.addBlight(controller.getDeathBlight(target));
	}
	function onTurnEnd(){if(--this.m.TurnsLeft<=0)this.removeSelf();}
});
