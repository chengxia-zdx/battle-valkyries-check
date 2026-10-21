this.bv_enemy_mercenaries_t5 <- this.inherit("scripts/entity/tactical/humans/hedge_knight", {
	m = {},
	function create()
	{
		this.hedge_knight.create();
		this.getFlags().set("BVExpandedEnemyKey", "mercenaries_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("mercenaries_t5").Name;
	}
	function onInit()
	{
		this.hedge_knight.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "mercenaries_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "mercenaries_t5"))
			this.hedge_knight.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.hedge_knight.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.hedge_knight.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "mercenaries_t5");
	}
	function onUpdate()
	{
		this.hedge_knight.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "mercenaries_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.hedge_knight.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "mercenaries_t5");
	}
	function onDeserialize( _in )
	{
		this.hedge_knight.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "mercenaries_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "mercenaries_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.hedge_knight.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("mercenaries_t5", _tile);
	}
});
