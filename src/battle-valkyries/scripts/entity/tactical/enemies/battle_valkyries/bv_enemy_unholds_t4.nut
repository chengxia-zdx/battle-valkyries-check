this.bv_enemy_unholds_t4 <- this.inherit("scripts/entity/tactical/enemies/unhold_frost", {
	m = {},
	function create()
	{
		this.unhold_frost.create();
		this.getFlags().set("BVExpandedEnemyKey", "unholds_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("unholds_t4").Name;
	}
	function onInit()
	{
		this.unhold_frost.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "unholds_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.unhold_frost.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.unhold_frost.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "unholds_t4");
	}
	function onUpdate()
	{
		this.unhold_frost.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "unholds_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.unhold_frost.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "unholds_t4");
	}
	function onDeserialize( _in )
	{
		this.unhold_frost.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "unholds_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "unholds_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.unhold_frost.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("unholds_t4", _tile);
	}
});
