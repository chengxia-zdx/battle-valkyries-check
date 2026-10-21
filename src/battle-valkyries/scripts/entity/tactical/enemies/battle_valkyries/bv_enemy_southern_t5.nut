this.bv_enemy_southern_t5 <- this.inherit("scripts/entity/tactical/humans/officer", {
	m = {},
	function create()
	{
		this.officer.create();
		this.getFlags().set("BVExpandedEnemyKey", "southern_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("southern_t5").Name;
	}
	function onInit()
	{
		this.officer.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "southern_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "southern_t5"))
			this.officer.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.officer.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.officer.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "southern_t5");
	}
	function onUpdate()
	{
		this.officer.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "southern_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.officer.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "southern_t5");
	}
	function onDeserialize( _in )
	{
		this.officer.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "southern_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "southern_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.officer.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("southern_t5", _tile);
	}
});
