this.bv_enemy_lindwurms_t25 <- this.inherit("scripts/entity/tactical/enemies/lindwurm", {
	m = {},
	function create()
	{
		this.lindwurm.create();
		this.getFlags().set("BVExpandedEnemyKey", "lindwurms_t25");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("lindwurms_t25").Name;
	}
	function onInit()
	{
		this.lindwurm.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "lindwurms_t25");
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.lindwurm.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.lindwurm.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "lindwurms_t25");
	}
	function onUpdate()
	{
		this.lindwurm.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "lindwurms_t25");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.lindwurm.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "lindwurms_t25");
	}
	function onDeserialize( _in )
	{
		this.lindwurm.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "lindwurms_t25");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "lindwurms_t25");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.lindwurm.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("lindwurms_t25", _tile);
	}
});
