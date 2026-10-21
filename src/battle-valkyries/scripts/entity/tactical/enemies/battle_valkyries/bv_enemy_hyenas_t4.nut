this.bv_enemy_hyenas_t4 <- this.inherit("scripts/entity/tactical/enemies/hyena_high", {
	m = {},
	function create()
	{
		this.hyena_high.create();
		this.getFlags().set("BVExpandedEnemyKey", "hyenas_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("hyenas_t4").Name;
	}
	function onInit()
	{
		this.hyena_high.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "hyenas_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.hyena_high.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.hyena_high.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hyenas_t4");
	}
	function onUpdate()
	{
		this.hyena_high.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hyenas_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.hyena_high.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hyenas_t4");
	}
	function onDeserialize( _in )
	{
		this.hyena_high.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "hyenas_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "hyenas_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.hyena_high.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("hyenas_t4", _tile);
	}
});
