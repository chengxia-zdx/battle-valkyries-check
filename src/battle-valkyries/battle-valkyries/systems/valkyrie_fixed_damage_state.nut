// Pure fixed-damage marker validation and normalization.  This file must stay
// package-neutral and free of Battle Brothers globals so repository fixtures
// exercise the same rules used by both rendered packages.

local getValue = function( _table, _key, _fallback )
{
	return _table != null && typeof _table == "table" && _key in _table ? _table[_key] : _fallback;
};

local isNumber = function( _value )
{
	local valueType = typeof _value;
	return valueType == "integer" || valueType == "float";
};

local createMarker = function( _spec )
{
	if (_spec == null || typeof _spec != "table")
	{
		return null;
	}
	local actorID = getValue(_spec, "ActorID", getValue(_spec, "OwnerID", null));
	return {
		MarkerToken = getValue(_spec, "MarkerToken", null),
		FrameToken = getValue(_spec, "FrameToken", null),
		Mode = getValue(_spec, "Mode", null),
		Amount = getValue(_spec, "Amount", 0),
		BodyPart = getValue(_spec, "BodyPart", null),
		ActorID = actorID,
		OwnerID = actorID,
		TargetID = getValue(_spec, "TargetID", null),
		SkillID = getValue(_spec, "SkillID", null),
		ActionToken = getValue(_spec, "ActionToken", null),
		AttemptToken = getValue(_spec, "AttemptToken", null),
		Source = getValue(_spec, "Source", "fixed")
	};
};

local isTrustedMarker = function( _marker, _markerToken, _frameToken, _ownerID, _targetID, _skillID )
{
	return typeof _markerToken == "table" && typeof _frameToken == "string" && _frameToken.len() > 0
		&& _ownerID != null && _targetID != null && _skillID != null
		&& _marker != null && typeof _marker == "table"
		&& "MarkerToken" in _marker && _marker.MarkerToken == _markerToken
		&& "FrameToken" in _marker && _marker.FrameToken == _frameToken
		&& "ActorID" in _marker && _marker.ActorID != null && _marker.ActorID == _ownerID
		&& "OwnerID" in _marker && _marker.OwnerID == _ownerID
		&& "TargetID" in _marker && _marker.TargetID != null && _marker.TargetID == _targetID
		&& "SkillID" in _marker && _marker.SkillID != null && _marker.SkillID == _skillID
		&& "Mode" in _marker && (_marker.Mode == "hitpoints" || _marker.Mode == "armor")
		&& "Amount" in _marker && isNumber(_marker.Amount) && _marker.Amount > 0;
};

local normalizeFixedDamage = function( _marker, _hitInfo, _properties )
{
	if (_marker == null || typeof _marker != "table" || _hitInfo == null || typeof _hitInfo != "table"
		|| _properties == null || typeof _properties != "table" || !("Mode" in _marker)
		|| !("Amount" in _marker) || !isNumber(_marker.Amount) || _marker.Amount <= 0)
	{
		return false;
	}

	foreach (field in [
		"DamageRegular", "DamageArmor", "DamageDirect", "DamageMinimum", "DamageFatigue",
		"BodyPart", "BodyDamageMult", "FatalityChanceMult", "Injuries", "InjuryThresholdMult",
		"DamageInflictedHitpoints", "DamageInflictedArmor"
	])
	{
		if (!(field in _hitInfo)) return false;
	}
	foreach (field in [
		"DamageReceivedTotalMult", "DamageReceivedMeleeMult", "DamageReceivedRangedMult",
		"DamageReceivedRegularMult", "DamageReceivedArmorMult", "DamageReceivedDirectMult",
		"DamageRegularReduction", "DamageArmorReduction"
	])
	{
		if (!(field in _properties)) return false;
	}

	local amount = _marker.Amount;
	local bodyPart = "BodyPart" in _marker ? _marker.BodyPart : null;
	local direct = 1.0;
	if (bodyPart != null && (typeof bodyPart != "integer" || bodyPart < 0 || bodyPart > 1)) return false;
	if (_marker.Mode == "armor")
	{
		if (typeof bodyPart != "integer" || bodyPart < 0
			|| !("Armor" in _properties) || typeof _properties.Armor != "array"
			|| !("ArmorMult" in _properties) || typeof _properties.ArmorMult != "array"
			|| bodyPart >= _properties.Armor.len() || bodyPart >= _properties.ArmorMult.len()
			|| !isNumber(_properties.Armor[bodyPart]) || !isNumber(_properties.ArmorMult[bodyPart]))
		{
			return false;
		}
		local effectiveArmorFloat = _properties.Armor[bodyPart] * _properties.ArmorMult[bodyPart];
		if (effectiveArmorFloat < 0) effectiveArmorFloat = 0;
		local effectiveArmor = effectiveArmorFloat.tointeger();
		amount = amount < effectiveArmor ? amount : effectiveArmor;
		if (amount <= 0) return false;
		direct = 0.0;
	}
	else if (_marker.Mode == "hitpoints")
	{
	}
	else
	{
		return false;
	}

	_hitInfo.DamageRegular = _marker.Mode == "hitpoints" ? amount : 0;
	_hitInfo.DamageArmor = _marker.Mode == "armor" ? amount : 0;
	_hitInfo.DamageDirect = direct;
	if (bodyPart != null) _hitInfo.BodyPart = bodyPart;
	_hitInfo.DamageMinimum = 0;
	_hitInfo.DamageFatigue = 0;
	_hitInfo.BodyDamageMult = 1.0;
	_hitInfo.FatalityChanceMult = 0.0;
	_hitInfo.Injuries = null;
	_hitInfo.InjuryThresholdMult = 0.0;
	_hitInfo.DamageInflictedHitpoints = 0;
	_hitInfo.DamageInflictedArmor = 0;
	_properties.DamageReceivedTotalMult = 1.0;
	_properties.DamageReceivedMeleeMult = 1.0;
	_properties.DamageReceivedRangedMult = 1.0;
	_properties.DamageReceivedRegularMult = 1.0;
	_properties.DamageReceivedArmorMult = 1.0;
	_properties.DamageReceivedDirectMult = 1.0;
	_properties.DamageRegularReduction = 0;
	_properties.DamageArmorReduction = 0;
	return true;
};

local module = {
	createValkyrieFixedDamageMarker = createMarker,
	isTrustedValkyrieFixedDamageMarker = isTrustedMarker,
	normalizeValkyrieFixedDamage = normalizeFixedDamage
};

::BattleValkyriesFixedDamageState <- module;
return module;
