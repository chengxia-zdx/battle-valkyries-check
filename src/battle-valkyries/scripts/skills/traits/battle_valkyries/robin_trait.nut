this.robin_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = { ValkyrieID = "robin" },

	function create()
	{
		this.character_trait.create();
		::$bvvar{namespace}.setupValkyrieTrait(this, this.m.ValkyrieID);
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += 3;
		_properties.Bravery += 20;
		_properties.Initiative += 15;
		_properties.RangedDefense += 15;
		_properties.FatigueRecoveryRateMult *= 1.5;

		foreach (i, value in _properties.MoraleCheckBraveryMult)
		{
			_properties.MoraleCheckBraveryMult[i] *= 1000.0;
		}
	}
});
