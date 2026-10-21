this.grail_memory_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	m = { Blessing = false },
	function create() { this.valkyrie_passive_skill.create(); },
	function onValkyrieSkillBound(definition) { this.m.Blessing = definition.Spec.Blessing; },
	function onUpdate(properties) {
		if (!this.m.Blessing || !::$bvvar{namespace}.hasGrailBlessing(this.getContainer().getActor())) return;
		properties.Hitpoints += 20; properties.Stamina += 15; properties.Bravery += 10;
	}
});
