this.robin_granted_action_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Amount = 0, Overflow = false, AppliedAtStart = false, BVIsExtraTurn = false },
	function create()
	{
		this.valkyrie_effect_skill.create();
		this.m.ID = "$bvvar{modId}.effects.robin_granted_action";
		this.m.Name = "$bv{effect.robin_granted_action.name}";
		this.m.Description = "$bv{effect.robin_granted_action.description}";
		this.m.Icon = "skills/$bvvar{iconPrefix}/robin_myriad_tones_starry_fugue.png";
		this.m.IconDisabled = "skills/$bvvar{iconPrefix}/robin_myriad_tones_starry_fugue_sw.png";
		this.m.IsHidden = true;
	}
	function setup( _amount, _overflow ) { this.m.Amount=this.Math.max(0,_amount); this.m.Overflow=_overflow; }
	function applyImmediate()
	{
		local actor=this.getContainer()==null?null:this.getContainer().getActor(); if(actor==null)return;
		local ap=actor.getActionPoints()+this.m.Amount;
		actor.setActionPoints(this.m.Overflow?ap:this.Math.min(actor.getActionPointsMax(),ap)); actor.setDirty(true);
	}
	function onAdded() { this.applyImmediate(); }
	function applyStart()
	{
		if(this.m.AppliedAtStart)return; local actor=this.getContainer()==null?null:this.getContainer().getActor(); if(actor==null)return;
		this.m.AppliedAtStart=true;
		actor.setActionPoints(this.m.Overflow?actor.getActionPointsMax()+this.m.Amount:this.Math.min(actor.getActionPointsMax(),this.m.Amount)); actor.setDirty(true);
	}
	function onTurnStart() { this.applyStart(); }
	function onResumeTurn() { this.applyStart(); }
	function onTurnEnd() { this.removeSelf(); }
	function onDeath( _fatalityType ) { this.removeSelf(); }
});
