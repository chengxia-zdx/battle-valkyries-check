this.c_c_contract_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m={OwnerRef=null,OathUntil=-1,RescueUsed=false,Protected=false},
	function create()
	{
		this.valkyrie_effect_skill.create(); this.m.ID=::$bvvar{namespace}.CCContractID;
		this.m.Name="$bv{effect.c_c_contract.name}"; this.m.Description="$bv{effect.c_c_contract.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/c_c_geass_contract.png";
		this.m.IconDisabled="skills/$bvvar{iconPrefix}/c_c_geass_contract_sw.png"; this.m.IconMini="status_effect_74_mini";
	}
	function getOwner() { return ::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.OwnerRef); }
	function isBound()
	{
		local bv=::$bvvar{namespace},owner=this.getOwner(),target=this.getContainer().getActor(),s=bv.getCCState(owner);
		// skill_container.getActor() returns a WeakTableRef in the game.
		target=bv.readValkyrieCombatWeakRef(target);
		return !this.isGarbage() && s != null && s.Active && bv.getActorValkyrieID(owner)=="c_c" && bv.isCCAlive(owner) && bv.isCCAlive(target)
			&& bv.readValkyrieCombatWeakRef(s.TargetRef)==target;
	}
	function isEffective() { return this.isBound() && ::$bvvar{namespace}.isCCControlled(this.getOwner()) && ::$bvvar{namespace}.isCCControlled(this.getContainer().getActor()); }
	function hasOath() { return this.isEffective() && ::Time.getRound() < this.m.OathUntil; }
	function onUpdate(p)
	{
		if (!this.isBound()) { this.removeSelf(); return; }
		if (!this.isEffective()) return;
		p.MeleeSkill+=15; p.RangedSkill+=15; p.Bravery+=20;
	}
	function onAnySkillUsed(s,target,p)
	{
		if (this.isEffective() && ::$bvvar{namespace}.isCCActiveAttack(this.getContainer().getActor(),s))
			p.DamageTotalMult *= this.hasOath() ? 1.45 : 1.20;
	}
	function onBeforeDamageReceived(a,s,h,p)
	{
		if (this.hasOath() && this.m.Protected && ::$bvvar{namespace}.isDirectAttack(s)) p.DamageReceivedTotalMult*=0.5;
	}
	function onDeath(t) { ::$bvvar{namespace}.clearCCContract(this.getOwner()); this.removeSelf(); }
	function getTooltip()
	{
		local ret=[{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()}];
		if (!this.isEffective()) ret.push({id=3,type="text",icon="ui/tooltips/warning.png",text="$bv{cc.state.contract_paused}"});
		if (this.hasOath()) ret.push({id=4,type="text",icon="ui/icons/special.png",text="$bv{effect.c_c_contract.oath}"+(this.m.OathUntil-::Time.getRound())+"\n"+(this.m.RescueUsed?"$bv{cc.state.rescue_used}":"$bv{cc.state.rescue_ready}")});
		return ret;
	}
});
