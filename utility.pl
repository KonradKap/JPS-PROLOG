printl([]) :-
    nl.

printl([Elem|Rest]) :-
    write(Elem),
    printl(Rest).

print_node(node(To, Action, From, CostUntil, CostFull)) :-
    FutureCost is CostFull - CostUntil,
    printl([CostUntil, " {", From, "}--", Action, "->{", To, "} ", FutureCost]).

read_bounded(LowerBound, UpperBound, Read) :-
    read(Read),
    integer(Read),
    Read >= LowerBound,
    Read < UpperBound.
