:- ensure_loaded(utility).

a_star(PathCost, Graph, NMin, NMax):-
    NMin < NMax,
    write("Running with steps number: "), write(NMin), nl,
    start_A_star(PathCost, Graph, NMin),
    write("Path found!").

a_star(PathCost, Graph, NMin, NMax):-
    NMin < NMax,
    write("Incremetn NMin"), nl,
    incr(NMin, NMin1),
    a_star(PathCost, Graph, NMin1, NMax).

a_star(_, _, NMax, NMax):-
    write("Max steps count reached!"), nl, fail.

start_A_star(PathCost, Graph, N) :-
    ensure_loaded(Graph),
    start(S),
    p_start_A_star(S, PathCost, N).

p_start_A_star(InitState, PathCost, N) :-
    score(InitState, 0, 0, InitCost, InitScore),
    search_A_star([node(InitState, nil, nil, InitCost, InitScore, 0)], [], PathCost, N).

search_A_star([Head|Queue], ClosedSet, PathCost, N) :-
    fetch(Node, [Head|Queue], ClosedSet, RestQueue),
    continue(Node, RestQueue, ClosedSet, PathCost, N).

continue(node(State, Action, Parent, Cost, _, _), _, ClosedSet, path_cost(Path, Cost), _) :-
    goal(State), !,
    build_path(node(Parent, _, _, _, _, _), ClosedSet, [Action/State], Path).

continue(node(State, Action, Parent, Cost, Score, Steps), RestQueue, ClosedSet, Path, N) :-
    Steps<N,
    write("Expanding: "), print_node(node(State, Action, Parent, Cost, Score, Steps)),
    expand(node(State, Action, Parent, Cost, Score, Steps), NewNodes),
    insert_new_nodes(NewNodes, RestQueue, NewQueue),
    search_A_star(NewQueue, [node(State, Action, Parent, Cost, Score, Steps)|ClosedSet], Path, N).

continue(Node, [Head|RestQueue], ClosedSet, Path, N) :-
    search_A_star([Head|RestQueue], [Node|ClosedSet], Path, N).

fetch(Node, Queue, ClosedSet, RestQueue) :-
    shown_queue_size(Size),
    print_top_n(Queue, Size, print_node, ClosedSet, ActualSize),
    ActualSize>0,
    read_bounded(0, ActualSize, Read),
    remove_nth(Queue, Read, ClosedSet, RestQueue, Node).

print_top_n(List, N, PrintFunction, ClosedSet, ActualSize) :-
    p_print_top_n(List, N, 0, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([node(State, Action, Parent, Cost, Score, Steps)|List], N, I, PrintFunction, ClosedSet, ActualSize) :-
    not(member(node(State, _, _, _, _, _), ClosedSet)),
    I < N,
    write(I), write(": "),
    call(PrintFunction, node(State, Action, Parent, Cost, Score, Steps)),
    NewIndex is I + 1,
    p_print_top_n(List, N, NewIndex, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([node(State, _, _, _, _, _)|List], N, I, PrintFunction, ClosedSet, ActualSize) :-
    member(node(State, _, _, _, _, _), ClosedSet),    
    p_print_top_n(List, N, I, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([], _, I, _, _, I).

p_print_top_n(_, N, N, _, _, N).

remove_nth(List, Index, ClosedSet, RetList, Deleted) :-
    p_remove_nth(List, Index, 0, ClosedSet, RetList, Deleted).

p_remove_nth([], _, _, _, [], _).

p_remove_nth([node(State, Action, Parent, Cost, Score, Steps)|List], Index,
             Current,
             ClosedSet,
             [node(State, Action, Parent, Cost, Score, Steps)|RetList],
             Deleted) :-
    member(node(State, _, _, _, _, _), ClosedSet),
    p_remove_nth(List, Index, Current, ClosedSet, RetList, Deleted).

p_remove_nth([Elem|List], Index, Current, ClosedSet, [Elem|RetList], Deleted) :-
    Index \= Current,
    NewCurrent is Current + 1,
    p_remove_nth(List, Index, NewCurrent, ClosedSet, RetList, Deleted).

p_remove_nth([Elem|List], Index, Index, ClosedSet, RetList, Elem) :-
    NewCurrent is Index + 1,
    p_remove_nth(List, Index, NewCurrent, ClosedSet, RetList, Elem).

expand(node(State, _, _, Cost, _, Steps), NewNodes) :-
    NewSteps is Steps+1,
    findall(node(ChildState, Action, State, NewCost, ChildScore, NewSteps),
            (succ(State, Action, StepCost, ChildState),
             score(ChildState, Cost, StepCost, NewCost, ChildScore)), NewNodes), !.

score(State, ParentCost, StepCost, Cost, FScore) :-
    Cost is ParentCost + StepCost,
    hScore(State, HScore),
    FScore is Cost + HScore.

insert_new_nodes([], Queue, Queue).

insert_new_nodes([Node|RestNodes], Queue, NewQueue) :-
    insert_p_queue(Node, Queue, Queue1),
    insert_new_nodes(RestNodes, Queue1, NewQueue).

insert_p_queue(Node, [], [Node]) :-
    !.

insert_p_queue(node(State, Action, Parent, Cost, FScore, Steps),
        [node(State1, Action1, Parent1, Cost1, FScore1, Steps1)|RestQueue],
        [node(State1, Action1, Parent1, Cost1, FScore1, Steps1)|Rest1]) :-
    FScore >= FScore1, !,
    insert_p_queue(node(State, Action, Parent, Cost, FScore, Steps), RestQueue, Rest1).

insert_p_queue(node(State, Action, Parent, Cost, FScore, Steps), Queue,
        [node(State, Action, Parent, Cost, FScore, Steps)|Queue]).

build_path(node(nil, _, _, _, _, _), _, Path, Path) :-
    !.

build_path(node(EndState, _, _, _, _, _), Nodes, PartialPath, Path) :-
    del(Nodes, node(EndState, Action, Parent , _ , _, _), Nodes1),
    build_path(node(Parent,_ ,_ , _ , _, _), Nodes1, [Action/EndState|PartialPath],Path).

del([X|R], X, R).

del([Y|R], X, [Y|R1]) :-
    X \= Y,
    del(R, X, R1).


incr(X, Y):-
    Y is X+1.
decr(X, Y):-
    Y is X-1.