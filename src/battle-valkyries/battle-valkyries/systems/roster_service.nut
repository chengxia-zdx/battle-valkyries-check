// Members remain in the engine roster. Only deployed actors own a formation
// coordinate; 255 is the existing serialized "not in formation" sentinel.
::$bvvar{namespace}.Roster <- {
	Legends = false,
	SetPlayersDepth = 0,
	Normalizing = false,
	LoadingDepth = 0,
	OpenFromHub = false,
	Bypass = false,
	function enabled() { return !this.Bypass && ::$bvvar{namespace}.getSettingValue("EnableRosterExpansion") != false; },
	function worldAvailable()
	{
		return "World" in getroottable() && ::World != null && "Assets" in ::World && ::World.Assets != null
			&& ::World.getPlayerRoster() != null;
	},
	function available() { return this.enabled() && this.worldAvailable(); },
	function switchBlockedReason( _enabled )
	{
		if (this.SetPlayersDepth > 0 || ("Tactical" in getroottable() && ::Tactical.isActive()))
			return "$bv{settings.enable_roster_expansion.battle}";
		if (_enabled || !this.worldAvailable()) return null;
		local previous = this.Bypass, capacity = 0;
		this.Bypass = true;
		try { capacity = ::World.Assets.getBrothersMax(); }
		catch (e) { this.Bypass = previous; throw e; }
		this.Bypass = previous;
		return ::World.getPlayerRoster().getSize() > capacity ? "$bv{settings.enable_roster_expansion.capacity}" + " " + capacity : null;
	},
	function prepareSwitch( _enabled )
	{
		if (!this.worldAvailable()) return true;
		local saved = [], previous = this.Bypass;
		foreach (a in ::World.getPlayerRoster().getAll())
			saved.push({ Actor = a, Position = a.getPlaceInFormation(), Reserve = this.Legends ? a.isInReserves() : false });
		this.Bypass = true;
		try
		{
			if (_enabled)
			{
				local reserveStart = ::$bvvar{namespace}.getValkyrieSummonReserveSlotStart();
				foreach (entry in saved)
					if (this.Legends ? entry.Reserve : entry.Position >= reserveStart) this.setPosition(entry.Actor, 255);
			}
			else
			{
				// Let the active native/other-mod formation owner allocate legal
				// coordinates, including its reserves, before removing the adapter.
				foreach (entry in saved) entry.Actor.setPlaceInFormation(255);
				::World.Assets.updateFormation(true);
				::World.Assets.getFormation();
				foreach (entry in saved) if (entry.Actor.getPlaceInFormation() == 255) throw "Native formation has no room for all members";
			}
		}
		catch (e)
		{
			foreach (entry in saved) { entry.Actor.setPlaceInFormation(entry.Position); if (this.Legends) entry.Actor.setInReserves(entry.Reserve); }
			this.Bypass = previous;
			::logWarning("[Battle Valkyries] Roster switch rolled back: " + e);
			return false;
		}
		this.Bypass = previous;
		this.OpenFromHub = false;
		return true;
	},
	function actors() { return this.available() ? ::World.getPlayerRoster().getAll() : []; },
	function combatOverride()
	{
		if (!this.enabled()) return 0;
		local value = ::$bvvar{namespace}.getSettingValue("CombatCapacity");
		if (value == 28) return 27; // Legacy preference before the three-rank limit.
		return [16, 18, 20, 22, 24, 26, 27].find(value) != null ? value : 0;
	},
	function slots()
	{
		return 27;
	},
	function capacity()
	{
		local value = ::$bvvar{namespace}.getSettingValue("RosterCapacity");
		return ::Math.max(50, ::Math.min(200, value.tointeger()));
	},
	function combatMax()
	{
		return this.available() ? ::Math.max(1, ::Math.min(this.slots(), ::World.Assets.getBrothersMaxInCombat())) : 12;
	},
	// Native battle-result/equipment code tests coordinates against a fixed
	// frontline bound. Preserve those implementations while extending membership.
	function withNativeFrontline( _callback )
	{
		if (!this.enabled()) return _callback();
		local saved = [], nativeSlots = this.Legends ? 27 : 18;
		foreach (a in this.actors())
		{
			local p = a.getPlaceInFormation();
			if (p >= nativeSlots && p < this.slots() && !(this.Legends && a.isInReserves()))
				saved.push({ Actor = a, Position = p });
		}
		if (saved.len() == 0) return _callback();
		++this.SetPlayersDepth;
		local result = null;
		try
		{
			foreach (entry in saved) entry.Actor.setPlaceInFormation(entry.Position % nativeSlots);
			result = _callback();
		}
		catch (e)
		{
			foreach (entry in saved) entry.Actor.setPlaceInFormation(entry.Position);
			--this.SetPlayersDepth;
			throw e;
		}
		foreach (entry in saved) entry.Actor.setPlaceInFormation(entry.Position);
		--this.SetPlayersDepth;
		return result;
	},
	function find( _id )
	{
		foreach (a in this.actors()) if (a.getID() == _id) return a;
		return null;
	},
	function eligible( _a )
	{
		return _a != null && _a.isAlive() && !_a.isDying()
			&& !(this.Legends && "isStabled" in _a && _a.isStabled());
	},
	function reserve( _a )
	{
		local p = _a.getPlaceInFormation();
		return p < 0 || p >= this.slots() || (this.Legends && _a.isInReserves());
	},
	function setPosition( _a, _position )
	{
		if (_a.getPlaceInFormation() != _position) _a.setPlaceInFormation(_position);
		if (this.Legends && _a.isInReserves() != (_position == 255)) _a.setInReserves(_position == 255);
	},
	function normalize()
	{
		if (!this.available() || this.LoadingDepth > 0 || this.Normalizing || this.SetPlayersDepth > 0) return;
		this.Normalizing = true;
		try
		{
			local roster = this.actors(), used = array(this.slots(), false), count = 0, limit = this.combatMax();
			foreach (a in roster)
			{
				if (!this.eligible(a) || this.reserve(a) || count >= limit)
				{
					this.setPosition(a, 255);
					continue;
				}
				local p = a.getPlaceInFormation();
				if (used[p]) p = used.find(false);
				if (p == null) { this.setPosition(a, 255); continue; }
				this.setPosition(a, p);
				used[p] = true;
				++count;
			}
			// Death, dismissal or an old all-reserve save must not leave the company
			// unable to deploy. Never add a second reserve automatically.
			if (count == 0)
				foreach (a in roster) if (this.eligible(a)) { this.setPosition(a, 4); break; }
		}
		catch (e) { this.Normalizing = false; throw e; }
		this.Normalizing = false;
	},
	function formation()
	{
		local result = array(this.slots(), null);
		foreach (a in this.actors())
			if (!this.reserve(a) && this.eligible(a)) result[a.getPlaceInFormation()] = a;
		return result;
	},
	function snapshot()
	{
		local result = [];
		foreach (a in this.actors()) result.push({ ID = a.getID(), Position = a.getPlaceInFormation(), Reserve = this.reserve(a) });
		return result;
	},
	function version()
	{
		local result = this.combatMax() + ":" + this.capacity();
		foreach (a in this.actors())
			result += "|" + a.getID() + ":" + a.getPlaceInFormation() + ":" + (this.reserve(a) ? 1 : 0) + ":" + (this.eligible(a) ? 1 : 0);
		return result;
	},
	function restore( _snapshot )
	{
		foreach (entry in _snapshot)
		{
			local a = this.find(entry.ID);
			if (a == null) continue;
			a.setPlaceInFormation(entry.Position);
			if (this.Legends) a.setInReserves(entry.Reserve);
		}
	},
	function result( _success, _code, _message ) { return { Success = _success, Code = _code, Message = _message }; },
	function locked() { return !this.available() || ::Tactical.isActive() || this.SetPlayersDepth > 0; },
	function command( _request, _session )
	{
		if (this.locked()) return this.result(false, "locked", "$bv{roster.error.locked}");
		this.normalize();
		if (typeof _request != "table" || !("Version" in _request) || !("Action" in _request))
			return this.result(false, "invalid", "$bv{roster.error.invalid}");
		if (_request.Version != this.version()) return this.result(false, "stale", "$bv{roster.error.stale}");
		if (_request.Action == "undo")
		{
			if (_session.Undo == null || _session.UndoVersion != this.version())
				return this.result(false, "stale", "$bv{roster.error.stale}");
			local beforeUndo = this.snapshot();
			try { this.restore(_session.Undo); }
			catch (e)
			{
				this.restore(beforeUndo);
				::logWarning("[Battle Valkyries] Roster undo rolled back: " + e);
				return this.result(false, "failed", "$bv{roster.error.failed}");
			}
			_session.Undo = null;
			return this.result(true, "success", "$bv{roster.undone}");
		}
		if (!("ActorID" in _request)) return this.result(false, "invalid", "$bv{roster.error.invalid}");
		local a = this.find(_request.ActorID);
		if (!this.eligible(a)) return this.result(false, "invalid", "$bv{roster.error.invalid}");
		local before = this.snapshot(), count = 0;
		foreach (actor in this.actors()) if (!this.reserve(actor)) ++count;
		local target = null, position = 255;
		if (_request.Action == "reserve")
		{
			if (this.reserve(a)) return this.result(false, "invalid", "$bv{roster.error.invalid}");
			if (count <= 1) return this.result(false, "last", "$bv{roster.error.last}");
		}
		else if (_request.Action == "deploy")
		{
			if (!("Position" in _request) || typeof _request.Position != "integer"
				|| _request.Position < 0 || _request.Position >= this.slots())
				return this.result(false, "invalid", "$bv{roster.error.invalid}");
			position = _request.Position;
			foreach (actor in this.actors()) if (!this.reserve(actor) && actor.getPlaceInFormation() == position) target = actor;
			if (target == a) return this.result(false, "invalid", "$bv{roster.error.invalid}");
			if (this.reserve(a) && target == null && count >= this.combatMax())
				return this.result(false, "full", "$bv{roster.error.full}");
		}
		else return this.result(false, "invalid", "$bv{roster.error.invalid}");
		try
		{
			local old = this.reserve(a) ? 255 : a.getPlaceInFormation();
			if (target != null) this.setPosition(target, old);
			this.setPosition(a, position);
			_session.Undo = before;
			_session.UndoVersion = this.version();
		}
		catch (e)
		{
			this.restore(before);
			::logWarning("[Battle Valkyries] Roster transaction rolled back: " + e);
			return this.result(false, "failed", "$bv{roster.error.failed}");
		}
		return this.result(true, "success", "$bv{roster.changed}");
	},
	function dto( _session )
	{
		if (!this.available()) return null;
		if (!this.locked()) this.normalize();
		local members = [], count = 0;
		foreach (a in this.actors())
		{
			local isReserve = this.reserve(a), identity = ::$bvvar{namespace}.getActorValkyrieID(a);
			if (!isReserve) ++count;
			members.push({ ID = a.getID(), Name = a.getName(), Level = a.getLevel(), Image = a.getImagePath(),
				Valkyrie = identity != null, Reserve = isReserve, Position = isReserve ? null : a.getPlaceInFormation(),
				Eligible = this.eligible(a), Hurt = a.getHitpoints() < a.getHitpointsMax() || a.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury),
				Hitpoints = a.getHitpoints(), HitpointsMax = a.getHitpointsMax() });
		}
		local version = this.version();
		return { Version = version, Members = members, Capacity = ::World.Assets.getBrothersMax(), CombatMax = this.combatMax(),
			CombatOverride = this.combatOverride(),
			CombatCount = count, Slots = this.slots(), Legends = this.Legends, Editable = !this.locked(),
			DailyMoney = ::World.Assets.getDailyMoneyCost(), DailyFood = ::World.Assets.getDailyFoodCost(),
			CanUndo = _session.Undo != null && _session.UndoVersion == version };
	}
};
