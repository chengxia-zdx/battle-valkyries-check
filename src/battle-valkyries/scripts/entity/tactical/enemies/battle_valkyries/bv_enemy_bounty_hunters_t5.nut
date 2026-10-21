this.bv_enemy_bounty_hunters_t5 <- this.inherit("scripts/entity/tactical/humans/bounty_hunter", {
	m = {},
	function create()
	{
		this.bounty_hunter.create();
		this.getFlags().set("BVExpandedEnemyKey", "bounty_hunters_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("bounty_hunters_t5").Name;
	}
	function onInit()
	{
		this.bounty_hunter.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "bounty_hunters_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "bounty_hunters_t5"))
			this.bounty_hunter.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.bounty_hunter.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.bounty_hunter.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t5");
	}
	function onUpdate()
	{
		this.bounty_hunter.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.bounty_hunter.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t5");
	}
	function onDeserialize( _in )
	{
		this.bounty_hunter.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "bounty_hunters_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "bounty_hunters_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.bounty_hunter.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("bounty_hunters_t5", _tile);
	}
});
