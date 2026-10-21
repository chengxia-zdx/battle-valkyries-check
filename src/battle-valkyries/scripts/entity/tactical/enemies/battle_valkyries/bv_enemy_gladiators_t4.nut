this.bv_enemy_gladiators_t4 <- this.inherit("scripts/entity/tactical/humans/gladiator", {
	m = {},
	function create()
	{
		this.gladiator.create();
		this.getFlags().set("BVExpandedEnemyKey", "gladiators_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("gladiators_t4").Name;
	}
	function onInit()
	{
		this.gladiator.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "gladiators_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "gladiators_t4"))
			this.gladiator.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.gladiator.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.gladiator.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t4");
	}
	function onUpdate()
	{
		this.gladiator.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.gladiator.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t4");
	}
	function onDeserialize( _in )
	{
		this.gladiator.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "gladiators_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.gladiator.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("gladiators_t4", _tile);
	}
});
