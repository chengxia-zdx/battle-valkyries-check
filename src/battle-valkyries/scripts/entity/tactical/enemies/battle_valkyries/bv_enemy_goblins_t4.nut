this.bv_enemy_goblins_t4 <- this.inherit("scripts/entity/tactical/enemies/goblin_ambusher", {
	m = {},
	function create()
	{
		this.goblin_ambusher.create();
		this.getFlags().set("BVExpandedEnemyKey", "goblins_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("goblins_t4").Name;
	}
	function onInit()
	{
		this.goblin_ambusher.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "goblins_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.goblin_ambusher.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.goblin_ambusher.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t4");
	}
	function onUpdate()
	{
		this.goblin_ambusher.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.goblin_ambusher.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t4");
	}
	function onDeserialize( _in )
	{
		this.goblin_ambusher.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "goblins_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.goblin_ambusher.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("goblins_t4", _tile);
	}
});
