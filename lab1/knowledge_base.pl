% =========================
% Mob properties
% =========================

passive(sheep).
passive(pig).
passive(chicken).
passive(villager).

aggressive(zombie).
aggressive(skeleton).

neutral(zombie_piglin).


% =========================
% Item properties
% =========================

crafted(iron_sword).
crafted(golden_helmet).
crafted(stick).

dropped(carrot).
dropped(rotten_flesh).
dropped(golden_helmet).
dropped(raw_chicken).
dropped(raw_porkchop).
dropped(raw_mutton).
dropped(white_wool).

is_block(white_wool).
is_weapon(iron_sword).
is_armor(golden_helmet).
is_material(stick).


% =========================
% Relations
% =========================

% Mob drops item
drops(sheep, raw_mutton).
drops(sheep, white_wool).
drops(chicken, raw_chicken).
drops(zombie, rotten_flesh).

% Mob spawns in biome
spawns(sheep, plains).
spawns(pig, plains).
spawns(chicken, plains).

% Biome is located in dimension
locates(plains, overworld).
locates(dark_forest, overworld).
locates(basalt_deltas, nether).
locates(soul_sand_valley, nether).
locates(end_highlands, end).

% Structure generates in biome
generates(village, plains).
generates(mansion, dark_forest).
generates(end_city, end_highlands).

% Structure contains item
contains(village, carrot).
contains(mansion, golden_helmet).
contains(end_city, shulker_shell).


% =========================
% Inference rules
% =========================

% A mob can be encountered in the dimension containing its spawn biome.
mob_dimension(Mob, Dimension) :-
    spawns(Mob, Biome),
    locates(Biome, Dimension).

% A structure can be encountered in the dimension containing its generation biome.
structure_dimension(Structure, Dimension) :-
    generates(Structure, Biome),
    locates(Biome, Dimension).

% An item can be found in the dimension of a structure that contains it.
item_dimension_from_structure(Item, Dimension) :-
    contains(Structure, Item),
    structure_dimension(Structure, Dimension).

% An item can be obtained in the dimension where its source mob spawns.
item_dimension_from_mob(Item, Dimension) :-
    drops(Mob, Item),
    mob_dimension(Mob, Dimension).

% An item is available in a dimension either from a mob or from a structure.
available_item_in_dimension(Item, Dimension) :-
    item_dimension_from_mob(Item, Dimension);
    item_dimension_from_structure(Item, Dimension).

% Aggressive and neutral mobs are potentially hostile.
hostile_mob(Mob) :-
    aggressive(Mob);
    neutral(Mob).

% A passive mob that is not hostile is non-hostile.
non_hostile_mob(Mob) :-
    passive(Mob),
    \+ hostile_mob(Mob).
