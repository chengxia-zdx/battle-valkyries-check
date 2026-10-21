this.bv_enemy_nomads_t5 <- this.inherit("scripts/entity/tactical/humans/nomad_leader", {
	m = {},
	function create()
	{
		this.nomad_leader.create();
		this.getFlags().set("BVExpandedEnemyKey", "nomads_t5");
		this.m.Name = ::$bvvar{namespace}.getExpandedEnemyDefinition("nomads_t5").Name;
	}
	function onInit()
	{
		this.nomad_leader.onInit();
		::$bvvar{namespace}.initializeExpandedEnemy(this, "nomads_t5");
	}
	function assignRandomEquipment()
	{
		if (!::$bvvar{namespace}.equipExpandedEnemy(this, "nomads_t5"))
			this.nomad_leader.assignRandomEquipment();
	}
	function addDefaultStatusSprites()
	{
		if (!this.hasSprite("accessory")) this.addSprite("accessory");
		this.nomad_leader.addDefaultStatusSprites();
	}
	function onFactionChanged()
	{
		this.nomad_leader.onFactionChanged();
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nomads_t5");
	}
	function onUpdate()
	{
		this.nomad_leader.onUpdate();
		if (this.isAlive()) ::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nomads_t5");
	}
	function onAppearanceChanged( _appearance, _setDirty = true )
	{
		this.nomad_leader.onAppearanceChanged(_appearance, _setDirty);
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nomads_t5");
	}
	function onDeserialize( _in )
	{
		this.nomad_leader.onDeserialize(_in);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(this, "nomads_t5");
		::$bvvar{namespace}.applyExpandedEnemyVisual(this, "nomads_t5");
	}
	function onDeath( _killer, _skill, _tile, _fatalityType )
	{
		this.nomad_leader.onDeath(_killer, _skill, _tile, _fatalityType);
		if (_fatalityType != this.Const.FatalityType.Decapitated && !("IsHeadless" in this.m && this.m.IsHeadless))
			::$bvvar{namespace}.applyExpandedEnemyCorpseVisual("nomads_t5", _tile);
	}
});
