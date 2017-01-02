_sel  = get3DENSelected "object";
_cntr = getPos (get3DENSelected "trigger" select 0);

_tile = [];
{
  _className = typeOf _x;

  _tb = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxbackpacks");
  _tm = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxmagazines");
  _tw = getNumber (configFile >> "CfgVehicles" >> _className >> "transportmaxweapons");
  _hasInventory = if (_tb > 0  || _tm > 0 || _tw > 0) then {true;} else {false;};

  _isVehicle = _x isKindOf "AllVehicles";

  _tile pushBack [
    ["type", _className],
    ["pos", [(getPos _x select 0) - (_cntr select 0), (getPos _x select 1) - (_cntr select 1)]],
    ["dir", getDir _x],
    ["height", getPos _x select 2],
    ["hasInventory", _hasInventory],
    ["isVehicle", _isVehicle]
  ];
} forEach _sel;

copyToClipboard str _tile;
