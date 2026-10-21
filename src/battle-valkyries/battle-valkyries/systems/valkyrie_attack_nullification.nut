::$bvvar{namespace}.ValkyrieAttackNullifications <- {};

::$bvvar{namespace}.makeValkyrieAttackNullificationProviderRef <- function( _provider )
{
	if (_provider == null)
	{
		return null;
	}
	try
	{
		return ::WeakTableRef(_provider);
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.readValkyrieAttackNullificationProviderRef <- function( _providerRef )
{
	if (_providerRef == null)
	{
		return null;
	}
	try
	{
		if (typeof _providerRef != "instance" || !(_providerRef instanceof ::WeakTableRef) || _providerRef.isNull())
		{
			return null;
		}
		return _providerRef.get();
	}
	catch (e)
	{
		return null;
	}
};

::$bvvar{namespace}.isLiveValkyrieAttackNullificationProvider <- function( _provider )
{
	if (_provider == null)
	{
		return false;
	}
	try
	{
		return _provider.isGarbage() == false;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.copyValkyrieAttackNullificationConsumer <- function( _consumer )
{
	if (_consumer == null || typeof _consumer != "table"
		|| !("ProviderRef" in _consumer) || !("ConsumeToken" in _consumer)
		|| typeof _consumer.ConsumeToken != "string" || _consumer.ConsumeToken.len() == 0)
	{
		return null;
	}
	try
	{
		if (typeof _consumer.ProviderRef != "instance"
			|| !(_consumer.ProviderRef instanceof ::WeakTableRef)
			|| _consumer.ProviderRef.isNull())
		{
			return null;
		}
	}
	catch (e)
	{
		return null;
	}
	return {
		ProviderRef = _consumer.ProviderRef,
		ConsumeToken = _consumer.ConsumeToken
	};
};

::$bvvar{namespace}.normalizeValkyrieAttackNullificationPolicy <- function( _policy, _provider = null )
{
	if (_policy == null || typeof _policy != "table")
	{
		return null;
	}
	if ("NullifyDirectAttack" in _policy && typeof _policy.NullifyDirectAttack != "bool")
	{
		return null;
	}

	local ret = {
		NullifyDirectAttack = "NullifyDirectAttack" in _policy ? _policy.NullifyDirectAttack : false,
		Consumers = []
	};
	local consumeToken = "ConsumeToken" in _policy ? _policy.ConsumeToken : null;
	if (ret.NullifyDirectAttack && typeof consumeToken == "string" && consumeToken.len() > 0 && _provider != null)
	{
		local providerRef = this.makeValkyrieAttackNullificationProviderRef(_provider);
		if (providerRef != null)
		{
			ret.Consumers.push({ ProviderRef = providerRef, ConsumeToken = consumeToken });
		}
	}
	return ret;
};

::$bvvar{namespace}.mergeValkyrieAttackNullificationPolicy <- function( _current, _incoming )
{
	if (_incoming == null)
	{
		return _current;
	}
	if (_current != null && _current == _incoming)
	{
		return _current;
	}
	local ret = _current;
	if (ret == null)
	{
		ret = { NullifyDirectAttack = false, Consumers = [] };
	}
	ret.NullifyDirectAttack = ret.NullifyDirectAttack || _incoming.NullifyDirectAttack;
	if ("Consumers" in _incoming && typeof _incoming.Consumers == "array")
	{
		foreach (consumer in _incoming.Consumers)
		{
			local copied = this.copyValkyrieAttackNullificationConsumer(consumer);
			if (copied != null)
			{
				ret.Consumers.push(copied);
			}
		}
	}
	return ret;
};

::$bvvar{namespace}.isValkyrieAttackNullificationPolicyProvider <- function( _provider )
{
	if (_provider == null)
	{
		return false;
	}
	try
	{
		if (this.isBattleValkyriesManagedRuntimeSkill(_provider))
		{
			return true;
		}
	}
	catch (e)
	{
	}
	try
	{
		return _provider.isBattleValkyriesManagedCombatEffect() == true && _provider.isGarbage() == false;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.resolveValkyrieAttackNullificationPolicy <- function( _providers, _usedSkill, _attacker )
{
	if (typeof _providers != "array")
	{
		return null;
	}
	local ret = null;
	local seen = [];
	foreach (provider in _providers)
	{
		local duplicate = false;
		foreach (known in seen)
		{
			if (known == provider)
			{
				duplicate = true;
				break;
			}
		}
		if (duplicate)
		{
			continue;
		}
		seen.push(provider);
		if (!this.isValkyrieAttackNullificationPolicyProvider(provider))
		{
			continue;
		}
		try
		{
			local policy = this.normalizeValkyrieAttackNullificationPolicy(provider.getValkyrieAttackNullificationPolicy(_usedSkill, _attacker), provider);
			ret = this.mergeValkyrieAttackNullificationPolicy(ret, policy);
		}
		catch (e)
		{
		}
	}
	return ret;
};

::$bvvar{namespace}.isValidValkyrieAttackNullificationID <- function( _id )
{
	return _id != null && (typeof _id == "string" || typeof _id == "integer");
};

::$bvvar{namespace}.getValkyrieAttackNullification <- function( _actionToken, _targetID )
{
	if (!this.isValidValkyrieAttackNullificationID(_actionToken) || !this.isValidValkyrieAttackNullificationID(_targetID))
	{
		return null;
	}
	local reservations = this.ValkyrieAttackNullifications;
	if (!(_actionToken in reservations) || !(_targetID in reservations[_actionToken]))
	{
		return null;
	}
	return reservations[_actionToken][_targetID];
};

::$bvvar{namespace}.reserveValkyrieAttackNullification <- function( _actionToken, _targetID, _policy )
{
	if (!this.isValidValkyrieAttackNullificationID(_actionToken)
		|| !this.isValidValkyrieAttackNullificationID(_targetID)
		|| _policy == null || typeof _policy != "table"
		|| !("NullifyDirectAttack" in _policy) || typeof _policy.NullifyDirectAttack != "bool"
		|| !_policy.NullifyDirectAttack)
	{
		return null;
	}
	local existing = this.getValkyrieAttackNullification(_actionToken, _targetID);
	if (existing != null)
	{
		return existing;
	}
	local reservations = this.ValkyrieAttackNullifications;
	if (!(_actionToken in reservations))
	{
		reservations[_actionToken] <- {};
	}
	local consumers = [];
	if ("Consumers" in _policy && typeof _policy.Consumers == "array")
	{
		foreach (consumer in _policy.Consumers)
		{
			local copied = this.copyValkyrieAttackNullificationConsumer(consumer);
			if (copied != null)
			{
				consumers.push(copied);
			}
		}
	}
	local reservation = {
		ActionToken = _actionToken,
		TargetID = _targetID,
		NullifyDirectAttack = true,
		Consumers = consumers,
		Consumed = false
	};
	reservations[_actionToken][_targetID] <- reservation;
	return reservation;
};

::$bvvar{namespace}.consumeValkyrieAttackNullification <- function( _actionToken, _targetID, _context = null )
{
	local reservation = this.getValkyrieAttackNullification(_actionToken, _targetID);
	if (reservation == null || reservation.Consumed)
	{
		return false;
	}
	reservation.Consumed = true;
	local consumers = reservation.Consumers;
	reservation.Consumers = [];
	foreach (consumer in consumers)
	{
		try
		{
			local provider = this.readValkyrieAttackNullificationProviderRef(consumer.ProviderRef);
			if (!this.isLiveValkyrieAttackNullificationProvider(provider))
			{
				continue;
			}
			provider.consumeValkyrieAttackNullificationPolicy(consumer.ConsumeToken, _context);
		}
		catch (e)
		{
		}
	}
	return true;
};

::$bvvar{namespace}.clearValkyrieAttackNullificationConsumers <- function( _reservation )
{
	if (_reservation != null)
	{
		_reservation.Consumers = [];
	}
};

::$bvvar{namespace}.releaseValkyrieAttackNullification <- function( _actionToken, _targetID )
{
	local reservation = this.getValkyrieAttackNullification(_actionToken, _targetID);
	if (reservation == null)
	{
		return false;
	}
	this.clearValkyrieAttackNullificationConsumers(reservation);
	local reservations = this.ValkyrieAttackNullifications;
	delete reservations[_actionToken][_targetID];
	if (reservations[_actionToken].len() == 0)
	{
		delete reservations[_actionToken];
	}
	return true;
};

::$bvvar{namespace}.releaseValkyrieAttackNullificationsForAction <- function( _actionToken )
{
	if (!this.isValidValkyrieAttackNullificationID(_actionToken) || !(_actionToken in this.ValkyrieAttackNullifications))
	{
		return false;
	}
	foreach (reservation in this.ValkyrieAttackNullifications[_actionToken])
	{
		this.clearValkyrieAttackNullificationConsumers(reservation);
	}
	delete this.ValkyrieAttackNullifications[_actionToken];
	return true;
};

::$bvvar{namespace}.resetValkyrieAttackNullifications <- function()
{
	foreach (bucket in this.ValkyrieAttackNullifications)
	{
		foreach (reservation in bucket)
		{
			this.clearValkyrieAttackNullificationConsumers(reservation);
		}
	}
	this.ValkyrieAttackNullifications = {};
};

::$bvvar{namespace}.makeValkyrieNullifiedAttackResult <- function()
{
	return {
		Hit = true,
		Nullified = true,
		HitpointDamage = 0,
		ArmorDamage = 0
	};
};
