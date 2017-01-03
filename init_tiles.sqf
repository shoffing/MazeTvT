params ["_WIDTH", "_HEIGHT", "_mazePos", "_wallLength"];


/*
 * Constants
 */

_PROB_TILE = 80;
_PROB_VEHICLE = 40;
_PROB_CRATE = 35;


/*
 * Set up tile configurations
 */

_tile_bunkers1  = [[["type","Land_BagBunker_Tower_F"],["pos",[0.0830078,-0.0816879]],["dir",180],["height",0.00172424],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[0.877235,-2.34669]],["dir",269.694],["height",0.00025177],["hasInventory",true],["isVehicle",false]]];
_tile_bunkers2  = [[["type","Land_BagBunker_Small_F"],["pos",[6.32444,6.17226]],["dir",270.017],["height",-0.0075531],["hasInventory",false],["isVehicle",false]],[["type","Land_BagBunker_Small_F"],["pos",[-5.69943,-6.0687]],["dir",90.0345],["height",0.00982857],["hasInventory",false],["isVehicle",false]],[["type","Land_BagFence_Long_F"],["pos",[7.80594,2.66259]],["dir",270.023],["height",0.0480995],["hasInventory",false],["isVehicle",false]],[["type","Land_BagFence_Long_F"],["pos",[-7.09856,-2.58232]],["dir",270.029],["height",0.0315151],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[6.40103,2.72327]],["dir",178.365],["height",0.000221252],["hasInventory",true],["isVehicle",false]],[["type","LOP_AFR_Offroad_M2"],["pos",[0.782639,-0.35376]],["dir",99.5281],["height",0.070158],["hasInventory",true],["isVehicle",true]]];
_tile_bunkers3  = [[["type","Land_Vez"],["pos",[-3.95528,3.03352]],["dir",0],["height",-0.0659313],["hasInventory",false],["isVehicle",false]],[["type","Land_Fort_Watchtower_EP1"],["pos",[3.68834,-0.786697]],["dir",0],["height",-0.714611],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[3.72755,-0.236168]],["dir",269.641],["height",-0.000190735],["hasInventory",true],["isVehicle",false]],[["type","rhsgref_ins_uaz_dshkm"],["pos",[-3.53341,-1.67017]],["dir",181.027],["height",0.0546951],["hasInventory",true],["isVehicle",true]]];
_tile_bunkers4  = [[["type","Land_BagBunker_Large_F"],["pos",[1.82453,0.662167]],["dir",0.823065],["height",0.247597],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_craet2"],["pos",[-6.207,-2.58748]],["dir",0],["height",0.230944],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[0.529816,2.30791]],["dir",269.625],["height",-0.00137138],["hasInventory",true],["isVehicle",false]]];

_tile_sandbags1 = [[["type","Land_BagFence_Round_F"],["pos",[-5.2615,-5.1946]],["dir",44.9752],["height",0.0526314],["hasInventory",false],["isVehicle",false]],[["type","Land_HBarrier1"],["pos",[-0.00917053,-0.00781631]],["dir",0],["height",4.57764e-005],["hasInventory",false],["isVehicle",false]],[["type","Land_BagFence_Round_F"],["pos",[5.19252,-5.2391]],["dir",314.985],["height",-0.00505066],["hasInventory",false],["isVehicle",false]],[["type","Land_BagFence_Round_F"],["pos",[5.23687,5.19419]],["dir",225.016],["height",-0.0135937],["hasInventory",false],["isVehicle",false]],[["type","Land_BagFence_Round_F"],["pos",[-5.21703,5.24006]],["dir",135.025],["height",-0.0459385],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[3.30635,3.46634]],["dir",269.692],["height",-0.00105095],["hasInventory",true],["isVehicle",false]]];

_tile_market1 = [[["type","CUP_str_fikovnik2"],["pos",[3.90147,-4.54925]],["dir",0],["height",0.00584412],["hasInventory",false],["isVehicle",false]],[["type","Land_transport_cart_EP1"],["pos",[-5.27603,6.31971]],["dir",119.987],["height",0.000543594],["hasInventory",false],["isVehicle",false]],[["type","land_cwa_Crates"],["pos",[-5.80352,4.36894]],["dir",74.9568],["height",0.000102997],["hasInventory",false],["isVehicle",false]],[["type","Land_Bag_EP1"],["pos",[-4.21659,3.69145]],["dir",74.9461],["height",-0.000324249],["hasInventory",false],["isVehicle",false]],[["type","Land_Bag_EP1"],["pos",[-4.72671,4.42076]],["dir",74.9461],["height",-0.000324249],["hasInventory",false],["isVehicle",false]],[["type","Land_transport_kiosk_EP1"],["pos",[1.53804,6.69528]],["dir",119.987],["height",0.00091362],["hasInventory",false],["isVehicle",false]],[["type","Land_transport_kiosk_EP1"],["pos",[3.72704,5.33491]],["dir",119.987],["height",0.000888824],["hasInventory",false],["isVehicle",false]],[["type","Land_transport_kiosk_EP1"],["pos",[5.91869,4.00125]],["dir",119.948],["height",0.00148201],["hasInventory",false],["isVehicle",false]],[["type","Land_Basket_EP1"],["pos",[2.1806,-4.97556]],["dir",0],["height",-0.000730515],["hasInventory",false],["isVehicle",false]],[["type","Land_Basket_EP1"],["pos",[1.19066,-4.44918]],["dir",0],["height",0.00145912],["hasInventory",false],["isVehicle",false]],[["type","Land_Basket_EP1"],["pos",[1.19315,-5.51642]],["dir",0],["height",-0.000282288],["hasInventory",false],["isVehicle",false]],[["type","Axe_woodblock"],["pos",[3.61464,-3.54761]],["dir",332.167],["height",-0.000814438],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[1.4347,-2.86419]],["dir",269.614],["height",-0.0008564],["hasInventory",true],["isVehicle",false]]];

_tile_trees1 = [[["type","CUP_str_fikovnik_ker"],["pos",[-4.40083,4.50196]],["dir",0],["height",-0.00545692],["hasInventory",false],["isVehicle",false]],[["type","CUP_les_fikovnik2"],["pos",[5.15813,3.65171]],["dir",0],["height",0.0138359],["hasInventory",false],["isVehicle",false]],[["type","CUP_les_fikovnik2"],["pos",[2.48758,-4.76972]],["dir",0],["height",0.00953293],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-4.70454,-5.02169]],["dir",0],["height",0.00306129],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[0.330002,3.78956]],["dir",0],["height",0.00408745],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[-1.03907,2.37377]],["dir",269.648],["height",-8.96454e-005],["hasInventory",true],["isVehicle",false]],[["type","C_Quadbike_01_F"],["pos",[-2.8541,-0.785559]],["dir",218.487],["height",0.203205],["hasInventory",true],["isVehicle",true]],[["type","C_Quadbike_01_F"],["pos",[2.14338,1.0373]],["dir",218.487],["height",0.203411],["hasInventory",true],["isVehicle",true]],[["type","C_Quadbike_01_F"],["pos",[-0.0109634,-1.83122]],["dir",218.49],["height",0.202993],["hasInventory",true],["isVehicle",true]]];

_tile_bushes1 = [[["type","CUP_t_betula2w"],["pos",[5.87202,-3.43642]],["dir",0],["height",-0.00143623],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_craet2"],["pos",[4.20136,6.61355]],["dir",0],["height",0.00169754],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_prunus"],["pos",[-7.91367,2.49655]],["dir",0],["height",0.00181961],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-6.42723,-6.57687]],["dir",0],["height",0.00780296],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-6.01997,-3.05232]],["dir",0],["height",0.00735474],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-3.01615,-5.69037]],["dir",0],["height",0.00598526],["hasInventory",false],["isVehicle",false]],[["type","CUP_t_betula2w"],["pos",[-5.14482,4.50687]],["dir",0],["height",-0.00127602],["hasInventory",false],["isVehicle",false]],[["type","CUP_t_betula2w"],["pos",[1.78054,-5.79723]],["dir",0],["height",-0.00204659],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[3.32829,0.398392]],["dir",0],["height",0.00333214],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[2.49441,-2.48029]],["dir",45.673],["height",0.0224934],["hasInventory",true],["isVehicle",false]],[["type","UK3CB_BAF_Coyote_Logistics_L111A1_D"],["pos",[-0.976738,0.527454]],["dir",20.3845],["height",0.117542],["hasInventory",true],["isVehicle",true]]];
_tile_bushes2 = [[["type","CUP_b_craet2"],["pos",[4.17795,6.60494]],["dir",0],["height",0.00293159],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_prunus"],["pos",[-4.75288,3.4825]],["dir",0],["height",0.00181198],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-6.40661,-6.55174]],["dir",0],["height",0.00128937],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[3.04194,2.01192]],["dir",0],["height",0.00369453],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-3.00777,-5.66592]],["dir",0],["height",0.00108528],["hasInventory",false],["isVehicle",false]],[["type","CUP_t_betula2w"],["pos",[2.30914,-1.99484]],["dir",0],["height",-0.000787735],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_prunus"],["pos",[-0.438004,4.19832]],["dir",0],["height",0.00198555],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[-4.28649,-3.8843]],["dir",85.2045],["height",-0.000556946],["hasInventory",true],["isVehicle",false]],[["type","rhsgref_ins_uaz_dshkm"],["pos",[-2.93236,-0.474113]],["dir",304.392],["height",0.0533791],["hasInventory",true],["isVehicle",true]]];
_tile_bushes3 = [[["type","CUP_b_craet2"],["pos",[4.20581,6.62265]],["dir",0],["height",0.00168991],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_prunus"],["pos",[-5.46519,-1.00956]],["dir",0],["height",-0.000295639],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[5.10918,-4.22665]],["dir",0],["height",0.00220299],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_prunus"],["pos",[-3.55785,1.14217]],["dir",0],["height",-9.72748e-005],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_craet2"],["pos",[4.30774,2.45881]],["dir",0],["height",0.00660324],["hasInventory",false],["isVehicle",false]],[["type","CUP_b_craet2"],["pos",[-2.10152,6.12033]],["dir",0],["height",0.00247383],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi4"],["pos",[-2.74945,-4.9859]],["dir",345.003],["height",-0.0198116],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[1.70122,4.31193]],["dir",136.431],["height",-0.000185013],["hasInventory",true],["isVehicle",false]],[["type","rhsusf_m1025_d_m2"],["pos",[0.440781,-1.78989]],["dir",137.673],["height",0.0864697],["hasInventory",true],["isVehicle",true]]];

_tile_hunting = [[["type","Land_Misc_deerstand"],["pos",[-4.20983,-2.11205]],["dir",0],["height",-0.00970268],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[6.2081,-4.65709]],["dir",0],["height",0.00571632],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[6.81623,-2.86979]],["dir",0],["height",0.00567055],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[4.99378,-3.32235]],["dir",0],["height",0.00571632],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_bigest"],["pos",[-2.48209,-2.73823]],["dir",0],["height",0.00553894],["hasInventory",false],["isVehicle",false]],[["type","CUP_Krovi_long"],["pos",[4.17705,3.97356]],["dir",14.9935],["height",-0.121708],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[-1.38695,-1.24535]],["dir",141.518],["height",0.000270844],["hasInventory",true],["isVehicle",false]]];

_tile_playground = [[["type","Land_SlideCastle_F"],["pos",[4.20441,3.08353]],["dir",0],["height",0.00102615],["hasInventory",false],["isVehicle",false]],[["type","Land_Slide_F"],["pos",[0.489983,-6.09644]],["dir",0],["height",0.0998058],["hasInventory",false],["isVehicle",false]],[["type","Land_kolotoc"],["pos",[-3.53152,3.70242]],["dir",0],["height",0.000511169],["hasInventory",false],["isVehicle",false]],[["type","Land_kulata_prolezacka"],["pos",[-5.14729,-2.78384]],["dir",0],["height",0.000736237],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[-6.033,5.67381]],["dir",269.66],["height",3.62396e-005],["hasInventory",true],["isVehicle",false]],[["type","C_Offroad_01_F"],["pos",[0.874741,3.91149]],["dir",0.403672],["height",0.0681496],["hasInventory",true],["isVehicle",true]]];

_tile_cars1 = [[["type","Land_Wreck_Ural_F"],["pos",[4.46234,-4.40546]],["dir",209.992],["height",-0.102491],["hasInventory",false],["isVehicle",false]],[["type","Land_Wreck_Car_F"],["pos",[-4.83978,4.93622]],["dir",44.9942],["height",0.0663395],["hasInventory",false],["isVehicle",false]],[["type","Land_Wreck_Van_F"],["pos",[2.17288,3.87922]],["dir",345.014],["height",0.00620461],["hasInventory",false],["isVehicle",false]],[["type","Land_RailwayCar_01_tank_F"],["pos",[-4.62285,-2.95936]],["dir",194.809],["height",0.00178528],["hasInventory",false],["isVehicle",false]],[["type","Box_NATO_Equip_F"],["pos",[2.31873,-3.5839]],["dir",209.204],["height",0.000579834],["hasInventory",true],["isVehicle",false]],[["type","O_Quadbike_01_F"],["pos",[-0.960197,-0.651146]],["dir",144.859],["height",0.206066],["hasInventory",true],["isVehicle",true]],[["type","O_Quadbike_01_F"],["pos",[-1.22292,-4.03283]],["dir",144.856],["height",0.205608],["hasInventory",true],["isVehicle",true]],[["type","O_Quadbike_01_F"],["pos",[1.96069,-0.580109]],["dir",144.859],["height",0.206081],["hasInventory",true],["isVehicle",true]]];
_tile_cars2 = [[["type","Box_NATO_Equip_F"],["pos",[-1.52645,1.48757]],["dir",209.216],["height",0.000597],["hasInventory",true],["isVehicle",false]],[["type","Land_Wreck_CarDismantled_F"],["pos",[0.860329,3.80656]],["dir",147.787],["height",0.00605392],["hasInventory",false],["isVehicle",false]],[["type","Land_Wreck_Car_F"],["pos",[-4.49583,0.0200577]],["dir",0],["height",0.00317192],["hasInventory",false],["isVehicle",false]],[["type","Land_Wreck_Van_F"],["pos",[4.85159,-3.2385]],["dir",0],["height",0.00318146],["hasInventory",false],["isVehicle",false]],[["type","rhsgref_ins_uaz_dshkm"],["pos",[-1.87988,-5.17]],["dir",67.7276],["height",0.0564728],["hasInventory",true],["isVehicle",true]]];

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

    _tile_cars1,
    _tile_cars1,

    _tile_cars2,
    _tile_cars2
];


/*
 * Set up weapon, grenade, item configurations
 */
BAD_GUNZ = [];
BAD_MAGZ = [];

_weapons = ["rhs_weap_akm","rhs_weap_akm","rhs_weap_akm","rhs_weap_akm","rhs_weap_akm","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","rhsusf_weap_glock17g4","hlc_smg_mp5a3","hlc_rifle_M14","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","hgun_ACPC2_F","SAM_AK5C_NOGRIP","SAM_AK5C_NOGRIP","rhs_weap_ak104","rhs_weap_ak74m_camo_folded","rhs_weap_akms","arifle_AKS_F","rhs_weap_aks74un_folded","rhs_weap_aks74un_folded","rhs_weap_asval","rhs_weap_asval","hlc_rifle_Colt727","hlc_rifle_Colt727","hlc_rifle_Colt727","hlc_rifle_M4","hlc_rifle_M4","hlc_rifle_M4","hlc_rifle_M4","hlc_rifle_L1A1SLR","hlc_rifle_FAL5000","hlc_rifle_g3sg1","hlc_rifle_G36C","hlc_rifle_G36V","hlc_rifle_hk33a2","hlc_rifle_hk53","hlc_smg_mp5a2","hlc_smg_mp5a2","hlc_smg_mp5a2","hlc_smg_mp5a4","hlc_smg_mp5a4","hlc_smg_mp5a4","hlc_smg_MP5N","hlc_smg_MP5N","hlc_smg_MP5N","rhs_weap_hk416d10","rhs_weap_hk416d145","hlc_rifle_ak47","hlc_rifle_ak47","hlc_rifle_aks74u","hlc_rifle_rpk","rhs_weap_kar98k","rhs_weap_kar98k","rhs_weap_kar98k","UK3CB_BAF_L115A3_DE","UK3CB_BAF_L119A1","UK3CB_BAF_L128A1","UK3CB_BAF_L128A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L131A1","UK3CB_BAF_L22","UK3CB_BAF_L92A1","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","LOP_Weap_LeeEnfield","rhs_weap_m21a_fold","rhs_weap_m92","RH_M16a1","rhs_weap_m16a4_carryhandle","hlc_rifle_M1903A1_unertl","hlc_rifle_M1903A1_unertl","hlc_rifle_M1903A1_unertl","hlc_rifle_M21","rhs_weap_m249_pip_S","RH_m4","RH_m4","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","rhsusf_weap_m9","hlc_lmg_MG42","rhs_weap_sr25","rhs_weap_m38","rhs_weap_m38","rhs_weap_m38","rhs_weap_m38","rhs_weap_m38","rhsusf_weap_MP7A1_desert","rhsusf_weap_MP7A1_desert","rhsusf_weap_MP7A1_desert","rhsusf_weap_MP7A1_desert","rhsusf_weap_MP7A1_desert","SMG_03C_black","SMG_03C_black","hgun_PDW2000_F","hgun_PDW2000_F","hgun_PDW2000_F","rhs_weap_pkm","rhs_weap_pp2000_folded","rhs_weap_pp2000_folded","rhs_weap_pp2000_folded","rhs_weap_pp2000_folded","rhs_weap_pp2000_folded","rhs_weap_pp2000_folded","hlc_rifle_augsrcarb","hlc_rifle_augsrcarb","hlc_rifle_augsrcarb","hlc_rifle_augsr_t","hlc_rifle_augsr_t","rhs_weap_svds","rhs_weap_svds","rhs_weap_vss","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","hgun_Pistol_heavy_02_F","rhs_weap_fgm148","rhs_weap_fgm148","rhs_weap_M136","rhs_weap_M136","rhs_weap_rpg26","rhs_weap_rpg26","rhs_weap_rpg26","rhs_weap_rpg26","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7"];

_grenades = ["ACE_M14", "ACE_M14", "ACE_M14", "APERSBoundingMine_Range_Mag", "APERSTripMine_Wire_Mag", "ATMine_Range_Mag", "ATMine_Range_Mag", "ATMine_Range_Mag", "ClaymoreDirectionalMine_Remote_Mag", "rhs_mag_m18_green", "rhs_mag_m18_purple", "rhs_mag_m18_red", "rhs_mag_m18_yellow", "rhs_mag_m67", "rhs_mag_m67", "rhs_mag_m67", "rhs_mag_m67", "rhs_mag_m67", "rhs_mag_m67", "rhs_mag_m67", "ACE_M84", "ACE_M84", "ACE_M84", "rhs_mag_rgn", "rhs_mag_rgn", "rhs_mag_rgo", "rhs_mag_rgo"];

_equipment = ["ACE_fieldDressing","ItemGPS","ItemGPS","ItemGPS","usm_helmet_safety","usm_helmet_safety","MNP_Vest_RUMED","MNP_Vest_RUMED","ACE_morphine","ACE_morphine","SOUP_Vest_PMC_SAND_B","usm_vest_safety","usm_vest_safety"];
_equipment_weap = ["MineDetector", "MineDetector", "Binocular", "Binocular", "Binocular", "Binocular"];



/*
 * Spawn tiles
 */

for "_x" from 0 to _WIDTH - 1 do {
    for "_y" from 0 to _HEIGHT - 1 do {

        cellCenter = [
            (_mazePos select 0) + _x * _wallLength + _wallLength / 2,
            (_mazePos select 1) + _y * _wallLength + _wallLength / 2,
            _mazePos select 2
        ];

        _inCenter = not (_x < WIDTH/2-1 or _x > WIDTH/2 or _y < HEIGHT/2-1 or _y > HEIGHT/2);
        _inCorner = (_x == 0 and _y == 0) or (_x == 0 and _y == _HEIGHT-1) or (_x == _WIDTH-1 and _y == 0) or (_x == _WIDTH-1 and _y == _HEIGHT-1);
        _isEdge = (_x == 0 or _x == _WIDTH-1 or _y == 0 or _y == _HEIGHT-1);


        if ((not _inCenter) and (not _inCorner)) then {
            if ((random 100) < _PROB_TILE) then {

                // Select random tile
                _tile = _tiles call BIS_fnc_selectRandom;
                _randRot = [0, 90, 180, 270] call BIS_fnc_selectRandom;

                for "_p" from 0 to count _tile - 1 do {
                    _prop = [_tile select _p] call CBA_fnc_hashCreate;
                    _propIsVehicle = [_prop, "isVehicle"] call CBA_fnc_hashGet;
                    _propHasInv = [_prop, "hasInventory"] call CBA_fnc_hashGet;

                    _vehSpawn = not _propIsVehicle or (random 100) < _PROB_VEHICLE;
                    _invSpawn = (not _propIsVehicle and not _propHasInv) or (random 100) < _PROB_CRATE;

                    if (_vehSpawn and _invSpawn) then {
                        _propClass = [_prop, "type"] call CBA_fnc_hashGet;
                        _propPos = [_prop, "pos"] call CBA_fnc_hashGet;
                        _propDir = [_prop, "dir"] call CBA_fnc_hashGet;
                        _propHeight = [_prop, "height"] call CBA_fnc_hashGet;

                        _propPosRot = [
                            (_propPos select 0) * (cos _randRot) - (_propPos select 1) * (sin _randRot),
                            (_propPos select 1) * (cos _randRot) + (_propPos select 0) * (sin _randRot)
                        ];

                        _propSpawnPos = [
                            (cellCenter select 0) + (_propPosRot select 0),
                            (cellCenter select 1) + (_propPosRot select 1),
                            _propHeight
                        ];

                        _propObj = createVehicle [_propClass, _propSpawnPos, [], 0, "NONE"];
                        _propObj setPos _propSpawnPos;
                        _propObj setDir (_propDir - _randRot);

                        // Add inventory
                        if (_propHasInv) then {
                            // Remove all stuff
                            clearWeaponCargoGlobal _propObj;
                            clearMagazineCargoGlobal _propObj;
                            clearItemCargoGlobal _propObj;

                            // Add random weapons
                            for "_i" from 0 to (floor random (4 + 1)) do {
                                _addWeapon = _weapons call BIS_fnc_selectRandom;

                                // Add random mags for weapon
                                _weaponMags = getArray (configFile >> "CfgWeapons" >> _addWeapon >> "magazines");
                                if (count _weaponMags > 0) then {
                                    _propObj addWeaponCargoGlobal [_addWeapon, 1];

                                    _mag = _weaponMags call BIS_fnc_selectRandom;
                                    for "_j" from 1 to (8 + (floor random (8 + 1))) do {
                                        if (isClass (configFile >> "CfgMagazines" >> _mag)) then {
                                            _propObj addMagazineCargoGlobal [_mag, 1];
                                        } else {
                                            BAD_MAGZ pushBackUnique [_addWeapon, _mag];
                                        };
                                    };
                                } else {
                                    BAD_GUNZ pushBackUnique [_addWeapon];
                                };
                            };

                            // Add random explosives / grenades and stuff
                            for "_i" from 1 to (floor random (5 + 1)) do {
                                _addGrenade = _grenades call BIS_fnc_selectRandom;
                                _propObj addMagazineCargoGlobal [_addGrenade, 1];
                            };

                            // Add random equipment
                            for "_i" from 1 to (floor random (10 + 1)) do {
                                _addEquip = _equipment call BIS_fnc_selectRandom;
                                _propObj addItemCargoGlobal [_addEquip, 1];
                            };

                            // Add random equipment that are actually weapons
                            for "_i" from 1 to (floor random (4 + 1)) do {
                                _addEquip = _equipment_weap call BIS_fnc_selectRandom;
                                _propObj addItemCargoGlobal [_addEquip, 1];
                            };

                            // Add backpacks to half the crates
                            if (random 2 < 1) then {
                                _propObj addBackpackCargoGlobal ["B_Carryall_ocamo", floor random 4];
                            };
                        };

                        // Unlock vehicle
                        if (_propIsVehicle) then {
                            _propObj setVehicleLock "UNLOCKED";
                        };
                    };
                };

            };
        };

    };
};
