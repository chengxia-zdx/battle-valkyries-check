(function()
{
	"use strict";

	function installTurnSequenceDeadEntityGuard()
	{
		if (typeof TacticalScreenTurnSequenceBarModule === "undefined")
		{
			return false;
		}

		var prototype = TacticalScreenTurnSequenceBarModule.prototype;
		if (prototype.BattleValkyriesDeadEntityGuardInstalled === true)
		{
			return true;
		}

		var originalNotify = prototype.notifyBackendEntityEntersFirstSlot;
		if (typeof originalNotify !== "function")
		{
			return false;
		}

		prototype.notifyBackendEntityEntersFirstSlot = function(_entityID, _callback)
		{
			var self = this;
			return originalNotify.call(this, _entityID, function(_entityData)
			{
				if (_entityData !== null && _entityData !== undefined)
				{
					_callback(_entityData);
					return;
				}

				if (self.mSQHandle === null || self.mSQHandle === undefined || typeof SQ === "undefined")
				{
					_callback(_entityData);
					return;
				}

				SQ.call(self.mSQHandle, "BV_removeInvalidTurnSequenceEntity", _entityID, function(_result)
				{
					if (_result !== null && _result !== undefined && _result.Handled === true)
					{
						if (_result.RequiresClientRemoval === true && typeof self.removeEntity === "function")
						{
							self.removeEntity(_entityID);
						}

						return;
					}

					_callback(_entityData);
				});
			});
		};

		prototype.BattleValkyriesDeadEntityGuardInstalled = true;
		return true;
	}

	// Normally registerJS runs after the tactical module is declared. Keep a
	// bounded retry as a compatibility fallback for loaders that defer it.
	function installWhenTurnSequenceModuleIsReady(_attempt)
	{
		if (installTurnSequenceDeadEntityGuard())
		{
			return;
		}

		if (_attempt >= 40)
		{
			return;
		}

		window.setTimeout(function()
		{
			installWhenTurnSequenceModuleIsReady(_attempt + 1);
		}, 50);
	}

	installWhenTurnSequenceModuleIsReady(0);
})();
