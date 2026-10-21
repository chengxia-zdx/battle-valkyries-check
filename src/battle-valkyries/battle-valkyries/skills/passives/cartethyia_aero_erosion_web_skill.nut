this.cartethyia_aero_erosion_web_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function create() { this.valkyrie_passive_skill.create(); }
	function getOwner() { local c=this.getContainer(); return c==null?null:c.getActor(); }
	function getManifest() { local c=this.getContainer(); return c==null?null:c.getSkillByID("$bvvar{modId}.effects.cartethyia_fleurdelys_manifest"); }
	function hasErosion( _target ) { return _target != null && _target.getSkills().getSkillByID("$bvvar{modId}.effects.cartethyia_aero_erosion") != null; }
	function applyWeb( _user, _target ) { if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return null; return ::$bvvar{namespace}.addOrRefreshStatus(_user, _target, { Type = "web" }); }
	function applyErosion( _target ) { if (_target == null || ::$bvvar{namespace}.isActorDeadOrDying(_target) || this.hasErosion(_target)) return null; local e=::new("$bvvar{privateFolder}/skills/effects/cartethyia_aero_erosion_effect"); _target.getSkills().add(e); return e; }
	function isWeaponAttack( _event ) { if(_event==null || !("Attacker" in _event) || _event.Attacker!=this.getOwner() || !("Skill" in _event) || !::$bvvar{namespace}.isActiveWeaponAttack(_event.Skill))return false; local s="Source" in _event?_event.Source:"direct"; return s!="fixed_damage"&&s!="damage_over_time"&&s!="reflect"; }
	function applyManifestErosionDamage( _event, _target )
	{
		if (this.getManifest() == null || !this.hasErosion(_target)) return;
		local source = "Source" in _event ? _event.Source : "direct";
		local totalDamage = ("HitpointDamage" in _event ? _event.HitpointDamage : 0) + ("ArmorDamage" in _event ? _event.ArmorDamage : 0);
		if (source != "direct" || totalDamage <= 0 || ::$bvvar{namespace}.isActorDeadOrDying(_target)) return;
		local owner = this.getOwner();
		::$bvvar{namespace}.applyValkyrieFixedArmorDamage(owner, this, _target, this.Const.BodyPart.Body, 30, { Source = "fixed_damage" });
		if (!::$bvvar{namespace}.isActorDeadOrDying(_target)) ::$bvvar{namespace}.applyValkyrieFixedHitpointDamage(owner, this, _target, 15, { Source = "fixed_damage" });
	}
	function onValkyrieCombatEvent( _event )
	{
		if(_event==null || !("Type" in _event) || _event.Type!="DamageResolved" || !this.isWeaponAttack(_event) || !("Victim" in _event)) return;
		local target=_event.Victim; if(::$bvvar{namespace}.isActorDeadOrDying(target))return;
		this.applyManifestErosionDamage(_event, target);
		this.applyWeb(this.getOwner(),target);
		local source="Source" in _event?_event.Source:"direct";
		if(this.getManifest()==null && source!="aoo" && source!="riposte" && source!="counter" && source!="followup") this.applyErosion(target);
	}
	function onCombatFinished() { this.skill.onCombatFinished(); }
	function getTooltip() { return [{id=1,type="title",text=this.getName()},{id=2,type="description",text=this.getDescription()},{id=3,type="text",icon="ui/icons/special.png",text="$bv{skill.cartethyia_aero_erosion_web.tooltip}"}]; }
});
