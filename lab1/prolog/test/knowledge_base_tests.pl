:- begin_tests(knowledge_base).

:- consult('../../knowledge_base.pl').

test(mob_dimension) :-
    mob_dimension(sheep, overworld).

test(structure_dimension) :-
    structure_dimension(end_city, end).

test(item_dimension_from_mob) :-
    item_dimension_from_mob(raw_mutton, overworld).

test(item_dimension_from_structure) :-
    item_dimension_from_structure(shulker_shell, end).

test(available_item_in_dimension, [nondet]) :-
    available_item_in_dimension(raw_mutton, overworld).

test(hostile_mob_from_disjunction) :-
    hostile_mob(zombie_piglin).

test(non_hostile_mob_from_negation) :-
    non_hostile_mob(sheep).

:- end_tests(knowledge_base).
