#!/usr/bin/swipl

:- initialization main.

main :-
    ensure_loaded(graph),
    ensure_loaded(utility),
    %trace, %debug
    print_edges(s),
    halt.

main :-
    halt.
