// Registered after optional Legends hooks; deployment also waits for its
// instance hooks. Native deployment/serialization implementations stay intact.
::$bvvar{namespace}.Roster.Legends = ::Hooks.hasMod("mod_legends");
::$bvvar{namespace}.MH.hook("scripts/states/world_state", function(q) {
	q.onDeserialize = @(__original) function( _in )
	{
		// Assets updateFormation runs before Origin.onInit; MSU restores saved
		// settings only after the native world reader returns. Neither temporary
		// combat limit may demote the saved frontline while loading is incomplete.
		local r = ::$bvvar{namespace}.Roster;
		++r.LoadingDepth;
		local ret = null;
		try { ret = __original(_in); }
		catch (e) { --r.LoadingDepth; throw e; }
		--r.LoadingDepth;
		r.normalize();
		return ret;
	};
});

::$bvvar{namespace}.MH.hook("scripts/states/world/asset_manager", function(q) {
	q.getBrothersMax = @(__original) function()
	{
		if (!::$bvvar{namespace}.Roster.enabled()) return __original();
		return ::Math.max(__original(), ::$bvvar{namespace}.Roster.capacity());
	};
	q.getBrothersMaxInCombat = @(__original) function()
	{
		local value = ::$bvvar{namespace}.Roster.combatOverride();
		return value == 0 ? __original() : value;
	};
	q.getFormation = @(__original) function()
	{
		local r = ::$bvvar{namespace}.Roster;
		return r.available() ? r.formation() : __original();
	};
	q.saveEquipment = @(__original) function()
	{
		return ::$bvvar{namespace}.Roster.withNativeFrontline(__original.bindenv(this));
	};
	q.updateFormation = @(__original) function( considerMaxBros = false )
	{
		local r = ::$bvvar{namespace}.Roster;
		if (!r.available()) return __original(considerMaxBros);
		r.normalize();
	};
});

::$bvvar{namespace}.MH.hook("scripts/states/tactical_state", function(q) {
	q.onInit = @(__original) function()
	{
		local ret = __original();
		// Legends uses an old new-object hook, after Modern Hooks has already
		// modified the prototype. Wrap its finished instance before any battle.
		this.m.Factions.installBVRosterDeployment();
		return ret;
	};
	q.onBattleEnded = @(__original) function()
	{
		return ::$bvvar{namespace}.Roster.withNativeFrontline(__original.bindenv(this));
	};
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/player", function(q) {
	if (!::$bvvar{namespace}.Roster.Legends)
	{
		q.getTooltip = @(__original) function( _targetedWithSkill = null )
		{
			// Vanilla labels every coordinate above 17 as "in reserve".
			local r = ::$bvvar{namespace}.Roster;
			if (!r.enabled()) return __original(_targetedWithSkill);
			return r.withNativeFrontline(function() { return __original(_targetedWithSkill); }.bindenv(this));
		};
	}
	q.onHired = @(__original) function()
	{
		local ret = __original(), r = ::$bvvar{namespace}.Roster;
		if (r.find(this.getID()) == this) r.setPosition(this, 255);
		return ret;
	};
	// Legends presets persist coordinates but not reserve flags. Restore the
	// matching native flag before updateFormation validates the selected preset.
	if (::$bvvar{namespace}.Roster.Legends)
	{
		q.setFormation = @(__original) function( _index, _stash )
		{
			local ret = __original(_index, _stash);
			if (::$bvvar{namespace}.Roster.enabled()) this.setInReserves(this.getPlaceInFormation() == 255);
			return ret;
		};
	}
});

::$bvvar{namespace}.MH.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	local wrappers = {};
	wrappers.spawn <- @(__original) function( _properties )
	{
		local r = ::$bvvar{namespace}.Roster;
		if (!r.available()) return __original(_properties);
		if (!_properties.IsUsingSetPlayers)
		{
			r.normalize();
			// Vanilla selection rejects third-rank coordinates >=18.
			// Mask only those coordinates until selection finishes;
			// restore them before placement and the scenario callback.
			local saved = [], nativeSlots = r.Legends ? 27 : 18;
			foreach (a in r.actors())
				if (!r.reserve(a) && a.getPlaceInFormation() >= nativeSlots)
					saved.push({ Actor = a, Position = a.getPlaceInFormation() });
			if (saved.len() == 0) return __original(_properties);
			local callback = _properties.BeforeDeploymentCallback;
			local restore = function() { foreach (entry in saved) entry.Actor.setPlaceInFormation(entry.Position); };
			++r.SetPlayersDepth;
			try
			{
				foreach (entry in saved) entry.Actor.setPlaceInFormation(entry.Position % nativeSlots);
				_properties.BeforeDeploymentCallback = function()
				{
					restore();
					if (callback != null) callback.bindenv(_properties)();
				};
				__original(_properties);
			}
			catch (e)
			{
				restore(); _properties.BeforeDeploymentCallback = callback; --r.SetPlayersDepth;
				throw e;
			}
			restore(); _properties.BeforeDeploymentCallback = callback; --r.SetPlayersDepth;
			return;
		}
		// Arena/scripted line-ups can explicitly select a reserve. Give ONLY those
		// actors temporary legal coordinates; never replace the scenario's list.
		local saved = [];
		++r.SetPlayersDepth;
		try
		{
			foreach (i, a in _properties.Players)
			{
				saved.push({ Actor = a, Position = a.getPlaceInFormation(), Reserve = r.Legends ? a.isInReserves() : false });
				r.setPosition(a, i % (r.Legends ? 27 : 18));
			}
			__original(_properties);
		}
		catch (e)
		{
			foreach (entry in saved) { entry.Actor.setPlaceInFormation(entry.Position); if (r.Legends) entry.Actor.setInReserves(entry.Reserve); }
			--r.SetPlayersDepth;
			throw e;
		}
		foreach (entry in saved) { entry.Actor.setPlaceInFormation(entry.Position); if (r.Legends) entry.Actor.setInReserves(entry.Reserve); }
		--r.SetPlayersDepth;
	};
	wrappers.placePlayersAtBorder <- @(__original) function( _players )
	{
		if (!::$bvvar{namespace}.Roster.enabled()) return __original(_players);
		local extended = [], native = [];
		foreach (a in _players) (a.getPlaceInFormation() >= 18 ? extended : native).push(a);
		if (extended.len() == 0) return __original(_players);
		__original(native);
		// Native border placement assumes two ranks. Keep nine columns
		// and place the third rank behind them at y=1.
		foreach (a in extended)
		{
			local p = a.getPlaceInFormation();
			local tile = this.Tactical.getTileSquare(11 + p % 9, 3 - p / 9);
			if (!tile.IsEmpty) tile.removeObject();
			if (this.isTileIsolated(tile))
			{
				local avg = 0;
				for (local i = 0; i < 6; ++i) if (tile.hasNextTile(i)) avg += tile.getNextTile(i).Level;
				tile.Level = avg / 6;
			}
			this.Tactical.addEntityToMap(a, tile.Coords.X, tile.Coords.Y);
			if (!this.World.getTime().IsDaytime && a.getBaseProperties().IsAffectedByNight)
				a.getSkills().add(this.new("scripts/skills/special/night_effect"));
		}
	};
	// Vanilla has no later instance replacement, so keep normal Modern Hooks
	// validation and wrapping there. Legends must wait until onInit returns.
	q.m.BVRosterDeploymentInstalled <- !::$bvvar{namespace}.Roster.Legends;
	if (!::$bvvar{namespace}.Roster.Legends)
		foreach (method, wrapper in wrappers) q[method] = wrapper;
	q.installBVRosterDeployment <- function()
	{
		if (this.m.BVRosterDeploymentInstalled) return;
		foreach (method, wrapper in wrappers) this[method] = wrapper(this[method]);
		this.m.BVRosterDeploymentInstalled = true;
	};
});

::$bvvar{namespace}.MH.hook("scripts/ui/screens/character/character_screen", function(q) {
	q.m.BVRosterSession <- null;
	q.getBVRosterSession <- function()
	{
		if (this.m.BVRosterSession == null) this.m.BVRosterSession = { Undo = null, UndoVersion = null };
		return this.m.BVRosterSession;
	};
	q.queryBattleValkyrieRoster <- function()
	{
		local dto = ::$bvvar{namespace}.Roster.dto(this.getBVRosterSession());
		if (dto != null) dto.Editable = dto.Editable && this.isInStashMode();
		return dto;
	};
	q.strategic_onQueryBrothersList = @(__original) function()
	{
		local r = ::$bvvar{namespace}.Roster;
		if (!r.available()) return __original();
		if (!r.locked()) r.normalize();
		local actors = r.formation().slice(0, r.slots()), result = [];
		foreach (a in r.actors()) if (r.reserve(a)) actors.push(a);
		foreach (a in actors)
		{
			if (a == null) { result.push(null); continue; }
			local data = this.UIDataHelper.convertEntityToUIData(a, null);
			data.BVRosterMember <- { Reserve = r.reserve(a), Position = a.getPlaceInFormation() };
			result.push(data);
		}
		return result;
	};
	q.queryData = @(__original) function()
	{
		local result = __original();
		if (::$bvvar{namespace}.Roster.enabled() && !::Tactical.isActive())
		{
			result.BVRoster <- this.queryBattleValkyrieRoster();
			result.BVOpenRoster <- ::$bvvar{namespace}.Roster.OpenFromHub;
			::$bvvar{namespace}.Roster.OpenFromHub = false;
		}
		return result;
	};
	q.loadBrothersList = @(__original) function()
	{
		// Clear a previously enabled UI before the native list notification.
		if (!::$bvvar{namespace}.Roster.enabled() && this.m.JSDataSourceHandle != null)
			this.m.JSDataSourceHandle.asyncCall("loadBattleValkyrieRoster", null);
		__original();
		if (!::Tactical.isActive() && this.m.JSDataSourceHandle != null)
			this.m.JSDataSourceHandle.asyncCall("loadBattleValkyrieRoster", this.queryBattleValkyrieRoster());
	};
	q.onBattleValkyrieRosterCommand <- function( _request )
	{
		local r = ::$bvvar{namespace}.Roster;
		local before = {};
		foreach (entry in r.snapshot()) before[entry.ID] <- entry;
		local result = this.isInStashMode() && this.isVisible()
			? r.command(_request, this.getBVRosterSession())
			: r.result(false, "locked", "$bv{roster.error.locked}");
		if (!result.Success)
		{
			::logWarning("[Battle Valkyries] Roster command rejected: " + result.Code);
			// A stale request can mean membership changed; recover the complete
			// native equipment list on this exceptional path.
			return { Result = result, Roster = this.queryBattleValkyrieRoster(), Brothers = this.onQueryBrothersList() };
		}
		local dto = this.queryBattleValkyrieRoster(), changed = [];
		foreach (a in r.actors())
		{
			local id = a.getID();
			if (id in before && before[id].Position == a.getPlaceInFormation() && before[id].Reserve == r.reserve(a)) continue;
			local data = this.UIDataHelper.convertEntityToUIData(a, null);
			data.BVRosterMember <- { Reserve = r.reserve(a), Position = a.getPlaceInFormation() };
			changed.push(data);
		}
		// Moving two portraits must not serialize 200 inventories and perk trees.
		return { Result = result, Roster = dto, UpdatedBrothers = changed };
	};
	q.onUpdateRosterPosition = @(__original) function( _data )
	{
		if (!::$bvvar{namespace}.Roster.available()) return __original(_data);
		// Display indices are not formation coordinates. Reject legacy drag writes;
		// the new UI commits a validated, atomic swap through the command above.
		this.loadBrothersList();
	};
	if (::$bvvar{namespace}.Roster.Legends)
	{
		q.onToggleReserveCharacter = @(__original) function( _id )
		{
			if (!::$bvvar{namespace}.Roster.enabled()) return __original(_id);
			local r = ::$bvvar{namespace}.Roster, a = r.find(_id);
			if (a == null) return null;
			local position = 0, slots = r.formation();
			while (position < r.slots() && slots[position] != null) ++position;
			if (this.isInStashMode() && this.isVisible())
				r.command({ Action = r.reserve(a) ? "deploy" : "reserve", ActorID = _id, Position = position, Version = r.version() }, this.getBVRosterSession());
			this.loadBrothersList();
			this.setRosterLimit();
			return this.UIDataHelper.convertEntityToUIData(a, null);
		};
	}
	q.hide = @(__original) function()
	{
		this.m.BVRosterSession = null;
		return __original();
	};
});

::$bvvar{namespace}.MH.hook("scripts/ui/screens/world/modules/topbar/world_screen_topbar_options_module", function(q) {
	q.openBattleValkyrieRoster <- function()
	{
		if (::$bvvar{namespace}.Roster.locked()) return false;
		::$bvvar{namespace}.Roster.OpenFromHub = true;
		this.onBrothersButtonPressed();
		::$bvvar{namespace}.Roster.OpenFromHub = false;
		return true;
	};
});
