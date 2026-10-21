this.yakumo_yukari_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "yakumo_yukari" },
	function create() { this.character_trait.create(); ::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID); }
});
