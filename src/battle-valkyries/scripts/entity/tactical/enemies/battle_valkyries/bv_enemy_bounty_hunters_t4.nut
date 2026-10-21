this.bv_enemy_bounty_hunters_t4 <- this.inherit("scripts/entity/tactical/humans/bounty_hunter_ranged", {
	m = {},
	function create()
	{
		this.bounty_hunter_ranged.create();
		this.getFlags().set("BVExpandedEnemyKey", "bounty_hunters_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("bounty_hunters_t4").Name;
	}
	function onInit()
	{
		this.bounty_hunter_ranged.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "bounty_hunters_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "bounty_hunters_t4"))
			this.bounty_hunter_ranged.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.bounty_hunter_ranged.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.bounty_hunter_ranged.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t4");
	}
	function onUpdate()
	{
		this.bounty_hunter_ranged.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.bounty_hunter_ranged.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t4");
	}
	function onDeserialize( _in )
	{
		this.bounty_hunter_ranged.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "bounty_hunters_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.bounty_hunter_ranged.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("bounty_hunters_t4", _tile);
	}
});
