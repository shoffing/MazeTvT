_sel = get3DENSelected "object"; 
_crate = [];
{
  _crate pushBack [
    ["weapons", weaponCargo _x],
    ["magazines", magazineCargo _x],
    ["items", itemCargo _x]
  ];
} forEach _sel;

copyToClipboard str (_crate select 0);
