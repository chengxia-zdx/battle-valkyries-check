this.bv_enemy_cultists_t4 <- this.inherit("scripts/entity/tactical/humans/cultist", {
	m = {},
	function create()
	{
		this.cultist.create();
		this.getFlags().set("BVExpandedEnemyKey", "cultists_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("cultists_t4").Name;
	}
	function onInit()
	{
		this.cultist.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "cultists_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "cultists_t4"))
			this.cultist.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.cultist.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.cultist.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t4");
	}
	function onUpdate()
	{
		this.cultist.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.cultist.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t4");
	}
	function onDeserialize( _in )
	{
		this.cultist.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "cultists_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.cultist.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("cultists_t4", _tile);
	}
});
