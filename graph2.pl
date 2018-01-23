%             
%            T[0]
%           
%     
%           C[4]<,
%             |    \4
%             |6    '>       
%             v    ..>A[8]
%           S[10]''10
:- style_check(-singleton).

start(s).
goal(t).

%hScore(identifier, straight_line_distance_to_t)
%These are nodes actually
hScore(s, 10).
hScore(a, 8).
hScore(c, 4).
hScore(t, 0).

%succ(from, Action (???), cost, to)
%where succ really means edge, just for the sake of complying to examples
succ(s, sa, 10, a).
succ(a, ac, 4, c).
succ(c, cs, 6, s). %this edge creates cycle in the graph, comment if you can't handle it
