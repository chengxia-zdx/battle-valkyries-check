this.bv_enemy_direwolves_t4 <- this.inherit("scripts/entity/tactical/enemies/direwolf_high", {
	m = {},
	function create()
	{
		this.direwolf_high.create();
		this.getFlags().set("BVExpandedEnemyKey", "direwolves_t4");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("direwolves_t4").Name;
	}
	function onInit()
	{
		this.direwolf_high.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "direwolves_t4");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.direwolf_high.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.direwolf_high.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "direwolves_t4");
	}
	function onUpdate()
	{
		this.direwolf_high.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "direwolves_t4");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.direwolf_high.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "direwolves_t4");
	}
	function onDeserialize( _in )
	{
		this.direwolf_high.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "direwolves_t4");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "direwolves_t4");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.direwolf_high.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("direwolves_t4", _tile);
	}
});
