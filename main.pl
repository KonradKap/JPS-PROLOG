#!/usr/bin/swipl

:- initialization main.

main :-
    ensure_loaded(graph),
    ensure_loaded(utility),
    ensure_loaded(astar),
    %trace, %debug
    start_A_star(PathCost),
    printl(["Cost: ", PathCost]),
    %print_edges(),
    halt.

main :-
    halt.
