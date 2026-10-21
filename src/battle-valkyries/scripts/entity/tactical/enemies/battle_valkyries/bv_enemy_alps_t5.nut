this.bv_enemy_alps_t5 <- this.inherit("scripts/entity/tactical/enemies/alp", {
	m = {},
	function create()
	{
		this.alp.create();
		this.getFlags().set("BVExpandedEnemyKey", "alps_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("alps_t5").Name;
	}
	function onInit()
	{
		this.alp.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "alps_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.alp.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.alp.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "alps_t5");
	}
	function onUpdate()
	{
		this.alp.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "alps_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.alp.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "alps_t5");
	}
	function onDeserialize( _in )
	{
		this.alp.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "alps_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "alps_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.alp.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("alps_t5", _tile);
	}
});
