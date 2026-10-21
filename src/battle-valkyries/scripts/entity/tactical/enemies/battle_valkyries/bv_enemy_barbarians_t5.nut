this.bv_enemy_barbarians_t5 <- this.inherit("scripts/entity/tactical/humans/barbarian_champion", {
	m = {},
	function create()
	{
		this.barbarian_champion.create();
		this.getFlags().set("BVExpandedEnemyKey", "barbarians_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("barbarians_t5").Name;
	}
	function onInit()
	{
		this.barbarian_champion.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "barbarians_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "barbarians_t5"))
			this.barbarian_champion.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.barbarian_champion.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.barbarian_champion.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "barbarians_t5");
	}
	function onUpdate()
	{
		this.barbarian_champion.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "barbarians_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.barbarian_champion.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "barbarians_t5");
	}
	function onDeserialize( _in )
	{
		this.barbarian_champion.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "barbarians_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "barbarians_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.barbarian_champion.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("barbarians_t5", _tile);
	}
});
