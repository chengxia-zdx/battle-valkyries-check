this.lily_ulv_step_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_active_skill", {
	function create()
	{
		this.valkyrie_active_skill.create();this.m.Overlay="lily_spirit_mad_knight_ulv";
		this.m.IsTargeted=true;this.m.IsTargetingActor=false;this.m.IsAttack=false;this.m.IsWeaponSkill=false;this.m.IsIgnoredAsAOO=true;this.m.ActionPointCost=0;this.m.FatigueCost=0;this.m.MinRange=1;this.m.MaxRange=1;this.m.MaxRangeBonus=0;this.m.IsRemovedAfterBattle=true;
	}
	function onVerifyTarget(_originTile,_targetTile){return this.skill.onVerifyTarget(_originTile,_targetTile)&&_targetTile!=null&&_targetTile.IsEmpty&&_originTile.getDistanceTo(_targetTile)==1&&this.Math.abs(_targetTile.Level-_originTile.Level)<=1;}
	function onUse(_user,_targetTile)
	{
		if(_user==null||_targetTile==null||!this.onVerifyTarget(_user.getTile(),_targetTile))return false;local c=_user.getSkills().getSkillByID(::$bvvar{namespace}.getValkyrieSkillRuntimeID("lily_blight_controller"));if(c!=null)c.noteVoluntaryDisplacement();
		_user.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);this.Tactical.getNavigator().teleport(_user,_targetTile,null,null,false);this.removeSelf();return true;
	}
	function onTurnEnd(){this.removeSelf();}
});
