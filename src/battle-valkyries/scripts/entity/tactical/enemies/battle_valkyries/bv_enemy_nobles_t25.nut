this.bv_enemy_nobles_t25 <- this.inherit("scripts/entity/tactical/humans/knight", {
	m = {},
	function create()
	{
		this.knight.create();
		this.getFlags().set("BVExpandedEnemyKey", "nobles_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("nobles_t25").Name;
	}
	function onInit()
	{
		this.knight.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "nobles_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.knight.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.knight.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t25");
	}
	function onUpdate()
	{
		this.knight.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.knight.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t25");
	}
	function onDeserialize( _in )
	{
		this.knight.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "nobles_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.knight.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("nobles_t25", _tile);
	}
});
