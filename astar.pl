:- ensure_loaded(tree).
:- ensure_loaded(utility).

start_A_star(PathCost) :-
    start(S),
    start_A_star(S, PathCost).

start_A_star(InitState, PathCost) :-
    score(InitState, 0, 0, InitCost, InitScore),
    search_A_star([node(InitState, nil, nil, InitCost, InitScore)], [], PathCost).

search_A_star(Queue, ClosedSet, PathCost) :-
    fetch(Node, Queue, ClosedSet, RestQueue),
    continue(Node, RestQueue, ClosedSet, PathCost).

continue(node(State, Action, Parent, Cost, _), _, ClosedSet, path_cost(Path, Cost)) :-
    goal(State), !,
    build_path(node(Parent, _, _, _, _), ClosedSet, [Action/State], Path).

continue(Node, RestQueue, ClosedSet, Path) :-
    expand(Node, NewNodes),
    write("Expanding: "), print_node(Node),
    ask_for_order(NewNodes, Order, print_node), nl,
    reorder(NewNodes, Order, Ordered),
    append(Ordered, RestQueue, NewQueue),
    search_A_star(NewQueue, [Node|ClosedSet], Path).

fetch(node(State, Action, Parent, Cost, Score),
        [node(State, Action, Parent, Cost, Score)|RestQueue], ClosedSet, RestQueue) :-
    not(member(node(State, _, _, _, _), ClosedSet)), !.

fetch(Node, [_|RestQueue], ClosedSet, NewRest) :-
    fetch(Node, RestQueue, ClosedSet , NewRest).

expand(node(State, _, _, Cost, _), NewNodes) :-
    findall(node(ChildState, Action, State, NewCost, ChildScore),
            (succ(State, Action, StepCost, ChildState),
             score(ChildState, Cost, StepCost, NewCost, ChildScore)), NewNodes), !.

score(State, ParentCost, StepCost, Cost, FScore) :-
    Cost is ParentCost + StepCost,
    hScore(State, HScore),
    FScore is Cost + HScore.

build_path(node(nil, _, _, _, _ ), _, Path, Path) :-
    !.

build_path(node(EndState, _, _, _, _), Nodes, PartialPath, Path) :-
    del(Nodes, node(EndState, Action, Parent , _ , _  ), Nodes1),
    build_path(node(Parent,_ ,_ , _ , _ ), Nodes1, [Action/EndState|PartialPath],Path).

del([X|R], X, R).

del([Y|R], X, [Y|R1]) :-
    X \= Y,
    del(R, X, R1).
