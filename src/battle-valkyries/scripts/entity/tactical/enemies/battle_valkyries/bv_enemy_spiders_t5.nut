this.bv_enemy_spiders_t5 <- this.inherit("scripts/entity/tactical/enemies/spider", {
	m = {},
	function create()
	{
		this.spider.create();
		this.getFlags().set("BVExpandedEnemyKey", "spiders_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("spiders_t5").Name;
	}
	function onInit()
	{
		this.spider.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "spiders_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.spider.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.spider.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "spiders_t5");
	}
	function onUpdate()
	{
		this.spider.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "spiders_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.spider.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "spiders_t5");
	}
	function onDeserialize( _in )
	{
		this.spider.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "spiders_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "spiders_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.spider.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("spiders_t5", _tile);
	}
});
