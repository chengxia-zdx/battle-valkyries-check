this.bv_enemy_oathbringers_t5 <- this.inherit("scripts/entity/tactical/humans/oathbringer", {
	m = {},
	function create()
	{
		this.oathbringer.create();
		this.getFlags().set("BVExpandedEnemyKey", "oathbringers_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("oathbringers_t5").Name;
	}
	function onInit()
	{
		this.oathbringer.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "oathbringers_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "oathbringers_t5"))
			this.oathbringer.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.oathbringer.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.oathbringer.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "oathbringers_t5");
	}
	function onUpdate()
	{
		this.oathbringer.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "oathbringers_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.oathbringer.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "oathbringers_t5");
	}
	function onDeserialize( _in )
	{
		this.oathbringer.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "oathbringers_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "oathbringers_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.oathbringer.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("oathbringers_t5", _tile);
	}
});
