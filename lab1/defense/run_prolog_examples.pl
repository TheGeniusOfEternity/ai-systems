:- consult('../knowledge_base.pl').

show_truth(Query, Goal) :-
    format('?- ~s~n', [Query]),
    (   call(Goal)
    ->  writeln('true.')
    ;   writeln('false.')
    ),
    nl.

show_answers(Query, Template, Goal) :-
    format('?- ~s~n', [Query]),
    findall(Template, Goal, Answers),
    writeln(Answers),
    nl.

main :-
    show_truth('passive(sheep).', passive(sheep)),
    show_answers('spawns(Mob, plains).', Mob, spawns(Mob, plains)),
    show_answers('drops(sheep, Item), dropped(Item).', Item,
                 (drops(sheep, Item), dropped(Item))),
    show_answers('hostile_mob(Mob).', Mob, hostile_mob(Mob)),
    show_answers('non_hostile_mob(Mob).', Mob, non_hostile_mob(Mob)),
    show_answers('mob_dimension(Mob, Dimension).', Mob-Dimension,
                 mob_dimension(Mob, Dimension)),
    show_answers('item_dimension_from_structure(shulker_shell, Dimension).',
                 Dimension,
                 item_dimension_from_structure(shulker_shell, Dimension)),
    show_answers('available_item_in_dimension(Item, overworld).', Item,
                 available_item_in_dimension(Item, overworld)),
    halt.

:- initialization(main, main).
