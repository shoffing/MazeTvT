params ["_WIDTH", "_HEIGHT", "_mazePos", "_wallLength"];


// Set up tile configurations
// [class name, position, dir, height]
_tile_bunkers1 = [["Land_BagBunker_Tower_F",[1.235,0],180,0.00273132]];
_tile_bunkers2 = [["Land_BagBunker_Small_F",[6.35997,6.17167],269.971,0.0131073],["Land_BagBunker_Small_F",[-5.67158,-6.07964],89.9656,-0.00581551],["Land_BagFence_Long_F",[7.82079,2.66537],269.968,0.0355682],["Land_BagFence_Long_F",[-7.08323,-2.58733],269.966,0.0552616]];
_tile_bunkers3 = [["Land_Vez",[-4.02988,4.27694],0,0.101759],["Land_Fort_Watchtower_EP1",[3.25467,-2.76748],0,-0.0262547]];
_tile_bunkers4 = [["Land_BagBunker_Large_F",[1.77587,0.637836],0.823681,0.031786],["CUP_b_craet2",[-6.33257,-2.61266],0,0.00409126]];
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

    _tile_bunkers4,

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

    _tile_cars,
    _tile_cars
];


for "_x" from 0 to _WIDTH - 1 do {
    for "_y" from 0 to _HEIGHT - 1 do {

        cellCenter = [
            (_mazePos select 0) + _x * _wallLength + _wallLength / 2,
            (_mazePos select 1) + _y * _wallLength + _wallLength / 2,
            _mazePos select 2
        ];

        _inCenter = not (_x < _WIDTH/2-2 or _x > _WIDTH/2+1 or _y < _HEIGHT/2-2 or _y > _HEIGHT/2+1);
        _inCorner = (_x == 0 and _y == 0) or (_x == 0 and _y == _HEIGHT-1) or (_x == _WIDTH-1 and _y == 0) or (_x == _WIDTH-1 and _y == _HEIGHT-1);
        _isEdge = (_x == 0 or _x == _WIDTH-1 or _y == 0 or _y == _HEIGHT-1);


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
