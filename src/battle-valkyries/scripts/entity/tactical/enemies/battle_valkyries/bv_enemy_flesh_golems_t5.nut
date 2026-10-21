this.bv_enemy_flesh_golems_t5 <- this.inherit("scripts/entity/tactical/enemies/greater_flesh_golem", {
	m = {},
	function create()
	{
		this.greater_flesh_golem.create();
		this.getFlags().set("BVExpandedEnemyKey", "flesh_golems_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("flesh_golems_t5").Name;
	}
	function onInit()
	{
		this.greater_flesh_golem.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "flesh_golems_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.greater_flesh_golem.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.greater_flesh_golem.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t5");
	}
	function onUpdate()
	{
		this.greater_flesh_golem.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.greater_flesh_golem.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t5");
	}
	function onDeserialize( _in )
	{
		this.greater_flesh_golem.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "flesh_golems_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.greater_flesh_golem.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("flesh_golems_t5", _tile);
	}
});
