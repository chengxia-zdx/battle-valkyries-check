this.kafka_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "kafka" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}
});
