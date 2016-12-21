if (isServer) then {
    

WIDTH = 20;
HEIGHT = 20;

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


// Set up tile configurations
// [class name, position, dir, height]
_tile_bunkers1 = [["Land_BagBunker_Tower_F",[1.235,0],180,0.00273132]];
_tile_bunkers2 = [["Land_BagBunker_Small_F",[6.35997,6.17167],269.971,0.0131073],["Land_BagBunker_Small_F",[-5.67158,-6.07964],89.9656,-0.00581551],["Land_BagFence_Long_F",[7.82079,2.66537],269.968,0.0355682],["Land_BagFence_Long_F",[-7.08323,-2.58733],269.966,0.0552616]];
_tile_bunkers3 = [["Land_Vez",[-4.02988,4.27694],0,0.101759],["Land_Fort_Watchtower_EP1",[3.25467,-2.76748],0,-0.0262547]];
_tile_sandbags1 = [["Land_BagFence_Round_F",[-5.24811,-5.20298],45.0003,-0.00117683],["Land_HBarrier1",[0.0238828,0.0266734],0,0.000982285],["Land_BagFence_Round_F",[5.21384,-5.24688],315.01,-0.0252075],["Land_BagFence_Round_F",[5.25953,5.22479],225.063,-0.00769806],["Land_BagFence_Round_F",[-5.20263,5.26793],134.976,0.0554276]];

_tile_market1 = [["CUP_str_fikovnik2",[4.32682,-4.7275],0,-0.00739288],["Land_transport_cart_EP1",[-5.23657,6.30148],119.995,0.00018692],["land_cwa_Crates",[-5.79063,4.35798],74.9755,0.000137329],["Land_Bag_EP1",[-4.2166,3.69144],74.9755,0.000444412],["Land_Bag_EP1",[-4.72671,4.42076],74.9755,0.000442505],["Land_transport_kiosk_EP1",[1.63307,6.6676],120.017,0.00113678],["Land_transport_kiosk_EP1",[3.8214,5.30724],120.017,0.00113678],["Land_transport_kiosk_EP1",[6.01303,3.94974],120.017,0.00113487],["Land_Basket_EP1",[2.1806,-4.97556],0,0.000694275],["Land_Basket_EP1",[1.19066,-4.44917],0,0.00204086],["Land_Basket_EP1",[1.19315,-5.51642],0,0.000291824],["Axe_woodblock",[3.61464,-3.54761],332.194,0.000917435]];

_tile_trees1 = [["CUP_str_fikovnik_ker",[-4.313,4.51741],0,-0.00181007],["CUP_les_fikovnik2",[5.39329,3.7467],0,-0.010128],["CUP_les_fikovnik2",[2.66388,-4.58161],0,-0.0134583],["CUP_Krovi_bigest",[-3.95181,-2.53485],0,-0.00878334],["CUP_Krovi_bigest",[0.392918,3.80547],0,-0.00479317]];
_tile_bushes1 = [["CUP_t_betula2w",[6.00543,-3.27165],0,0.019083],["CUP_b_craet2",[4.40262,6.77123],0,0.00669861],["CUP_b_prunus",[-7.84859,2.53687],0,-0.00745583],["CUP_Krovi_bigest",[-6.33834,-6.49728],0,-0.0121498],["CUP_Krovi_bigest",[-5.91894,-2.96387],0,-0.0142307],["CUP_Krovi_bigest",[-2.92248,-5.60201],0,-0.0144558],["CUP_t_betula2w",[-4.97399,4.62714],0,0.0170689],["CUP_t_betula2w",[1.92512,-5.69106],0,0.0121365],["CUP_Krovi_bigest",[3.45655,0.48703],0,-0.0172291]];
_tile_bushes2 = [["CUP_b_craet2",[4.29204,6.77123],0,0.00678062],["CUP_b_prunus",[-4.71611,3.54176],0,-0.0120068],["CUP_Krovi_bigest",[-6.34616,-6.48161],0,-0.0133991],["CUP_Krovi_bigest",[3.10787,2.09552],0,-0.0136585],["CUP_Krovi_bigest",[-2.94979,-5.60209],0,-0.0126877],["CUP_t_betula2w",[2.40351,-1.90365],0,0.00932312],["CUP_b_prunus",[-0.398853,4.2608],0,0.00523376]];
_tile_bushes3 = [["CUP_b_craet2",[4.27534,6.65209],0,-0.000217438],["CUP_b_prunus",[-5.41976,-1.00108],0,-0.00198746],["CUP_Krovi_bigest",[5.14206,-4.21218],0,-0.00322151],["CUP_b_prunus",[-3.51105,1.15154],0,-0.00186348],["CUP_b_craet2",[4.374,2.48852],0,0.00472832],["CUP_b_craet2",[-1.98647,6.15015],0,-0.00104332],["CUP_Krovi4",[-2.74944,-4.98592],345.005,0.0299282]];

_tile_hunting = [["Land_Misc_deerstand",[-4.14964,-2.11118],0,-0.00234795],["CUP_Krovi_bigest",[6.25929,-4.65934],0,0.00028038],["CUP_Krovi_bigest",[6.86691,-2.87219],0,-0.000291824],["CUP_Krovi_bigest",[5.04345,-3.3246],0,0.000427246],["CUP_Krovi_bigest",[-2.43671,-2.73821],0,0.000413895],["CUP_Krovi_long",[4.177,3.97334],14.9999,-0.0158005]];

_tile_playground = [["Land_SlideCastle_F",[4.28927,3.12995],0,0.00785637],["Land_Slide_F",[0.62537,-5.95745],0,0.00896072],["Land_kolotoc",[-3.50485,3.72185],0,0.000179291],["Land_kulata_prolezacka",[-5.11296,-2.75743],0,0.000213623]];

_tile_cars = [["Land_Wreck_Ural_F",[4.48832,-4.39943],210,-0.051918],["Land_Wreck_Car_F",[-4.83128,4.94314],44.992,0.0247993],["Land_Wreck_Van_F",[3.04457,4.50067],345.003,0.00282669],["Land_RailwayCar_01_tank_F",[-2.40852,-1.41266],194.814,0.000680923]];

_tiles = [
    _tile_bunkers1,
    _tile_bunkers1,

    _tile_bunkers2,
    _tile_bunkers2,

    _tile_bunkers3,
    _tile_bunkers3,

    _tile_sandbags1,
    _tile_sandbags1,
    _tile_sandbags1,
    _tile_sandbags1,
    _tile_sandbags1,
    _tile_sandbags1,

    _tile_market1,
    _tile_market1,

    _tile_trees1,
    _tile_trees1,
    _tile_trees1,

    _tile_bushes1,
    _tile_bushes1,

    _tile_bushes2,
    _tile_bushes2,

    _tile_bushes3,
    _tile_bushes3,

    _tile_hunting,
    _tile_hunting,

    _tile_playground,
    _tile_playground,
    _tile_playground,
    _tile_playground,

    _tile_cars,
    _tile_cars,
    _tile_cars
];


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


        /*
         * Create random tiles
         */
        if ((not _inCenter) and (not _inCorner)) then {
            if ((random 100) > 33) then {

                // Select random tile
                _tile = _tiles call BIS_fnc_selectRandom;
                _randRot = [0, 90, 180, 270] call BIS_fnc_selectRandom;

                for "_p" from 0 to count _tile - 1 do {
                    _prop = _tile select _p;
                    _propClass = _prop select 0;
                    _propPos = _prop select 1;
                    _propDir = _prop select 2;
                    _propHeight = _prop select 3;

                    _propPosRot = [
                        (_propPos select 0) * (cos _randRot) - (_propPos select 1) * (sin _randRot),
                        (_propPos select 1) * (cos _randRot) + (_propPos select 0) * (sin _randRot)
                    ];

                    _propSpawnPos = [
                        (cellCenter select 0) + (_propPosRot select 0),
                        (cellCenter select 1) + (_propPosRot select 1)
                    ];

                    (createVehicle [_propClass, _propSpawnPos, [], 0, "NONE"]) setDir (_propDir - _randRot);
                };

            };
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


// move players to spawns and give loadouts
_leads = [];
if (not isNull team1_lead) then { _leads pushBack team1_lead; };
if (not isNull team2_lead) then { _leads pushBack team2_lead; };
if (not isNull team3_lead) then { _leads pushBack team3_lead; };
if (not isNull team4_lead) then { _leads pushBack team4_lead; };
for "_g" from 0 to count _leads - 1 do {
    _towerPos = getPos (_spawnTowers select _g);

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


};
