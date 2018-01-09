#!/usr/bin/swipl

:- initialization main.

:- ensure_loaded(utility).
:- ensure_loaded(astar).

shown_queue_size(5).

main :-
    %trace, %debug
    start_A_star(path_cost(Path, Cost), graph),
    printl(["Path is: "]),
    pretty_print(Path),
    printl(["Cost: ", Cost]),
    halt.

main :-
    halt.

pretty_print([]).

pretty_print([Action/Node|Path]) :-
    printl(["--", Action, "-->", Node]),
    pretty_print(Path).
