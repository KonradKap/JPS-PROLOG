:- ensure_loaded(tree).

printl([]) :-
    nl.

printl([Elem|Rest]) :-
    write(Elem),
    printl(Rest).

print_node(node(To, Action, From, CostUntil, CostFull)) :-
    FutureCost is CostFull - CostUntil,
    printl([CostUntil, " {", From, "}--", Action, "->{", To, "} ", FutureCost]).

map_indices(List, IndicesList) :-
    map_indices(List, 0, IndicesList).

map_indices([], _, []).

map_indices([Elem|RestList], Index, [Elem/Index|RestIndices]) :-
    NextIndex is Index + 1,
    map_indices(RestList, NextIndex, RestIndices).

print_indices_list(List, PrintFunction) :-
    p_print_indices_list(List, 0, PrintFunction).

p_print_indices_list([], _, _).

p_print_indices_list([Elem/_|IndicesList], Index, PrintFunction) :-
    write(Index), write(": "), call(PrintFunction, Elem),
    NewIndex is Index + 1,
    p_print_indices_list(IndicesList, NewIndex, PrintFunction).

read_index_of_list(List, Index) :-
    read(Index),
    integer(Index),
    Index >= 0,
    length(List, UpperBound),
    Index < UpperBound.

remove_nth(List, Index, RetList, Deleted) :-
    p_remove_nth(List, Index, 0, RetList, Deleted).

p_remove_nth([], _, _, [], _).

p_remove_nth([Elem|List], Index, Current, [Elem|RetList], Deleted) :-
    Index \= Current,
    NewCurrent is Current + 1,
    p_remove_nth(List, Index, NewCurrent, RetList, Deleted).

p_remove_nth([Elem|List], Index, Index, RetList, Elem) :-
    NewCurrent is Index + 1,
    p_remove_nth(List, Index, NewCurrent, RetList, Elem).

ask_for_order(List, Order, PrintFunction) :-
    map_indices(List, IndicesList),
    p_ask_for_order(IndicesList, [], Order, PrintFunction).

p_ask_for_order([], Read, Read, _).

p_ask_for_order(IndicesList, Read, Order, PrintFunction) :-
    print_indices_list(IndicesList, PrintFunction), nl,
    write("Which one do you want to be evaluated next?"),
    read_index_of_list(IndicesList, Index),
    remove_nth(IndicesList, Index, NewList, _/Id),
    append(Read, [Id], NewRead),
    p_ask_for_order(NewList, NewRead, Order, PrintFunction).

reorder(List, Order, Ordered) :-
    p_reorder(List, Order, [], Ordered).

p_reorder(_, [], Partial, Partial).

p_reorder(List, [Index|Order], Partial, Ordered) :-
    nth0(Index, List, Elem),
    append(Partial, [Elem], NewPartial),
    p_reorder(List, Order, NewPartial, Ordered).
