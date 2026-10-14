:- encoding(utf8).
:- use_module(library(readutil)).
:- ensure_loaded('../lab1/knowledge_base.pl').

% Every recommendation carries the source, biome and dimension as evidence.
% The original Lab 1 rules determine availability; no independent item list is used.
source(Item, mob, Mob, Biome, Dimension) :-
    drops(Mob, Item), spawns(Mob, Biome),
    item_dimension_from_mob(Item, Dimension), locates(Biome, Dimension).
source(Item, structure, Structure, Biome, Dimension) :-
    contains(Structure, Item), generates(Structure, Biome),
    item_dimension_from_structure(Item, Dimension), locates(Biome, Dimension).

known_item(Item) :- crafted(Item); dropped(Item); contains(_, Item); drops(_, Item).

% Constraints are hard filters. Sorting removes duplicates and stabilizes output.
recommend(Item, Dimension, Method, Results) :-
    findall(result(Kind, Source, Biome, D),
        (source(Item, Kind, Source, Biome, D),
         (Dimension == any ; Dimension == D),
         (Method == any ; Method == Kind)), Raw),
    sort(Raw, Results).

% Strict fixed grammar: key=value;key=value;key=value, no executable input.
% Missing dimension/method are elicited by the dialogue; item is mandatory.
parse_request(Line, Item, Dimension, Method) :-
    split_string(Line, ";", " \t", Fields),
    maplist(parse_field, Fields, Pairs),
    pairs_keys(Pairs, Keys), sort(Keys, Unique),
    same_length(Keys, Unique), memberchk(item-Item, Pairs),
    optional(dimension, Pairs, Dimension), optional(method, Pairs, Method), !.
pairs_keys([], []).
pairs_keys([K-_|T], [K|R]) :- pairs_keys(T, R).
optional(Key, Pairs, Value) :- (memberchk(Key-Value, Pairs) -> true ; Value = missing).
parse_field(Field, Key-Value) :-
    split_string(Field, "=", " \t", [K, V]), V \= "",
    memberchk(K, ["item", "dimension", "method"]), atom_string(Key, K),
    normalize(Key, V, Value).
normalize(item, Raw, Item) :-
    string_lower(Raw, Lower),
    (item_alias(Lower, Item) -> true ; atom_string(Item, Lower)),
    known_item(Item).
normalize(dimension, Raw, Value) :-
    string_lower(Raw, Lower), dimension_alias(Lower, Value).
normalize(method, Raw, Value) :-
    string_lower(Raw, Lower), method_alias(Lower, Value).
item_alias("шерсть", white_wool).
item_alias("морковь", carrot).
item_alias("панцирь шалкера", shulker_shell).
item_alias("золотой шлем", golden_helmet).
item_alias("сырая курятина", raw_chicken).
item_alias("сырая баранина", raw_mutton).
dimension_alias("overworld", overworld).
dimension_alias("обычный мир", overworld).
dimension_alias("nether", nether).
dimension_alias("ад", nether).
dimension_alias("end", end).
dimension_alias("энд", end).
dimension_alias("any", any).
dimension_alias("любое", any).
method_alias("mob", mob).
method_alias("мобы", mob).
method_alias("structure", structure).
method_alias("структуры", structure).
method_alias("any", any).
method_alias("любой", any).

% Диалог: каждый ответ проверяется, ошибочный ввод можно повторить.
ask(Key, Prompt, Value) :-
    nl,
    writeln(Prompt),
    write('> '),
    flush_output,
    read_line_to_string(user_input, Line),
    Line \= end_of_file,
    (   normalize(Key, Line, Value)
    ->  true
    ;   writeln('Неизвестное значение. Повторите ввод.'),
        ask(Key, Prompt, Value)
    ).

complete(dimension, missing, Value) :- !,
    ask(dimension, 'Какое измерение? overworld / nether / end / any', Value).
complete(method, missing, Value) :- !,
    ask(method, 'Какой способ? mob / structure / any', Value).
complete(_, Value, Value).

% Одна рекомендация: источник, место и отдельный блок доказательств.
show_result(Item, result(Kind, Source, Biome, Dimension)) :-
    format('  Предмет:   ~w~n', [Item]),
    format('  Источник:  ~w ~w~n', [Kind, Source]),
    format('  Биом:      ~w~n', [Biome]),
    format('  Измерение: ~w~n', [Dimension]),
    writeln('  Обоснование:'),
    (   Kind == mob
    ->  format('    drops(~w, ~w)~n', [Source, Item]),
        format('    spawns(~w, ~w)~n', [Source, Biome])
    ;   format('    contains(~w, ~w)~n', [Source, Item]),
        format('    generates(~w, ~w)~n', [Source, Biome])
    ),
    format('    locates(~w, ~w)~n~n', [Biome, Dimension]).

show_results(Item, Dimension, Method, []) :- !,
    nl,
    writeln('Результат: совпадений нет'),
    writeln('В базе знаний нет источников с выбранными условиями.'),
    recommend(Item, any, any, Alternatives),
    (   Alternatives == []
    ->  writeln('Предмет известен, но БЗ не описывает место его получения или рецепт крафта.')
    ;   format('Можно изменить ограничения (~w, ~w).~n', [Dimension, Method]),
        writeln('Альтернативы из БЗ (не соответствуют исходным условиям):'),
        nl,
        maplist(show_result(Item), Alternatives)
    ),
    writeln('Отсутствие факта не означает невозможность получения предмета в игре.').
show_results(Item, _, _, Results) :-
    length(Results, Count),
    format('~nРекомендации — найдено источников: ~d~n~n', [Count]),
    maplist(show_result(Item), Results).

% Обработка одной строки: разбор → уточнение → запрос → вывод.
request(Line) :-
    (   parse_request(Line, Item, D0, M0)
    ->  (   complete(dimension, D0, D),
            complete(method, M0, M)
        ->  format('~nЗапрос: recommend(~q, ~q, ~q, Results).~n', [Item, D, M]),
            recommend(Item, D, M, Results),
            show_results(Item, D, M, Results)
        ;   true
        )
    ;   nl,
        writeln('Ошибка: проверьте формат, ключи и значения.'),
        writeln('Пример: item=шерсть;dimension=overworld;method=any')
    ).

main :-
    nl,
    writeln('Minecraft DSS — поиск источников ресурсов'),
    nl,
    writeln('Формат: item=<предмет>;dimension=<измерение>;method=<способ>'),
    writeln('Можно указать только item: система задаст два вопроса.'),
    writeln('Пример: item=шерсть'),
    writeln('Для выхода: exit'),
    loop.

loop :-
    nl,
    write('Введите запрос > '),
    flush_output,
    read_line_to_string(user_input, Raw),
    (   Raw == end_of_file
    ->  nl
    ;   normalize_space(string(Line), Raw),
        (   Line == "exit"
        ->  writeln('Работа завершена.')
        ;   request(Line),
            loop
        )
    ).
