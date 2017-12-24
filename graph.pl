%                E[3]
%              4^
%              /
%      6.-->T[0]
%      /      ^
%   D[5]<..2  |4
%          ''C[4]<,
%             |    \4
%             |6    '>       ....>B[3]
%             v   ..>A[8]'''8
%           S[10]''10
:- style_check(-singleton).

start(s).
goal(t).

%hScore(identifier, straight_line_distance_to_t)
%These are edges actually
hScore(s, 10).
hScore(a, 8).
hScore(b, 3).
hScore(c, 4).
hScore(d, 5).
hScore(t, 0).
hScore(e, 3).

%succ(from, Action (???), cost, to)
%where succ really means edge, just for the sake of complying to examples
succ(s, sa, 10, a).
succ(a, ab, 8, b).
succ(a, ac, 4, c).
succ(c, ca, 4, a). %this edge creates cycle in the graph, comment if you can't handle it
succ(c, cs, 6, s). %this edge creates cycle in the graph, comment if you can't handle it
succ(c, cd, 2, d).
succ(c, ct, 4, t).
succ(d, dt, 6, t).
succ(t, te, 4, e).
