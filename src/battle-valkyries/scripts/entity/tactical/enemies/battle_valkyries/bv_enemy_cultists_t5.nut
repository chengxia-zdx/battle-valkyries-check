this.bv_enemy_cultists_t5 <- this.inherit("scripts/entity/tactical/humans/cultist", {
	m = {},
	function create()
	{
		this.cultist.create();
		this.getFlags().set("BVExpandedEnemyKey", "cultists_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("cultists_t5").Name;
	}
	function onInit()
	{
		this.cultist.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "cultists_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "cultists_t5"))
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
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t5");
	}
	function onUpdate()
	{
		this.cultist.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.cultist.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t5");
	}
	function onDeserialize( _in )
	{
		this.cultist.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "cultists_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "cultists_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.cultist.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("cultists_t5", _tile);
	}
});
