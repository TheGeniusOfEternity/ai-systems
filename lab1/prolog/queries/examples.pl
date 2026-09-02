% Load the knowledge base before running these queries:
% ?- [lab1/knowledge_base].

% 1. Simple fact query.
% ?- passive(sheep).

% 2. Search with a variable.
% ?- spawns(Mob, plains).

% 3. Conjunction: find items dropped by a sheep that are marked as dropped.
% ?- drops(sheep, Item), dropped(Item).

% 4. Disjunction in a derived predicate.
% ?- hostile_mob(Mob).

% 5. Negation in a derived predicate.
% ?- non_hostile_mob(Mob).

% 6. Rule composition: determine where a mob can spawn.
% ?- mob_dimension(sheep, Dimension).

% 7. Rule composition through a structure.
% ?- item_dimension_from_structure(shulker_shell, Dimension).

% 8. A combined query for all obtainable items in the Overworld.
% ?- available_item_in_dimension(Item, overworld).
