this.bv_enemy_hexen_t4 <- this.inherit("scripts/entity/tactical/enemies/hexe", {
	m = {},
	function create()
	{
		this.hexe.create();
		this.getFlags().set("BVExpandedEnemyKey", "hexen_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("hexen_t4").Name;
	}
	function onInit()
	{
		this.hexe.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "hexen_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.hexe.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.hexe.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t4");
	}
	function onUpdate()
	{
		this.hexe.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.hexe.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t4");
	}
	function onDeserialize( _in )
	{
		this.hexe.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "hexen_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.hexe.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("hexen_t4", _tile);
	}
});
