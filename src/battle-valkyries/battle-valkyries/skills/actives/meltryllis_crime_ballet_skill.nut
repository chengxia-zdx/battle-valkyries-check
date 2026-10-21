this.meltryllis_crime_ballet_skill <- this.inherit("$bvvar{privateFolder}/skills/actives/meltryllis_active_skill", {
	m = { PendingMove = null, MovementDiagnosticCast = 0 },
	function create() { this.meltryllis_active_skill.create(); this.m.IsTargetingActor = false; }
	// Temporary, observational diagnostics for the live two-tile movement failure.
	function movementDiagnosticTile(_tile)
	{
		if (_tile == null) return "null";
		local text = "id=" + _tile.ID + ",level=" + _tile.Level + ",empty=" + _tile.IsEmpty;
		try { text += ",xy=" + _tile.SquareCoords.X + ":" + _tile.SquareCoords.Y; } catch (e) {}
		return text;
	}
	function traceMovement(_stage, _entity, _tag = null, _details = "")
	{
		// Logging must never alter movement or hide an original gameplay exception.
		try
		{
			if (!("logInfo" in getroottable())) return;
			local text = "[Battle Valkyries] [MovementDiag:v2] skill=meltryllis_crime_ballet stage=" + _stage;
			text += " cast=" + (_tag != null && "DiagnosticCast" in _tag ? _tag.DiagnosticCast : this.m.MovementDiagnosticCast);
			if (_tag != null) text += " index=" + _tag.Index + " length=" + _tag.Path.len() + " pendingMatch=" + (this.m.PendingMove == _tag);
			if (_entity != null)
			{
				try { text += " actor=" + _entity.getID(); } catch (e) {}
				try { text += " placed=" + _entity.isPlacedOnMap() + " tile={" + this.movementDiagnosticTile(_entity.getTile()) + "}"; } catch (e) { text += " tileError=" + e; }
				try { text += " rooted=" + _entity.getCurrentProperties().IsRooted; } catch (e) {}
				try { text += " moving=" + _entity.m.IsMoving; } catch (e) {}
				try { text += " travelling=" + this.Tactical.getNavigator().isTravelling(_entity); } catch (e) {}
				try { text += " busy=" + _entity.getSkills().isBusy(); } catch (e) {}
			}
			::logInfo(text + " " + _details);
		}
		catch (e) {}
	}
	function findPath(_origin, _destination)
	{
		if (_destination == null) return null;
		if (_destination.ID == _origin.ID) return [];
		if (this.owner().getCurrentProperties().IsRooted || !_destination.IsEmpty || _origin.getDistanceTo(_destination) > 2) return null;
		local queue = [{Tile=_origin, Path=[]}], seen = {};
		seen[_origin.ID] <- true;
		for (local i=0; i<queue.len(); i++)
		{
			local node = queue[i];
			if (node.Path.len() >= 2) continue;
			for (local d=0; d<6; d++)
			{
				if (!node.Tile.hasNextTile(d)) continue;
				local next = node.Tile.getNextTile(d);
				if (next.ID in seen || !next.IsEmpty || this.Math.abs(next.Level-node.Tile.Level)>1) continue;
				seen[next.ID] <- true;
				local path = clone node.Path; path.push(next);
				if (next.ID == _destination.ID) return path;
				queue.push({Tile=next,Path=path});
			}
		}
		return null;
	}
	function onVerifyTarget(_originTile, _targetTile) { return this.findPath(_originTile, _targetTile) != null; }
	function releaseMovement(_reason = "lifecycle")
	{
		local tag = this.m.PendingMove;
		if (tag != null) this.traceMovement("release", ::$bvvar{namespace}.readValkyrieCombatWeakRef(tag.Hold.Actor), tag, "reason=" + _reason);
		this.m.PendingMove = null;
		if (tag != null) ::$bvvar{namespace}.endValkyrieMovement(tag.Hold);
	}
	function nextStep(_entity, _tag)
	{
		this.traceMovement(_tag.Index == 0 ? "start-step" : "resume-step", _entity, _tag);
		if (this.m.PendingMove != _tag) { this.traceMovement("ignored", _entity, _tag, "reason=stale-tag"); return; }
		if (_entity == null || ::$bvvar{namespace}.isActorDeadOrDying(_entity) || !_entity.isPlacedOnMap()
			|| _entity.getCurrentProperties().IsRooted || _tag.Index >= _tag.Path.len())
		{
			local reason = _entity == null ? "null-actor" : (::$bvvar{namespace}.isActorDeadOrDying(_entity) ? "dead-actor" : (!_entity.isPlacedOnMap() ? "unplaced" : (_entity.getCurrentProperties().IsRooted ? "rooted" : "path-completed")));
			this.releaseMovement(reason); return;
		}
		if (_entity.getCurrentProperties().IsStunned || !_entity.getCurrentProperties().IsAbleToUseSkills) { this.releaseMovement("unable-to-act"); return; }
		local tile = _tag.Path[_tag.Index];
		this.traceMovement("validate-step", _entity, _tag, "next={" + this.movementDiagnosticTile(tile) + "} distance=" + _entity.getTile().getDistanceTo(tile) + " levelDelta=" + this.Math.abs(tile.Level-_entity.getTile().Level));
		if (!tile.IsEmpty || _entity.getTile().getDistanceTo(tile)!=1 || this.Math.abs(tile.Level-_entity.getTile().Level)>1)
		{ this.releaseMovement(!tile.IsEmpty ? "occupied-next" : (_entity.getTile().getDistanceTo(tile)!=1 ? "nonadjacent-next" : "height-difference")); return; }
		_tag.Index++;
		_entity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
		this.traceMovement("teleport-before", _entity, _tag, "destination={" + this.movementDiagnosticTile(tile) + "}");
		try
		{
			local step = { Move=_tag, Index=_tag.Index, Tile=tile, Queued=false };
			this.Tactical.getNavigator().teleport(_entity, tile, this.onBalletStep.bindenv(this), step, false, 3.0);
			this.traceMovement("teleport-returned", _entity, _tag);
		}
		catch (e) { this.traceMovement("exception", _entity, _tag, "error=" + e); this.releaseMovement("teleport-exception"); throw e; }
	}
	function onBalletStep(_entity, _step)
	{
		local tag = _step.Move;
		if (this.m.PendingMove != tag || tag.Index != _step.Index || _step.Queued) return;
		_step.Queued = true;
		this.traceMovement("arrival-callback", _entity, tag);
		::$bvvar{namespace}.queueValkyrieMovementArrival(tag.Hold, this.onBalletArrived.bindenv(this), _step);
	}
	function onBalletArrived(_entity, _step)
	{
		local tag = _step.Move;
		if (this.m.PendingMove != tag || tag.Index != _step.Index) return;
		if (_entity.getTile().ID != _step.Tile.ID) { this.releaseMovement("unexpected-arrival"); return; }
		this.nextStep(_entity, tag);
	}
	function isUsable() { return this.m.PendingMove == null && this.meltryllis_active_skill.isUsable(); }
	function onUse(_user, _targetTile)
	{
		this.m.MovementDiagnosticCast++;
		this.traceMovement("cast", _user, null, "target={" + this.movementDiagnosticTile(_targetTile) + "}");
		if (!this.isUsable()) { this.traceMovement("cast-rejected", _user, null, "reason=unusable"); return false; }
		local path = this.findPath(_user.getTile(), _targetTile);
		if (path == null) { this.traceMovement("cast-rejected", _user, null, "reason=no-path"); return false; }
		local route = "";
		foreach (tile in path) route += " {" + this.movementDiagnosticTile(tile) + "}";
		this.traceMovement("path", _user, null, "length=" + path.len() + " route=" + route);
		this.startCooldown();
		if (this.getContainer().getSkillByID("$bvvar{modId}.effects.meltryllis_ballet") == null)
			this.getContainer().add(this.new("$bvvar{privateFolder}/skills/effects/meltryllis_ballet_effect"));
		if (path.len() > 0)
		{
			local tag = { Path=path, Index=0, DiagnosticCast=this.m.MovementDiagnosticCast, Hold=null };
			local skill = this;
			tag.Hold = ::$bvvar{namespace}.beginValkyrieMovement(_user, function(){skill.releaseMovement("cancelled");});
			if (tag.Hold == null) return false;
			this.m.PendingMove = tag;
			try { this.nextStep(_user, tag); }
			catch (e) { this.releaseMovement("step-exception"); throw e; }
		}
		if ("playValkyrieSkillAudio" in ::$bvvar{namespace}) ::$bvvar{namespace}.playValkyrieSkillAudio(_user, "meltryllis_crime_ballet_cast");
		return true;
	}
	function onDeath(_fatalityType) { this.releaseMovement("death"); }
	function onRemoved() { this.releaseMovement("removed"); }
	function onCombatStarted() { this.releaseMovement(); this.meltryllis_active_skill.onCombatStarted(); }
	function onCombatFinished() { this.releaseMovement(); this.meltryllis_active_skill.onCombatFinished(); }
});
