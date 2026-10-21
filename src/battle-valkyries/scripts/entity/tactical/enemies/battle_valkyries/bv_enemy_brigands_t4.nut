this.bv_enemy_brigands_t4 <- this.inherit("scripts/entity/tactical/enemies/bandit_leader", {
	m = {},
	function create()
	{
		this.bandit_leader.create();
		this.getFlags().set("BVExpandedEnemyKey", "brigands_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("brigands_t4").Name;
	}
	function onInit()
	{
		this.bandit_leader.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "brigands_t4");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "brigands_t4"))
			this.bandit_leader.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.bandit_leader.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.bandit_leader.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t4");
	}
	function onUpdate()
	{
		this.bandit_leader.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.bandit_leader.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t4");
	}
	function onDeserialize( _in )
	{
		this.bandit_leader.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "brigands_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.bandit_leader.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("brigands_t4", _tile);
	}
});
