this.himeko_trailblazer_body_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.ID = "$bvvar{modId}.armor.himeko_trailblazer_body";
		this.m.Name = "$bv{entity.himeko_trailblazer.body_armor}";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.Condition = 800.0;
		this.m.ConditionMax = 800.0;
		this.m.StaminaModifier = 0;
		this.m.ShowOnCharacter = false;
		this.m.IsDroppedAsLoot = false;
		this.m.IsIndestructible = false;
	}
});
