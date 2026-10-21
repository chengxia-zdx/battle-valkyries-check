this.bv_enemy_gladiators_t5 <- this.inherit("scripts/entity/tactical/humans/gladiator", {
	m = {},
	function create()
	{
		this.gladiator.create();
		this.getFlags().set("BVExpandedEnemyKey", "gladiators_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("gladiators_t5").Name;
	}
	function onInit()
	{
		this.gladiator.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "gladiators_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "gladiators_t5"))
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
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t5");
	}
	function onUpdate()
	{
		this.gladiator.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.gladiator.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t5");
	}
	function onDeserialize( _in )
	{
		this.gladiator.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "gladiators_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "gladiators_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.gladiator.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("gladiators_t5", _tile);
	}
});
