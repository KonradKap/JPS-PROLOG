#!/usr/bin/swipl

:- initialization main.

:- ensure_loaded(tree).
:- ensure_loaded(utility).
:- ensure_loaded(astar).

main :-
    %trace, %debug
    start_A_star(path_cost(Path, Cost)),
    printl(["Path is: "]),
    pretty_print(Path),
    printl(["For: ", Cost]),
    halt.

main :-
    halt.

pretty_print([]).

pretty_print([Action/Node|Path]) :-
    printl(["--", Action, "-->", Node]),
    pretty_print(Path).
