this.bv_enemy_orcs_t25 <- this.inherit("scripts/entity/tactical/enemies/orc_warlord", {
	m = {},
	function create()
	{
		this.orc_warlord.create();
		this.getFlags().set("BVExpandedEnemyKey", "orcs_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("orcs_t25").Name;
	}
	function onInit()
	{
		this.orc_warlord.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "orcs_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.orc_warlord.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.orc_warlord.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "orcs_t25");
	}
	function onUpdate()
	{
		this.orc_warlord.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "orcs_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.orc_warlord.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "orcs_t25");
	}
	function onDeserialize( _in )
	{
		this.orc_warlord.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "orcs_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "orcs_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.orc_warlord.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("orcs_t25", _tile);
	}
});
