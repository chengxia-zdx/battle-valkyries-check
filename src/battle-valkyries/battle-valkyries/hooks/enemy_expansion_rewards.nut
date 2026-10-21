local ns = ::$bvvar{namespace};
ns.MH.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.setupEntity = @(__original) function( _e, _t )
	{
		local result = __original(_e, _t);
		::$bvvar{namespace}.restoreExpandedEnemyCombat(_e, _e.getFlags().get("BVExpandedEnemyKey"));
		::$bvvar{namespace}.EnemyRewards.setup(_e, _t);
		return result;
	}
	q.onResurrect = @(__original) function( _info, _force = false )
	{
		local ours = _info != null && _info.Custom != null && "BVEnemyResurrections" in _info.Custom;
		if (ours && (!_info.Custom.BVEnemyCanResurrect || _info.Custom.BVEnemyResurrections > 1
			|| ("BVEnemyRaised" in _info.Custom && _info.Custom.BVEnemyRaised))) return null;
		local result = __original(_info, _force);
		if (ours && result != null) _info.Custom.BVEnemyRaised <- true;
		return result;
	}
});
ns.MH.hook("scripts/items/item", function(q) {
	q.isDroppedAsLoot = @(__original) function()
	{
		// Hold guaranteed gear until victory. A corpse, a summoned killer or
		// repeated resurrection cannot award another copy through native loot.
		return this.getFlags().get("BVEnemyRewardLocked") == true ? false : __original();
	}
});
ns.MH.hook("scripts/entity/world/world_entity", function(q) {
	q.onSerialize = @(__original) function( _out )
	{
		// The native flags precede our versioned section; old saves read no extra bytes.
		this.getFlags().set("BVEnemyRewardsVersion", 1);
		__original(_out);
		::$bvvar{namespace}.EnemyRewards.serializeParty(this, _out);
	}
	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::$bvvar{namespace}.EnemyRewards.deserializeParty(this, _in);
	}
});
ns.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		::$bvvar{namespace}.EnemyRewards.resetBattle();
		return __original();
	}
	q.gatherLoot = @(__original) function()
	{
		local result = __original();
		::$bvvar{namespace}.EnemyRewards.collect(this);
		return result;
	}
	q.tactical_combat_result_screen_onQueryCombatInformation = @(__original) function()
	{
		local dto = __original();
		local summary = ::$bvvar{namespace}.EnemyRewards.Summary;
		if (summary != "") dto.subTitle += " | " + summary;
		return dto;
	}
	q.tactical_combat_result_screen_onLeavePressed = @(__original) function()
	{
		::$bvvar{namespace}.EnemyRewards.retainUnclaimed(this);
		return __original();
	}
});
ns.MH.hook("scripts/states/world_state", function(q) {
	q.startNewCampaign = @(__original) function()
	{
		::$bvvar{namespace}.EnemyRewards.resetWorld();
		return __original();
	}
	q.onUpdate = @(__original) function()
	{
		local result = __original();
		// Wait until inventory/town/event screens close, so their cached slots
		// cannot be invalidated while the player is moving or selling an item.
		if (!this.m.IsGameOver && this.m.MenuStack != null && !this.m.MenuStack.hasBacksteps()
			&& this.m.CombatProperties == null)
			::$bvvar{namespace}.EnemyRewards.deliverPending();
		return result;
	}
	q.onSerialize = @(__original) function( _out )
	{
		::World.Flags.set("BVEnemyPendingVersion", 1);
		__original(_out);
		local s = ::$bvvar{namespace}.EnemyRewards;
		if (s.Pending == null) s.Pending = s.stash();
		s.Pending.onSerialize(_out);
	}
	q.onDeserialize = @(__original) function( _in )
	{
		local s = ::$bvvar{namespace}.EnemyRewards;
		s.resetWorld();
		__original(_in);
		if (::World.Flags.get("BVEnemyPendingVersion") == 1)
		{
			s.Pending = s.stash();
			s.Pending.onDeserialize(_in);
		}
	}
});
