:- ensure_loaded('../dss.pl').
:- begin_tests(dss).
test(wool) :- recommend(white_wool, overworld, any, [result(mob,sheep,plains,overworld)]).
test(carrot) :- recommend(carrot, overworld, structure, [result(structure,village,plains,overworld)]).
test(shell) :- recommend(shulker_shell, end, any, [result(structure,end_city,end_highlands,end)]).
test(helmet) :- recommend(golden_helmet, any, structure, [result(structure,mansion,dark_forest,overworld)]).
test(chicken) :- recommend(raw_chicken, overworld, mob, [result(mob,chicken,plains,overworld)]).
test(wrong_dimension) :- recommend(white_wool, nether, any, []).
test(wrong_method) :- recommend(carrot, any, mob, []).
test(known_without_source) :- recommend(iron_sword, any, any, []).
test(aliases) :- parse_request("item=ШЕРСТЬ;dimension=обычный мир;method=мобы", white_wool, overworld, mob).
test(missing_slots) :- parse_request("item=carrot", carrot, missing, missing).
test(order) :- parse_request("method=any;item=carrot;dimension=any", carrot, any, any).
test(unknown_item, [fail]) :- parse_request("item=diamond", _, _, _).
test(unknown_dimension, [fail]) :- parse_request("item=carrot;dimension=moon", _, _, _).
test(unknown_method, [fail]) :- parse_request("item=carrot;method=craft", _, _, _).
test(duplicate, [fail]) :- parse_request("item=carrot;item=white_wool", _, _, _).
test(unknown_key, [fail]) :- parse_request("item=carrot;age=13", _, _, _).
test(empty, [fail]) :- parse_request("", _, _, _).
test(empty_value, [fail]) :- parse_request("item=", _, _, _).
test(injection, [fail]) :- parse_request("item=carrot),halt.", _, _, _).
:- end_tests(dss).
:- initialization((run_tests -> halt(0) ; halt(1)), main).
