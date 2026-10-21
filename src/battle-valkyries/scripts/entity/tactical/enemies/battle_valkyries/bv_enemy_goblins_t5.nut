this.bv_enemy_goblins_t5 <- this.inherit("scripts/entity/tactical/enemies/goblin_leader", {
	m = {},
	function create()
	{
		this.goblin_leader.create();
		this.getFlags().set("BVExpandedEnemyKey", "goblins_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("goblins_t5").Name;
	}
	function onInit()
	{
		this.goblin_leader.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "goblins_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.goblin_leader.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.goblin_leader.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t5");
	}
	function onUpdate()
	{
		this.goblin_leader.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.goblin_leader.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t5");
	}
	function onDeserialize( _in )
	{
		this.goblin_leader.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "goblins_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "goblins_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.goblin_leader.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("goblins_t5", _tile);
	}
});
