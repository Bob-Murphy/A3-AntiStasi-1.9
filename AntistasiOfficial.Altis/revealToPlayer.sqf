if (isDedicated) exitWith {};
private ["_LeaderX"];
if (count _this == 0) then
	{
	while {revealX} do
		{
		if (player == leader group player) then
			{
			if ([player] call hasRadio) then
				{
				{
				_LeaderX = leader _x;
				if (((side _LeaderX == side_red) or (side _LeaderX == side_green)) and (vehicle _LeaderX != _LeaderX) and (player knowsAbout _LeaderX < 1.5)) then
					{
					player reveal [_LeaderX,4];
					sleep 1;
					};
				} forEach allGroups;
				};
			};
		sleep 10;
		};
	}
else
	{
	private ["_grupo"];
	if (player == leader group player) then
		{
		_grupo = _this select 0;
		_LeaderX = leader _grupo;
		player reveal [_LeaderX,4];
		};
	};