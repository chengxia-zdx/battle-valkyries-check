this.bv_enemy_goblins_t25 <- this.inherit("scripts/entity/tactical/enemies/goblin_fighter", {
	m = {},
	function create()
	{
		this.goblin_fighter.create();
		this.getFlags().set("BVExpandedEnemyKey", "goblins_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("goblins_t25").Name;
	}
	function onInit()
	{
		this.goblin_fighter.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "goblins_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.goblin_fighter.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.goblin_fighter.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t25");
	}
	function onUpdate()
	{
		this.goblin_fighter.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.goblin_fighter.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t25");
	}
	function onDeserialize( _in )
	{
		this.goblin_fighter.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "goblins_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.goblin_fighter.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("goblins_t25", _tile);
	}
});
