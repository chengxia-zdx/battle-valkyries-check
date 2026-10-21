this.bv_enemy_nobles_t5 <- this.inherit("scripts/entity/tactical/humans/knight", {
	m = {},
	function create()
	{
		this.knight.create();
		this.getFlags().set("BVExpandedEnemyKey", "nobles_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("nobles_t5").Name;
	}
	function onInit()
	{
		this.knight.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "nobles_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "nobles_t5"))
			this.knight.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.knight.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.knight.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t5");
	}
	function onUpdate()
	{
		this.knight.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.knight.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t5");
	}
	function onDeserialize( _in )
	{
		this.knight.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "nobles_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nobles_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.knight.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("nobles_t5", _tile);
	}
});
