::$bvvar{namespace}.ValkyrieAttackDefenseClaims <- {};

::$bvvar{namespace}.makeValkyrieAttackDefenseProviderRef <- function( _provider )
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

::$bvvar{namespace}.readValkyrieAttackDefenseProviderRef <- function( _providerRef )
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

::$bvvar{namespace}.isLiveValkyrieAttackDefenseProvider <- function( _provider )
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

::$bvvar{namespace}.normalizeValkyrieAttackDefensePolicy <- function( _policy, _provider = null )
{
	if (_policy == null || typeof _policy != "table")
	{
		return null;
	}

	if ("IgnoreActualShield" in _policy && typeof _policy.IgnoreActualShield != "bool")
	{
		return null;
	}

	if ("HitChanceBonus" in _policy && typeof _policy.HitChanceBonus != "integer" && typeof _policy.HitChanceBonus != "float")
	{
		return null;
	}

	local ret = {
		IgnoreActualShield = "IgnoreActualShield" in _policy ? _policy.IgnoreActualShield : false,
		HitChanceBonus = "HitChanceBonus" in _policy ? _policy.HitChanceBonus : 0,
		Consumers = []
	};

	local consumeToken = "ConsumeToken" in _policy ? _policy.ConsumeToken : null;
	if (consumeToken != null && _provider != null)
	{
		local providerRef = this.makeValkyrieAttackDefenseProviderRef(_provider);
		if (providerRef != null)
		{
			ret.Consumers.push({ ProviderRef = providerRef, ConsumeToken = consumeToken });
		}
	}

	return ret;
};

::$bvvar{namespace}.mergeValkyrieAttackDefensePolicy <- function( _current, _incoming )
{
	if (_incoming == null)
	{
		return _current;
	}

	local ret = _current;
	if (ret == null)
	{
		ret = {
			IgnoreActualShield = false,
			HitChanceBonus = 0,
			Consumers = []
		};
	}

	ret.IgnoreActualShield = ret.IgnoreActualShield || _incoming.IgnoreActualShield;
	ret.HitChanceBonus += _incoming.HitChanceBonus;

	if ("Consumers" in _incoming && typeof _incoming.Consumers == "array")
	{
		foreach (consumer in _incoming.Consumers)
		{
			ret.Consumers.push(consumer);
		}
	}

	return ret;
};

::$bvvar{namespace}.isValkyrieAttackDefensePolicyProvider <- function( _provider )
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
		if (_provider.isBattleValkyriesManagedCombatEffect() != true)
		{
			return false;
		}
		return _provider.isGarbage() == false;
	}
	catch (e)
	{
		return false;
	}
};

::$bvvar{namespace}.resolveValkyrieAttackDefensePolicy <- function( _providers, _usedSkill )
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
		foreach (knownProvider in seen)
		{
			if (knownProvider == provider)
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

		if (!this.isValkyrieAttackDefensePolicyProvider(provider))
		{
			continue;
		}

		try
		{
			local policy = this.normalizeValkyrieAttackDefensePolicy(provider.getValkyrieAttackDefensePolicy(_usedSkill), provider);
			ret = this.mergeValkyrieAttackDefensePolicy(ret, policy);
		}
		catch (e)
		{
		}
	}

	return ret;
};

::$bvvar{namespace}.isValidValkyrieAttackDefenseClaimID <- function( _id )
{
	return _id != null && (typeof _id == "string" || typeof _id == "integer");
};

::$bvvar{namespace}.getValkyrieAttackDefenseClaim <- function( _attemptID, _targetID )
{
	if (!this.isValidValkyrieAttackDefenseClaimID(_attemptID) || !this.isValidValkyrieAttackDefenseClaimID(_targetID))
	{
		return null;
	}

	local claims = this.ValkyrieAttackDefenseClaims;
	if (!(_attemptID in claims) || !(_targetID in claims[_attemptID]))
	{
		return null;
	}

	return claims[_attemptID][_targetID];
};

::$bvvar{namespace}.reserveValkyrieAttackDefenseClaim <- function( _attemptID, _targetID, _policy )
{
	if (!this.isValidValkyrieAttackDefenseClaimID(_attemptID) || !this.isValidValkyrieAttackDefenseClaimID(_targetID) || _policy == null)
	{
		return null;
	}

	local existing = this.getValkyrieAttackDefenseClaim(_attemptID, _targetID);
	if (existing != null)
	{
		return existing;
	}

	local claims = this.ValkyrieAttackDefenseClaims;
	if (!(_attemptID in claims))
	{
		claims[_attemptID] <- {};
	}

	local consumers = [];
	if ("Consumers" in _policy && typeof _policy.Consumers == "array")
	{
		foreach (consumer in _policy.Consumers)
		{
			consumers.push(consumer);
		}
	}

	local claim = {
		AttemptID = _attemptID,
		TargetID = _targetID,
		IgnoreActualShield = _policy.IgnoreActualShield,
		HitChanceBonus = _policy.HitChanceBonus,
		Consumers = consumers,
		Consumed = false
	};
	claims[_attemptID][_targetID] <- claim;
	return claim;
};

::$bvvar{namespace}.consumeValkyrieAttackDefenseClaim <- function( _attemptID, _targetID, _context = null )
{
	local claim = this.getValkyrieAttackDefenseClaim(_attemptID, _targetID);
	if (claim == null || claim.Consumed)
	{
		return false;
	}

	claim.Consumed = true;
	local consumers = claim.Consumers;
	claim.Consumers = [];
	foreach (consumer in consumers)
	{
		try
		{
			local provider = this.readValkyrieAttackDefenseProviderRef(consumer.ProviderRef);
			if (!this.isLiveValkyrieAttackDefenseProvider(provider))
			{
				continue;
			}
			provider.consumeValkyrieAttackDefensePolicy(consumer.ConsumeToken, _context);
		}
		catch (e)
		{
		}
	}

	return true;
};

::$bvvar{namespace}.clearValkyrieAttackDefenseClaimConsumers <- function( _claim )
{
	if (_claim != null)
	{
		_claim.Consumers = [];
	}
};

::$bvvar{namespace}.releaseValkyrieAttackDefenseClaim <- function( _attemptID, _targetID )
{
	local claim = this.getValkyrieAttackDefenseClaim(_attemptID, _targetID);
	if (claim == null)
	{
		return false;
	}

	this.clearValkyrieAttackDefenseClaimConsumers(claim);
	local claims = this.ValkyrieAttackDefenseClaims;
	delete claims[_attemptID][_targetID];
	if (claims[_attemptID].len() == 0)
	{
		delete claims[_attemptID];
	}
	return true;
};

::$bvvar{namespace}.releaseValkyrieAttackDefenseClaimsForAttempt <- function( _attemptID )
{
	if (!this.isValidValkyrieAttackDefenseClaimID(_attemptID) || !(_attemptID in this.ValkyrieAttackDefenseClaims))
	{
		return false;
	}

	local bucket = this.ValkyrieAttackDefenseClaims[_attemptID];
	foreach (claim in bucket)
	{
		this.clearValkyrieAttackDefenseClaimConsumers(claim);
	}
	delete this.ValkyrieAttackDefenseClaims[_attemptID];
	return true;
};

::$bvvar{namespace}.retargetValkyrieAttackDefenseClaim <- function( _attemptID, _fromTargetID, _toTargetID )
{
	if (!this.isValidValkyrieAttackDefenseClaimID(_attemptID)
		|| !this.isValidValkyrieAttackDefenseClaimID(_fromTargetID)
		|| !this.isValidValkyrieAttackDefenseClaimID(_toTargetID))
	{
		return false;
	}

	local claim = this.getValkyrieAttackDefenseClaim(_attemptID, _fromTargetID);
	if (claim == null)
	{
		return false;
	}
	if (_fromTargetID == _toTargetID)
	{
		return true;
	}
	if (this.getValkyrieAttackDefenseClaim(_attemptID, _toTargetID) != null)
	{
		return false;
	}

	local bucket = this.ValkyrieAttackDefenseClaims[_attemptID];
	delete bucket[_fromTargetID];
	claim.TargetID = _toTargetID;
	bucket[_toTargetID] <- claim;
	return true;
};

::$bvvar{namespace}.resetValkyrieAttackDefenseClaims <- function()
{
	foreach (bucket in this.ValkyrieAttackDefenseClaims)
	{
		foreach (claim in bucket)
		{
			this.clearValkyrieAttackDefenseClaimConsumers(claim);
		}
	}
	this.ValkyrieAttackDefenseClaims = {};
};

::$bvvar{namespace}.calculateValkyrieShieldDefenseContribution <- function( _hasUsableShield, _rawMeleeDefense, _rawRangedDefense, _isRanged, _isSpecialized, _hasShieldwall, _hasProficiency, _adjacentCount, _adjacentMax )
{
	if (_hasUsableShield != true)
	{
		return 0;
	}

	local raw = _isRanged == true ? _rawRangedDefense : _rawMeleeDefense;
	if (typeof raw != "integer" && typeof raw != "float")
	{
		raw = 0;
	}
	raw = this.Math.max(0, raw);
	local baseContribution = this.Math.floor(raw * (_isSpecialized == true ? 1.25 : 1.0));
	local contribution = baseContribution;

	if (_hasShieldwall == true)
	{
		contribution += baseContribution;
		if (_hasProficiency == true)
		{
			contribution += 5;
		}

		local count = typeof _adjacentCount == "integer" || typeof _adjacentCount == "float" ? this.Math.max(0, this.Math.floor(_adjacentCount)) : 0;
		local maximum = typeof _adjacentMax == "integer" || typeof _adjacentMax == "float" ? this.Math.max(0, this.Math.floor(_adjacentMax)) : 0;
		contribution += this.Math.min(count, maximum) * 5;
	}

	return contribution;
};
