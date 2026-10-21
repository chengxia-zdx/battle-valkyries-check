this.bv_enemy_sand_golems_t5 <- this.inherit("scripts/entity/tactical/enemies/sand_golem_high", {
	m = {},
	function create()
	{
		this.sand_golem_high.create();
		this.getFlags().set("BVExpandedEnemyKey", "sand_golems_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("sand_golems_t5").Name;
	}
	function onInit()
	{
		this.sand_golem_high.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "sand_golems_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.sand_golem_high.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.sand_golem_high.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "sand_golems_t5");
	}
	function onUpdate()
	{
		this.sand_golem_high.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "sand_golems_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.sand_golem_high.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "sand_golems_t5");
	}
	function onDeserialize( _in )
	{
		this.sand_golem_high.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "sand_golems_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "sand_golems_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.sand_golem_high.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("sand_golems_t5", _tile);
	}
});
