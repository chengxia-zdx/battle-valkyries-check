this.bv_enemy_ghouls_t5 <- this.inherit("scripts/entity/tactical/enemies/ghoul_high", {
	m = {},
	function create()
	{
		this.ghoul_high.create();
		this.getFlags().set("BVExpandedEnemyKey", "ghouls_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("ghouls_t5").Name;
	}
	function onInit()
	{
		this.ghoul_high.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "ghouls_t5");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.ghoul_high.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.ghoul_high.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ghouls_t5");
	}
	function onUpdate()
	{
		this.ghoul_high.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ghouls_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.ghoul_high.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ghouls_t5");
	}
	function onDeserialize( _in )
	{
		this.ghoul_high.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "ghouls_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "ghouls_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.ghoul_high.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("ghouls_t5", _tile);
	}
});
