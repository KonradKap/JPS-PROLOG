:- ensure_loaded(utility).

start_A_star(PathCost, Graph) :-
    ensure_loaded(Graph),
    start(S),
    p_start_A_star(S, PathCost).

p_start_A_star(InitState, PathCost) :-
    score(InitState, 0, 0, InitCost, InitScore),
    search_A_star([node(InitState, nil, nil, InitCost, InitScore)], [], PathCost).

search_A_star(Queue, ClosedSet, PathCost) :-
    fetch(Node, Queue, ClosedSet, RestQueue),
    continue(Node, RestQueue, ClosedSet, PathCost).

continue(node(State, Action, Parent, Cost, _), _, ClosedSet, path_cost(Path, Cost)) :-
    goal(State), !,
    build_path(node(Parent, _, _, _, _), ClosedSet, [Action/State], Path).

continue(Node, RestQueue, ClosedSet, Path) :-
    write("Expanding: "), print_node(Node),
    expand(Node, NewNodes),
    insert_new_nodes(NewNodes, RestQueue, NewQueue),
    search_A_star(NewQueue, [Node|ClosedSet], Path).

fetch(Node, Queue, ClosedSet, RestQueue) :-
    shown_queue_size(Size),
    print_top_n(Queue, Size, print_node, ClosedSet, ActualSize),
    read_bounded(0, ActualSize, Read),
    remove_nth(Queue, Read, ClosedSet, RestQueue, Node).

print_top_n(List, N, PrintFunction, ClosedSet, ActualSize) :-
    p_print_top_n(List, N, 0, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([node(State, Action, Parent, Cost, Score)|List], N, I, PrintFunction, ClosedSet, ActualSize) :-
    not(member(node(State, _, _, _, _), ClosedSet)),
    I < N,
    write(I), write(": "),
    call(PrintFunction, node(State, Action, Parent, Cost, Score)),
    NewIndex is I + 1,
    p_print_top_n(List, N, NewIndex, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([_|List], N, I, PrintFunction, ClosedSet, ActualSize) :-
    p_print_top_n(List, N, I, PrintFunction, ClosedSet, ActualSize).

p_print_top_n([], _, I, _, _, I).

p_print_top_n(_, N, N, _, _, N).

remove_nth(List, Index, ClosedSet, RetList, Deleted) :-
    p_remove_nth(List, Index, 0, ClosedSet, RetList, Deleted).

p_remove_nth([], _, _, _, [], _).

p_remove_nth([node(State, Action, Parent, Cost, Score)|List], Index,
             Current,
             ClosedSet,
             [node(State, Action, Parent, Cost, Score)|RetList],
             Deleted) :-
    member(node(State, _, _, _, _), ClosedSet),
    p_remove_nth(List, Index, Current, ClosedSet, RetList, Deleted).

p_remove_nth([Elem|List], Index, Current, ClosedSet, [Elem|RetList], Deleted) :-
    Index \= Current,
    NewCurrent is Current + 1,
    p_remove_nth(List, Index, NewCurrent, ClosedSet, RetList, Deleted).

p_remove_nth([Elem|List], Index, Index, ClosedSet, RetList, Elem) :-
    NewCurrent is Index + 1,
    p_remove_nth(List, Index, NewCurrent, ClosedSet, RetList, Elem).

expand(node(State, _, _, Cost, _), NewNodes) :-
    findall(node(ChildState, Action, State, NewCost, ChildScore),
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

insert_p_queue(node(State, Action, Parent, Cost, FScore),
        [node(State1, Action1, Parent1, Cost1, FScore1)|RestQueue],
        [node(State1, Action1, Parent1, Cost1, FScore1)|Rest1]) :-
    FScore >= FScore1, !,
    insert_p_queue(node(State, Action, Parent, Cost, FScore), RestQueue, Rest1).

insert_p_queue(node(State, Action, Parent, Cost, FScore), Queue,
        [node(State, Action, Parent, Cost, FScore)|Queue]).

build_path(node(nil, _, _, _, _ ), _, Path, Path) :-
    !.

build_path(node(EndState, _, _, _, _), Nodes, PartialPath, Path) :-
    del(Nodes, node(EndState, Action, Parent , _ , _  ), Nodes1),
    build_path(node(Parent,_ ,_ , _ , _ ), Nodes1, [Action/EndState|PartialPath],Path).

del([X|R], X, R).

del([Y|R], X, [Y|R1]) :-
    X \= Y,
    del(R, X, R1).
