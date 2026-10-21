this.bv_enemy_brigands_t5 <- this.inherit("scripts/entity/tactical/enemies/bandit_leader", {
	m = {},
	function create()
	{
		this.bandit_leader.create();
		this.getFlags().set("BVExpandedEnemyKey", "brigands_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("brigands_t5").Name;
	}
	function onInit()
	{
		this.bandit_leader.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "brigands_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "brigands_t5"))
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
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t5");
	}
	function onUpdate()
	{
		this.bandit_leader.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.bandit_leader.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t5");
	}
	function onDeserialize( _in )
	{
		this.bandit_leader.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "brigands_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "brigands_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.bandit_leader.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("brigands_t5", _tile);
	}
});
