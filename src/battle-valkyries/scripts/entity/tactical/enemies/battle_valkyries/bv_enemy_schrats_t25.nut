this.bv_enemy_schrats_t25 <- this.inherit("scripts/entity/tactical/enemies/schrat", {
	m = {},
	function create()
	{
		this.schrat.create();
		this.getFlags().set("BVExpandedEnemyKey", "schrats_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("schrats_t25").Name;
	}
	function onInit()
	{
		this.schrat.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "schrats_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.schrat.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.schrat.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "schrats_t25");
	}
	function onUpdate()
	{
		this.schrat.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "schrats_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.schrat.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "schrats_t25");
	}
	function onDeserialize( _in )
	{
		this.schrat.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "schrats_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "schrats_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.schrat.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("schrats_t25", _tile);
	}
});
