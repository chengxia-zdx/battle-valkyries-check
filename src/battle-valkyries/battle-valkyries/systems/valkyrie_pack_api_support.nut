::$bvvar{namespace}.deepCopyValkyriePackValue <- function( _value )
{
	local valueType = typeof _value;
	if (valueType == "table")
	{
		local ret = {};
		foreach( key, value in _value ) ret[key] <- ::$bvvar{namespace}.deepCopyValkyriePackValue(value);
		return ret;
	}
	if (valueType == "array")
	{
		local ret = [];
		foreach( value in _value ) ret.push(::$bvvar{namespace}.deepCopyValkyriePackValue(value));
		return ret;
	}
	return _value;
};

::$bvvar{namespace}.failValkyriePackRegistration <- function( _packID, _path, _reason )
{
	local packText = _packID == null ? "<unknown>" : _packID.tostring();
	local message = "[Battle Valkyries] [PackAPI] pack=" + packText + " path=" + _path + " error=" + _reason;
	::logError(message);
	throw message;
};

::$bvvar{namespace}.isValidValkyriePackID <- function( _value )
{
	if (typeof _value != "string" || _value.len() == 0) return false;
	for (local i = 0; i < _value.len(); i = ++i)
	{
		local c = _value.slice(i, i + 1);
		local isLower = c >= "a" && c <= "z";
		local isDigit = c >= "0" && c <= "9";
		if ((!isLower && !isDigit && c != "_") || (i == 0 && !isLower)) return false;
	}
	return true;
};

::$bvvar{namespace}.isValidValkyriePackVersion <- function( _value )
{
	if (typeof _value != "string") return false;
	local parts = split(_value, ".");
	if (parts.len() != 3) return false;
	foreach( part in parts )
	{
		if (part.len() == 0) return false;
		foreach( c in part ) if (c < '0' || c > '9') return false;
	}
	return true;
};

::$bvvar{namespace}.requireValkyriePackField <- function( _table, _field, _type, _packID, _path )
{
	if (typeof _table != "table" || !(_field in _table))
		::$bvvar{namespace}.failValkyriePackRegistration(_packID, _path, "field is required");
	local value = _table[_field];
	if (typeof value != _type)
		::$bvvar{namespace}.failValkyriePackRegistration(_packID, _path, "expected " + _type + ", got " + typeof value);
	return value;
};

::$bvvar{namespace}.requireValkyriePackString <- function( _table, _field, _packID, _path )
{
	local value = ::$bvvar{namespace}.requireValkyriePackField(_table, _field, "string", _packID, _path);
	if (value.len() == 0) ::$bvvar{namespace}.failValkyriePackRegistration(_packID, _path, "must not be empty");
	return value;
};

::$bvvar{namespace}.requireValkyriePackArray <- function( _table, _field, _packID, _path )
{
	return ::$bvvar{namespace}.requireValkyriePackField(_table, _field, "array", _packID, _path);
};

::$bvvar{namespace}.requireValkyriePackTable <- function( _table, _field, _packID, _path )
{
	return ::$bvvar{namespace}.requireValkyriePackField(_table, _field, "table", _packID, _path);
};

::$bvvar{namespace}.requireValkyriePackQualifiedID <- function( _packID, _value, _path )
{
	if (typeof _value != "string" || _value.len() <= _packID.len() + 1 || _value.find(_packID + ".") != 0)
		::$bvvar{namespace}.failValkyriePackRegistration(_packID, _path, "must start with " + _packID + ".");
	return _value;
};
