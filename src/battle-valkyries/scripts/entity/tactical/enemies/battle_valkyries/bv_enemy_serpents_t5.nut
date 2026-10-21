this.bv_enemy_serpents_t5 <- this.inherit("scripts/entity/tactical/enemies/serpent", {
	m = {},
	function create()
	{
		this.serpent.create();
		this.getFlags().set("BVExpandedEnemyKey", "serpents_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("serpents_t5").Name;
	}
	function onInit()
	{
		this.serpent.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "serpents_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.serpent.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.serpent.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t5");
	}
	function onUpdate()
	{
		this.serpent.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.serpent.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t5");
	}
	function onDeserialize( _in )
	{
		this.serpent.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "serpents_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "serpents_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.serpent.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("serpents_t5", _tile);
	}
});
