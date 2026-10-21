this.bv_enemy_serpents_t4 <- this.inherit("scripts/entity/tactical/enemies/serpent", {
	m = {},
	function create()
	{
		this.serpent.create();
		this.getFlags().set("BVExpandedEnemyKey", "serpents_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("serpents_t4").Name;
	}
	function onInit()
	{
		this.serpent.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "serpents_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.serpent.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.serpent.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t4");
	}
	function onUpdate()
	{
		this.serpent.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.serpent.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t4");
	}
	function onDeserialize( _in )
	{
		this.serpent.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "serpents_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.serpent.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("serpents_t4", _tile);
	}
});
