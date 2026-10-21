this.bv_enemy_zombies_t4 <- this.inherit("scripts/entity/tactical/enemies/zombie_knight", {
	m = {},
	function create()
	{
		this.zombie_knight.create();
		this.getFlags().set("BVExpandedEnemyKey", "zombies_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("zombies_t4").Name;
		this.m.ResurrectWithScript = "scripts/entity/tactical/enemies/battle_valkyries/bv_enemy_zombies_t4";
	}
	function onInit()
	{
		this.zombie_knight.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "zombies_t4");
	}

	function generateCorpse( _tile, _fatalityType, _killer )
	{
		return ::$bvvar{namespace}.generateExpandedEnemyCorpse(this, _tile, _fatalityType, _killer, this.zombie_knight.generateCorpse.bindenv(this));
	}
	function onResurrected( _info )
	{
		this.zombie_knight.onResurrected(_info);
		::$bvvar{namespace}.restoreExpandedEnemyCorpse(this, _info);
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("zombies_t4").Name;
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "zombies_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "zombies_t4"))
			this.zombie_knight.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.zombie_knight.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.zombie_knight.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "zombies_t4");
	}
	function onUpdate()
	{
		this.zombie_knight.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "zombies_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.zombie_knight.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "zombies_t4");
	}
	function onDeserialize( _in )
	{
		this.zombie_knight.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "zombies_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "zombies_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.zombie_knight.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("zombies_t4", _tile);
	}
});
