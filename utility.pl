:- ensure_loaded(graph).

printl([]) :-
    nl.

printl([Elem|Rest]) :-
    write(Elem),
    printl(Rest).

print_edges() :-
    start(S),
    print_edges(S).

print_edges(Start) :-
    print_edges(Start, []).

print_edges(Node, Visited) :-
    not(member(Node, Visited)),
    succ(Node, _, Cost, Next),
    printl([Node, "->", Next, ": ", Cost]),
    print_edges(Next, [Node|Visited]).

print_node(node(To, Action, From, CostUntil, CostFull)) :-
    FutureCost is CostFull - CostUntil,
    printl([CostUntil, " {", From, "}--", Action, "->{", To, "} ", FutureCost]).

print_nodes([]) :-
    nl.

print_nodes([Node|Rest]) :-
    print_node(Node),
    print_nodes(Rest).

map_indices(List, IndicesList) :-
    map_indices(List, 0, IndicesList).

map_indices([], _, []).

map_indices([Elem|RestList], Index, [Elem/Index|RestIndices]) :-
    NextIndex is Index + 1,
    map_indices(RestList, NextIndex, RestIndices).

print_indices_list(List) :-
    p_print_indices_list(List, 0).

p_print_indices_list([], _).

p_print_indices_list([Elem/_|IndicesList], Index) :-
    printl([Index, ": ", Elem]),
    NewIndex is Index + 1,
    p_print_indices_list(IndicesList, NewIndex).

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

ask_for_order(List, Order) :-
    map_indices(List, IndicesList),
    p_ask_for_order(IndicesList, [], Order).

p_ask_for_order([], Read, Read).

p_ask_for_order(IndicesList, Read, Order) :-
    print_indices_list(IndicesList), nl,
    write("Which one do you want to be evaluated next?"),
    read_index_of_list(IndicesList, Index),
    remove_nth(IndicesList, Index, NewList, Deleted/Id),
    append(Read, [Id], NewRead),
    p_ask_for_order(NewList, NewRead, Order).
