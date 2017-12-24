newline :-
    write("\n").

printl([Elem|Rest]) :-
    write(Elem),
    printl(Rest).

printl([]) :-
    newline().

print_edges(Start) :-
    print_edges(Start, []).

print_edges(Node, Visited) :-
    not(member(Node, Visited)),
    succ(Node, _, Next, Cost),
    printl([Node, "->", Next, ": ", Cost]),
    print_edges(Next, [Node|Visited]).
