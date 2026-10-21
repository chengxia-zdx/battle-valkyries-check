this.yixuan_yunki_oath_skill <- this.inherit("$bvvar{privateFolder}/skills/core/valkyrie_passive_skill", {
	function onUpdate(properties) { properties.Hitpoints += 20; properties.Bravery += 10; }
});
