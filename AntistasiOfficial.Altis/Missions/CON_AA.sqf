if (!isServer and hasInterface) exitWith {};

_tskTitle = "STR_TSK_TD_CONOPAA";
_tskDesc = "STR_TSK_TD_DESC_CONOPAA";

private ["_marcador"];

_marcador = _this select 0;
_source = _this select 1;

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val + 1, true];
};

_posicion = getMarkerPos _marcador;
_tiempolim = 90;//120
_fechalim = [date select 0, date select 1, date select 2, date select 3, (date select 4) + _tiempolim];
_dateLimitNum = dateToNumber _fechalim;

_nombredest = [_marcador] call AS_fnc_localizar;

_tsk = ["CON",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],_tskTitle,_marcador],_posicion,"CREATED",5,true,true,"Target"] call BIS_fnc_setTask;
misiones pushBack _tsk; publicVariable "misiones";

waitUntil {sleep 1; ((dateToNumber date > _dateLimitNum) or (not(_marcador in mrkAAF)))};

if (dateToNumber date > _dateLimitNum) then
	{
	_tsk = ["CON",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],_tskTitle,_marcador],_posicion,"FAILED",5,true,true,"Target"] call BIS_fnc_setTask;
	[5,0,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[-600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	[-10,Slowhand] call playerScoreAdd;
	};

if (not(_marcador in mrkAAF)) then
	{
	sleep 10;
	_tsk = ["CON",[side_blue,civilian],[[_tskDesc,_nombredest,numberToDate [2035,_dateLimitNum] select 3,numberToDate [2035,_dateLimitNum] select 4],_tskTitle,_marcador],_posicion,"SUCCEEDED",5,true,true,"Target"] call BIS_fnc_setTask;
	[0,200] remoteExec ["resourcesFIA",2];
	[-5,0,_posicion] remoteExec ["AS_fnc_changeCitySupport",2];
	[600] remoteExec ["AS_fnc_increaseAttackTimer",2];
	{if (isPlayer _x) then {[10,_x] call playerScoreAdd}} forEach ([500,0,_posicion,"BLUFORSpawn"] call distanceUnits);
	[10,Slowhand] call playerScoreAdd;
	// BE module
	if (activeBE) then {
		["mis"] remoteExec ["fnc_BE_XP", 2];
	};
	// BE module
	};

if (_source == "mil") then {
	_val = server getVariable "milActive";
	server setVariable ["milActive", _val - 1, true];
};

[1200,_tsk] spawn deleteTaskX;