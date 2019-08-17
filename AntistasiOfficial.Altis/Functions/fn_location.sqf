params ["_name", "_getClass"];

private _return = "";

private _value = "getText (_x >> ""name"") == _name"
configClasses (configFile >> "CfgWorlds" >> worldName >> "Names");

if (_getClass) then {
	_return = configName (_value select 0);
};

if (!_getClass) then {
	_return = getText ((_value select 0) >> "name");
};

_return
