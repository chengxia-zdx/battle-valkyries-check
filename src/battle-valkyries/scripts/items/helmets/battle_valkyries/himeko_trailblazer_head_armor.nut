this.himeko_trailblazer_head_armor <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "$bvvar{modId}.helmet.himeko_trailblazer_head";
		this.m.Name = "$bv{entity.himeko_trailblazer.head_armor}";
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
