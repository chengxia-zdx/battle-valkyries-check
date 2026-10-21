this.bv_enemy_ancients_t4 <- this.inherit("scripts/entity/tactical/enemies/skeleton_heavy", {
	m = {},
	function create()
	{
		this.skeleton_heavy.create();
		this.getFlags().set("BVExpandedEnemyKey", "ancients_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("ancients_t4").Name;
	}
	function onInit()
	{
		this.skeleton_heavy.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "ancients_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "ancients_t4"))
			this.skeleton_heavy.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.skeleton_heavy.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.skeleton_heavy.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ancients_t4");
	}
	function onUpdate()
	{
		this.skeleton_heavy.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ancients_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.skeleton_heavy.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ancients_t4");
	}
	function onDeserialize( _in )
	{
		this.skeleton_heavy.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "ancients_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ancients_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.skeleton_heavy.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("ancients_t4", _tile);
	}
});
