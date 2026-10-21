this.bv_enemy_flesh_golems_t4 <- this.inherit("scripts/entity/tactical/enemies/greater_flesh_golem", {
	m = {},
	function create()
	{
		this.greater_flesh_golem.create();
		this.getFlags().set("BVExpandedEnemyKey", "flesh_golems_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("flesh_golems_t4").Name;
	}
	function onInit()
	{
		this.greater_flesh_golem.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "flesh_golems_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.greater_flesh_golem.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.greater_flesh_golem.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t4");
	}
	function onUpdate()
	{
		this.greater_flesh_golem.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.greater_flesh_golem.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t4");
	}
	function onDeserialize( _in )
	{
		this.greater_flesh_golem.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "flesh_golems_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "flesh_golems_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.greater_flesh_golem.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("flesh_golems_t4", _tile);
	}
});
