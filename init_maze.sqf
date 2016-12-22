if (isServer) then {
    

WIDTH = "maze_size_width" call BIS_fnc_getParamValue;
if (WIDTH == 0) then { WIDTH = 20; };
HEIGHT = "maze_size_height" call BIS_fnc_getParamValue;
if (HEIGHT == 0) then { HEIGHT = 20; };

// Get maze pos info
mazePosCenter = getPosASL maze;


// Get wall info
wallModel = (getModelInfo ref_wall) select 1;
wallBB = boundingBox ref_wall;
wallBBX = (wallBB select 1 select 0) - (wallBB select 0 select 0);
wallBBY = (wallBB select 1 select 1) - (wallBB select 0 select 1);
wallLength = wallBBX max wallBBY;
isRot = false;
if (wallLength == wallBBX) then {
    isRot = true;
};
wallLength = wallLength - (0.22 * wallLength);
wallLength = (round (wallLength * 100)) / 100;

// Get maze corner position
mazePos = [
    (mazePosCenter select 0) - (WIDTH * wallLength) / 2,
    (mazePosCenter select 1) - (HEIGHT * wallLength) / 2,
    mazePosCenter select 2
];


// mark all cells as unvisited
visited = [];
for "_x" from 0 to WIDTH - 1 do {
    visited = visited + [[]];
    for "_y" from 0 to HEIGHT - 1 do {
        (visited select _x) pushBack false;
    };
};


// generate walls array, where walls[x][y][side] is a bool that tells if there's a wall on that side.
// [x][y][0] is right, [x][y][1] is up
walls = [];
for "_x" from 0 to WIDTH - 1 do {
    walls = walls + [[]];
    for "_y" from 0 to HEIGHT - 1 do {
        (walls select _x) pushBack [true, true];
    };
};


// remove wall between two cells
remove_wall = {
    params ["_c1", "_c2"];

    wallCell = _c1;
    if (((_c2 select 0) + (_c2 select 1)) < ((_c1 select 0) + (_c1 select 1))) then {
        wallCell = _c2;
    };

    _wcx = wallCell select 0;
    _wcy = wallCell select 1;

    if ((_c1 select 1) == (_c2 select 1)) then {
        ((walls select _wcx) select _wcy) set [0, false];
    } else {
        ((walls select _wcx) select _wcy) set [1, false];
    };
};


// set first cell as cur_cell, init backtrack
curCell = [round (WIDTH / 2), round (HEIGHT / 2)];
backtrack = [ [curCell, []] ];


// main loop
_safeguard = 0;
while { count backtrack > 0 and _safeguard < 9999 } do {
    _safeguard = _safeguard + 1;

    curX = curCell select 0;
    curY = curCell select 1;

    // set current cell as visited
    (visited select curX) set [curY, true];

    neighbors = [];
    // left
    if (curX > 0) then {
        if (not (visited select curX - 1 select curY)) then {
            neighbors pushBack [curX - 1, curY];
        };
    };
    // right
    if (curX < WIDTH - 1) then {
        if (not (visited select curX + 1 select curY)) then {
            neighbors pushBack [curX + 1, curY];
        };
    };
    // down
    if (curY > 0) then {
        if (not (visited select curX select curY - 1)) then {
            neighbors pushBack [curX, curY - 1];
        };
    };
    // up
    if (curY < HEIGHT - 1) then {
        if (not (visited select curX select curY + 1)) then {
            neighbors pushBack [curX, curY + 1];
        };
    };


    if (count neighbors > 0) then {
        // pick neighbor to move to next
        nextCell = neighbors call BIS_fnc_selectRandom;

        // remove wall between curCell and nextCell
        [curCell, nextCell] call remove_wall;

        // remove next cell from neighbors and add the rest to backtrack
        neighbors = neighbors - [nextCell];
        for "_n" from 0 to count neighbors - 1 do {
            backtrack pushBack [neighbors select _n, curCell];
        };

        // move to next cell
        curCell = nextCell;
    } else {
        // backtrack!
        backtrackTo = backtrack select (count backtrack - 1);
        while { ((visited select ((backtrackTo select 0) select 0)) select ((backtrackTo select 0) select 1)) and count backtrack > 1 } do {
            backtrack = backtrack - [backtrackTo];
            backtrackTo = backtrack select (count backtrack - 1);
        };

        backtrack = backtrack - [backtrackTo];
        curCell = backtrackTo select 0;
        if (count (backtrackTo select 1) > 0) then {
            // remove wall between backtracked cell and its 'parent' cell
            [curCell, backtrackTo select 1] call remove_wall;
        };
    };
};



// Load spawn tower models (and fixed rotations)
_spawnTowerModel = (getModelInfo ref_spawn_tower) select 1;
_spawnTowerRots = [270, 270, 90, 90];
_spawnTowers = [];
_towerNum = 0;


// Load center nuke models
_nukeDomeModel = (getModelInfo ref_nuke_dome) select 1; _nukeDomeModel_hh = ((boundingBox ref_nuke_dome) select 1 select 2) - 5;
_nukeTowerModel = (getModelInfo ref_nuke_tower) select 1; _nukeTowerModel_hh = ((boundingBox ref_nuke_tower) select 1 select 2) + 10;


// Spawn maze
for "_x" from 0 to WIDTH - 1 do {
    for "_y" from 0 to HEIGHT - 1 do {

        cellCenter = [
            (mazePos select 0) + _x * wallLength + wallLength / 2,
            (mazePos select 1) + _y * wallLength + wallLength / 2,
            mazePos select 2
        ];


        _inCenter = not (_x < WIDTH/2-2 or _x > WIDTH/2+1 or _y < HEIGHT/2-2 or _y > HEIGHT/2+1);
        _inCorner = (_x == 0 and _y == 0) or (_x == 0 and _y == HEIGHT-1) or (_x == WIDTH-1 and _y == 0) or (_x == WIDTH-1 and _y == HEIGHT-1);
        _isEdge = (_x == 0 or _x == WIDTH-1 or _y == 0 or _y == HEIGHT-1);


        /*
         * WALLS
         */

        // Skip spawning walls in the center, and skip spawning 10% of walls
        if ((not _inCenter) and (_isEdge or random 100 > 10)) then {
            _rotOffset = 0;
            if (isRot) then {
                _rotOffset = 90;
            };

            // Create right wall
            if (((walls select _x) select _y) select 0) then {
                _wallPos = ATLToASL [
                    (cellCenter select 0) + wallLength / 2,
                    cellCenter select 1,
                    0
                ];
                (createSimpleObject [wallModel, _wallPos]) setDir _rotOffset;
            };

            // create top wall
            if (((walls select _x) select _y) select 1) then {
                _wallPos = ATLToASL [
                    cellCenter select 0,
                    (cellCenter select 1) + wallLength / 2,
                    0
                ];
                (createSimpleObject [wallModel, _wallPos]) setDir (90 + _rotOffset);
            };
            

            // If we're on the first X column, create left wall
            if (_x == 0) then {
                _wallPos = ATLToASL [
                    (cellCenter select 0) - wallLength / 2,
                    cellCenter select 1,
                    0
                ];
                (createSimpleObject [wallModel, _wallPos]) setDir _rotOffset;
            };

            // If we're on the first Y row, create bottom wall
            if (_y == 0) then {
                _wallPos = ATLToASL [
                    cellCenter select 0,
                    (cellCenter select 1) - wallLength / 2,
                    0
                ];
                (createSimpleObject [wallModel, _wallPos]) setDir (90 + _rotOffset);
            };
        };


        /*
         * SPAWN TOWERS
         */
        if (_inCorner) then {
            _pos = ATLToASL [
                cellCenter select 0,
                cellCenter select 1,
                10
            ];
            _spawnTower = createSimpleObject [_spawnTowerModel, _pos];
            _spawnTower setDir (_spawnTowerRots select _towerNum);
            _spawnTowers pushBack _spawnTower;
            _towerNum = _towerNum + 1;
        };

    };
};


// Spawn nuke stuff in center
_pos = [
    mazePosCenter select 0,
    mazePosCenter select 1
];
defuse_trigger setPos _pos;
createVehicle ["Land_Device_assembled_F", _pos, [], 0, "NONE"];

(createVehicle ["Land_Dome_Big_F", _pos, [], 0, "NONE"]) setDir 90;

_pos = ATLToASL [
    mazePosCenter select 0,
    mazePosCenter select 1,
    _nukeDomeModel_hh + _nukeTowerModel_hh
];
createSimpleObject [_nukeTowerModel, _pos];



/*
 * Create random tiles
 */
tileScript = [WIDTH, HEIGHT, mazePos, wallLength] execVM "init_tiles.sqf";
waitUntil { scriptDone tileScript };


/*
 * Initialize players and move them to their starting positions
 */
_leads = [];
if (not isNil "team1_lead") then { _leads pushBack team1_lead; };
if (not isNil "team2_lead") then { _leads pushBack team2_lead; };
if (not isNil "team3_lead") then { _leads pushBack team3_lead; };
if (not isNil "team4_lead") then { _leads pushBack team4_lead; };
for "_g" from 0 to count _leads - 1 do {
    _towerPos = getPos (_spawnTowers select _g);

    // Spawn a radio crate just in case something screws up
    _crate = createVehicle ["TF_NATO_Radio_Crate", [_towerPos select 0, _towerPos select 1], [], 0, "NONE"];

    _group = units group (_leads select _g);
    for "_u" from 0 to count _group - 1 do {
        _unit = _group select _u;

        // move unit
        _unit setPos [
            (_towerPos select 0) + 1.5 * (cos (_u * 360 / (count _group))),
            (_towerPos select 1) + 1.5 * (sin (_u * 360 / (count _group)))
        ];
        _unit setDir -(_u * 360 / (count _group)) - 90;


        // Give loadout
        removeAllWeapons _unit;
        removeAllItems _unit;
        removeAllAssignedItems _unit;
        removeVest _unit;
        removeBackpack _unit;
        removeHeadgear _unit;
        removeGoggles _unit;

        _unit addBackpack "B_AssaultPack_cbr";
        for "_i" from 1 to 5 do {_unit addItemToBackpack "ACE_fieldDressing";};
        for "_i" from 1 to 5 do {_unit addItemToBackpack "ACE_morphine";};
        for "_i" from 1 to 8 do {_unit addItemToBackpack "hlc_30Rnd_762x39_t_ak";};
        for "_i" from 1 to 3 do {_unit addItemToBackpack "ACE_M14";};
        for "_i" from 1 to 3 do {_unit addItemToBackpack "rhs_mag_m67";};
        _unit addHeadgear "rhsusf_mich_bare_tan";

        _unit addWeapon "Binocular";

        _unit addWeapon "rhs_weap_akm";

        _unit linkItem "ItemMap";
        _unit linkItem "ItemCompass";
        _unit linkItem "ItemWatch";
        _unit linkItem "tf_anprc152";


        // disable ai on unit for testing
        // _unit disableAI "ANIM";
    };

    // Add "bomb code" (cell phone) to group lead
    (_leads select _g) addItemToUniform "ACE_Cellphone";
};


/*
 * Create maze markers
 */
_nukeMarker = createMarker ["nuke", mazePosCenter];
_nukeMarker setMarkerShape "ICON";
_nukeMarker setMarkerType "mil_objective";
_nukeMarker setMarkerColor "ColorRed";

_mazeArea = createMarker ["maze", mazePosCenter];
_mazeArea setMarkerShape "RECTANGLE";
_mazeArea setMarkerSize [WIDTH * wallLength / 2, HEIGHT * wallLength / 2];
_mazeArea setMarkerColor "ColorBlack";
_mazeArea setMarkerBrush "Grid";


// Clean up misc spawn area stuff
{
    deleteVehicle _x;
} forEach nearestObjects [cleanup, [], 200];


};
