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