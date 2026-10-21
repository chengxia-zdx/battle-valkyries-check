this.bv_enemy_militia_t25 <- this.inherit("scripts/entity/tactical/humans/militia_captain", {
	m = {},
	function create()
	{
		this.militia_captain.create();
		this.getFlags().set("BVExpandedEnemyKey", "militia_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("militia_t25").Name;
	}
	function onInit()
	{
		this.militia_captain.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "militia_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.militia_captain.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.militia_captain.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "militia_t25");
	}
	function onUpdate()
	{
		this.militia_captain.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "militia_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.militia_captain.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "militia_t25");
	}
	function onDeserialize( _in )
	{
		this.militia_captain.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "militia_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "militia_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.militia_captain.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("militia_t25", _tile);
	}
});
