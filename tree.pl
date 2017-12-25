%just a tree graph up to 2nd level (4 leaves) to see if ordering is right.
:- style_check(-singleton).

start(s).
goal(t).

hScore(s, 6).
hScore(a, 5).
hScore(b, 3).
hScore(aa, 8).
hScore(ab, 3).
hScore(t, 0).
hScore(bb, 5).

succ(s, s_a, 4, a).
succ(s, s_b, 3, b).
succ(a, a_aa, 4, aa).
succ(a, a_ab, 3, ab).
succ(b, b_t, 3, t).
succ(b, b_bb, 4, bb).
