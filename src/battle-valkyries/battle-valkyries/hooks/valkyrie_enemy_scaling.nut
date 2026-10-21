::$bvvar{namespace}.ValkyrieEnemyScaling <- {
	MaxTrackedValkyries = 12,
	ThreatPerLevel = 0.05,
	ThreatLevelCap = 10,
	ThreatCap = 12.0,
	StrengthMult = 1.50,
	MinibossStrengthMult = 1.00,
	BudgetPerThreat = 0.10,
	ContractBudgetWeight = 1.0,
	RoamerBudgetWeight = 0.75,
	LocationBudgetWeight = 0.60,
	ContractBudgetCap = 3.00,
	RoamerBudgetCap = 2.50,
	LocationBudgetCap = 2.20,
	ContractMinibossPerThreat = 2.5,
	WorldMinibossPerThreat = 1.6666667,
	ContractMinibossCap = 30,
	WorldMinibossCap = 20
};

::$bvvar{namespace}.isValkyrieEnemyScalingEnabled <- function()
{
	return ::$bvvar{namespace}.getSettingValue("EnableValkyrieEnemyScaling") == true;
};

::$bvvar{namespace}.getValkyrieEnemyBudgetRamp <- function()
{
	if (::World == null)
	{
		return 1.0;
	}

	local days = ::World.getTime().Days;
	return ::Math.maxf(0.0, ::Math.minf(1.0, days * 1.0 / 30.0));
};

::$bvvar{namespace}.getValkyrieEnemyMinibossRamp <- function()
{
	if (::World == null)
	{
		return 1.0;
	}

	local days = ::World.getTime().Days;

	return days < 30 ? 0.0 : 1.0;
};

::$bvvar{namespace}.getValkyrieEnemyLevelThreat <- function()
{
	if (!::$bvvar{namespace}.isValkyrieEnemyScalingEnabled() || ::World == null)
	{
		return 0.0;
	}

	local roster = ::World.getPlayerRoster();

	if (roster == null)
	{
		return 0.0;
	}

	local levels = [];

	foreach( bro in roster.getAll() )
	{
		if (!::$bvvar{namespace}.isActorValkyrie(bro) || ("isAlive" in bro && !bro.isAlive()))
		{
			continue;
		}

		levels.push(bro.getLevel());
	}

	if (levels.len() == 0)
	{
		return 0.0;
	}

	levels.sort(function( _a, _b )
	{
		if (_a > _b)
		{
			return -1;
		}
		else if (_a < _b)
		{
			return 1;
		}

		return 0;
	});

	local config = ::$bvvar{namespace}.ValkyrieEnemyScaling;
	local threat = 0.0;
	local count = 0;

	foreach( level in levels )
	{
		if (count >= config.MaxTrackedValkyries)
		{
			break;
		}

		threat += 1.0 + ::Math.min(config.ThreatLevelCap, ::Math.max(0, level - 1)) * config.ThreatPerLevel;
		count = ++count;
	}

	return ::Math.minf(config.ThreatCap, threat);
};

::$bvvar{namespace}.getValkyrieEnemyBudgetThreat <- function()
{
	return ::$bvvar{namespace}.getValkyrieEnemyLevelThreat();
};

::$bvvar{namespace}.getValkyrieEnemyMinibossThreat <- function()
{
	return ::$bvvar{namespace}.getValkyrieEnemyLevelThreat();
};

::$bvvar{namespace}.getValkyrieEnemyThreat <- function()
{
	return ::$bvvar{namespace}.getValkyrieEnemyBudgetThreat();
};

::$bvvar{namespace}.getValkyrieEnemyBudgetMult <- function( _mode )
{
	local config = ::$bvvar{namespace}.ValkyrieEnemyScaling;
	local threat = ::$bvvar{namespace}.getValkyrieEnemyBudgetThreat();

	if (threat <= 0.0)
	{
		return 1.0;
	}

	local weight = config.RoamerBudgetWeight;
	local cap = config.RoamerBudgetCap;

	if (_mode == "contract")
	{
		weight = config.ContractBudgetWeight;
		cap = config.ContractBudgetCap;
	}
	else if (_mode == "location")
	{
		weight = config.LocationBudgetWeight;
		cap = config.LocationBudgetCap;
	}

	local extra = threat * config.BudgetPerThreat * weight * config.StrengthMult * ::$bvvar{namespace}.getValkyrieEnemyBudgetRamp();
	return ::Math.minf(cap, 1.0 + extra);
};

::$bvvar{namespace}.getValkyrieEnemyMinibossBonus <- function( _mode )
{
	local config = ::$bvvar{namespace}.ValkyrieEnemyScaling;
	local threat = ::$bvvar{namespace}.getValkyrieEnemyMinibossThreat();

	if (threat <= 0.0)
	{
		return 0;
	}

	local perThreat = config.WorldMinibossPerThreat;
	local cap = config.WorldMinibossCap;

	if (_mode == "contract")
	{
		perThreat = config.ContractMinibossPerThreat;
		cap = config.ContractMinibossCap;
	}

	local bonus = ::Math.round(threat * perThreat * config.MinibossStrengthMult * ::$bvvar{namespace}.getValkyrieEnemyMinibossRamp());
	return ::Math.min(cap, ::Math.max(0, bonus));
};

::$bvvar{namespace}.shouldScaleValkyrieEnemyFaction <- function( _faction )
{
	if (_faction == null)
	{
		return false;
	}

	try
	{
		if (_faction.isAlliedWithPlayer())
		{
			return false;
		}
	}
	catch (e)
	{
		return false;
	}

	return true;
};

// Generation adapters are registered after Legends in hooks/enemy_expansion_spawn.nut.
// Difficulty getters no longer multiply supported budgets before troop selection.
