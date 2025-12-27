:- use_module(romanize).
:- use_module(library(dcgs)).

% === kr ===

has_jongseong(Str) :-
    last(Str, LastChar),
    char_code(LastChar, Code),
    Code >= 44032, Code =< 55203,
    (Code - 44032) mod 28 > 0.

sentence(ko, s(D, V, A, Prop)) --> sentence_ko_sov(s(D, V, A, Prop)).
sentence(ko, s(D, V, A, Prop)) --> sentence_ko_osv(s(D, V, A, Prop)).

sentence_ko_sov(s(decl, active, past, pred(V, agent(S, SD, SA), obj(O, OD, OA)))) -->
    noun_phrase(ko, S, SD, SA, josa_subj), " ",
    noun_phrase(ko, O, OD, OA, josa_obj), " ",
    verb(ko, V, past).

sentence_ko_osv(s(decl, active, past, pred(V, agent(S, SD, SA), obj(O, OD, OA)))) -->
    noun_phrase(ko, O, OD, OA, josa_obj), " ",
    noun_phrase(ko, S, SD, SA, josa_subj), " ",
    verb(ko, V, past).

noun_phrase(ko, N, _, Adj, JosaType) -->
    (   adj(ko, Adj), " "
    ;   { Adj = none }
    ),
    noun(ko, N),
    { phrase(noun(ko, N), NStr) },
    josa(NStr, JosaType).

noun(ko, butterfly) --> "나비".
noun(ko, flower)    --> "꽃".

adj(ko, beautiful)  --> "아름다운".
adj(ko, red)        --> "빨간".

verb(ko, see, past) --> "보았다".

josa(NStr, josa_subj) --> { has_jongseong(NStr) }, !, "이".
josa(_, josa_subj)    --> "가".
josa(NStr, josa_obj)  --> { has_jongseong(NStr) }, !, "을".
josa(_, josa_obj)     --> "를".

% === en ===

char_upper(L, U) :-
    nonvar(L),
    !,
    char_code(L, LC),
    (   LC >= 97, LC =< 122
    ->  UC is LC - 32, char_code(U, UC)
    ;   U = L
    ).
char_upper(L, U) :-
    nonvar(U),
    char_code(U, UC),
    (   UC >= 65, UC =< 90
    ->  LC is UC + 32, char_code(L, LC)
    ;   L = U
    ).

sentence(en, IR) -->
    { var(IR) },
    !,
    [First],
    { char_upper(L, First) },
    { phrase(en_core(IR), [L|Rest]) },
    Rest.
sentence(en, IR) -->
    { nonvar(IR), phrase(en_core(IR), [First|Rest]) },
    { char_upper(First, Upper) },
    [Upper], Rest.

en_core(s(decl, active, T, pred(V, agent(S, SD, SA), obj(O, OD, OA)))) -->
    { var(SD) -> SD = a ; true },
    { var(OD) -> OD = a ; true },
    article(en, SD), " ", 
    (   { SA \= none }, adj(en, SA), " "
    ;   { SA = none }
    ),
    noun(en, S), " ",
    verb(en, V, T), " ",
    article(en, OD), " ", 
    (   { OA \= none }, adj(en, OA), " "
    ;   { OA = none }
    ),
    noun(en, O).

noun(en, butterfly) --> "butterfly".
noun(en, flower)    --> "flower".

adj(en, beautiful)  --> "beautiful".
adj(en, red)        --> "red".

verb(en, see, past) --> "saw".

article(en, a) --> "a".
article(en, the) --> "the".
