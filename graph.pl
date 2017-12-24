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
town(s, 10).
town(a, 8).
town(b, 3).
town(c, 4).
town(d, 5).
town(t, 0).
town(e, 3).

%succ(from, Action (???), to, cost)
%where succ really means edge, just for the sake of complying to examples
succ(s, sa, a, 10).
succ(a, ab, b, 8).
succ(a, ac, c, 4).
succ(c, ca, a, 4). %this edge creates cycle in the graph, comment if you can't handle it
succ(c, cs, s, 6). %this edge creates cycle in the graph, comment if you can't handle it
succ(c, cd, d, 2).
succ(c, ct, t, 4).
succ(d, dt, t, 6).
succ(t, te, e, 4).
