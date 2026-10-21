this.bv_enemy_hexen_t5 <- this.inherit("scripts/entity/tactical/enemies/hexe", {
	m = {},
	function create()
	{
		this.hexe.create();
		this.getFlags().set("BVExpandedEnemyKey", "hexen_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("hexen_t5").Name;
	}
	function onInit()
	{
		this.hexe.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "hexen_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.hexe.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.hexe.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t5");
	}
	function onUpdate()
	{
		this.hexe.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.hexe.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t5");
	}
	function onDeserialize( _in )
	{
		this.hexe.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "hexen_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hexen_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.hexe.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("hexen_t5", _tile);
	}
});
