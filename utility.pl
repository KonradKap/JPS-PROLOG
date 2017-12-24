newline :-
    write("\n").

printl([Elem|Rest]) :-
    write(Elem),
    printl(Rest).

printl([]) :-
    newline().

print_edges() :-
    ensure_loaded(graph),
    start(S),
    print_edges(S).

print_edges(Start) :-
    print_edges(Start, []).

print_edges(Node, Visited) :-
    not(member(Node, Visited)),
    succ(Node, _, Cost, Next),
    printl([Node, "->", Next, ": ", Cost]),
    print_edges(Next, [Node|Visited]).
