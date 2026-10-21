this.togawa_sakiko_ensemble_effect <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_effect_skill", {
	m = { Owner=null, OwnerID=0, FeverTurns=0, FeverRound=-1 },
	function create() {
		this.valkyrie_effect_skill.create(); this.m.IsStacking=false;
		this.m.ID="$bvvar{modId}.effects.togawa_sakiko_ensemble";
		this.m.Name="$bv{effect.togawa_sakiko_ensemble.name}";
		this.m.Description="$bv{effect.togawa_sakiko_ensemble.description}";
		this.m.Icon="skills/$bvvar{iconPrefix}/togawa_sakiko_ensemble_stage.png";
		this.m.IconDisabled="skills/$bvvar{iconPrefix}/togawa_sakiko_ensemble_stage_sw.png";
	}
	function actor() { return this.getContainer()==null ? null : this.getContainer().getActor(); }
	function setupOwner(a) { this.m.Owner=this.WeakTableRef(a); this.m.OwnerID=a.getID(); }
	function isOwnedBy(a) { return a!=null && a.getID()==this.m.OwnerID; }
	function owner() {
		local a=::$bvvar{namespace}.readValkyrieCombatWeakRef(this.m.Owner);
		local p=::$bvvar{namespace}.getSakikoPassive(a);
		return p!=null && p.m.BattleActive && ::$bvvar{namespace}.sakikoAlive(a) ? a : null;
	}
	// 0 absent, 1 piano, 2 organ, 3 Fever. One combined effect prevents stacking.
	function mode() {
		local o=this.owner(), a=this.actor();
		if (o==null || !::$bvvar{namespace}.sakikoAlive(a) || !::$bvvar{namespace}.isEligibleRosterAlly(o,a)) return 0;
		if (this.m.FeverTurns>0) return 3;
		local p=::$bvvar{namespace}.getSakikoPassive(o);
		return !p.auraEnabled() || o.getTile().getDistanceTo(a.getTile())>4 ? 0 : p.m.Organ ? 2 : 1;
	}
	function isHidden() { return this.mode()==0; }
	function getIcon() {
		local mode=this.mode();
		return "skills/$bvvar{iconPrefix}/togawa_sakiko_"+(mode==3?"crescent_echo":mode==2?"organ_mode":"piano_mode")+".png";
	}
	function onUpdate(p) {
		local m=this.mode(); if(m==0)return;
		p.MeleeSkill+=10; p.RangedSkill+=10; p.Bravery+=15;
		if(m==2||m==3) { p.MeleeDefense+=10; p.RangedDefense+=10; }
	}
	function onAnySkillUsed(skill,target,p) {
		local m=this.mode();
		if ((m==1||m==3) && ::$bvvar{namespace}.isDirectAttack(skill)) { p.DamageDirectAdd+=0.15; p.DamageArmorMult*=1.20; }
	}
	function grantFever() {
		this.m.FeverTurns=2; this.m.FeverRound=-1;
		// Recast does not touch the actor's recovery/discount counters.
	}
	function beginNormalTurn(round) {
		if(this.mode()==0)return;
		if(this.m.FeverTurns>0) this.m.FeverRound=round;
		::$bvvar{namespace}.sakikoRecover(this.actor());
	}
	function endNormalTurn(round) {
		if(this.m.FeverRound!=round || this.m.FeverTurns<=0)return;
		this.m.FeverRound=-1; --this.m.FeverTurns;
		this.getContainer().update(); this.actor().setDirty(true);
	}
	function canDiscount(skill) {
		local a=this.actor();
		if(this.mode()!=3 || !::$bvvar{namespace}.sakikoNormalAction(a) || !::$bvvar{namespace}.isActiveWeaponAttack(skill))return false;
		local source=::$bvvar{namespace}.getCurrentValkyrieCombatSource(a,skill);
		if(source!=null && "Source" in source && source.Source!="direct" && source.Source!="weapon_active")return false;
		local t=::$bvvar{namespace}.sakikoTurn(a);
		return t.DiscountRound!=::$bvvar{namespace}.sakikoRound() || t.Discounts<2;
	}
	function adjustFinalAP(cost) { return cost<=2 ? cost : this.Math.max(2,cost-2); }
	function commitFinalAP() {
		local t=::$bvvar{namespace}.sakikoTurn(this.actor()), round=::$bvvar{namespace}.sakikoRound();
		if(t.DiscountRound!=round) { t.DiscountRound=round; t.Discounts=0; }
		++t.Discounts;
	}
	function getTooltip() {
		local m=this.mode(), a=this.actor();
		local t=a==null ? null : ::$bvvar{namespace}.sakikoTurn(a);
		local left=t==null||t.DiscountRound!=::$bvvar{namespace}.sakikoRound()?2:this.Math.max(0,2-t.Discounts);
		return [{id=1,type="title",text=this.getName()}, {id=2,type="description",text=this.getDescription()},
			{id=3,type="text",icon="ui/icons/special.png",text=m==3?"$bv{sakiko.fever}":m==2?"$bv{sakiko.organ}":"$bv{sakiko.piano}"},
			{id=4,type="text",icon="ui/icons/action_points.png",text="$bv{sakiko.remaining}"+this.m.FeverTurns+" / "+left}];
	}
	function onDeath(_fatalityType) { this.removeSelf(); }
	function onCombatFinished() { this.removeSelf(); this.skill.onCombatFinished(); }
});
