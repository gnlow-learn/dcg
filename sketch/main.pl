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

sentence_ko_sov(s(decl, active, past, pred(V, agent(S, SD), obj(O, OD)))) -->
    noun_phrase(ko, S, SD, josa_subj), " ",
    noun_phrase(ko, O, OD, josa_obj), " ",
    verb(ko, V, past).

sentence_ko_osv(s(decl, active, past, pred(V, agent(S, SD), obj(O, OD)))) -->
    noun_phrase(ko, O, OD, josa_obj), " ",
    noun_phrase(ko, S, SD, josa_subj), " ",
    verb(ko, V, past).

noun_phrase(ko, N, _, JosaType) -->
    noun(ko, N),
    { phrase(noun(ko, N), NStr) },
    josa(NStr, JosaType).

noun(ko, butterfly) --> "나비".
noun(ko, flower)    --> "꽃".

verb(ko, see, past) --> "보았다".

josa(NStr, josa_subj) --> { has_jongseong(NStr) }, !, "이".
josa(_, josa_subj)    --> "가".
josa(NStr, josa_obj)  --> { has_jongseong(NStr) }, !, "을".
josa(_, josa_obj)     --> "를".

% === en ===

char_upper(L, U) :-
    once((char_code(L, C), C >= 97, C =< 122, U_code is C - 32, char_code(U, U_code); U = L)).

sentence(en, IR) -->
    { var(IR) }, !,
    en_core(IR).
sentence(en, IR) -->
    { nonvar(IR), phrase(en_core(IR), [First|Rest]) },
    { char_upper(First, Upper) },
    [Upper], Rest.

en_core(s(decl, active, T, pred(V, agent(S, SD), obj(O, OD)))) -->
    { var(SD) -> SD = a ; true },
    { var(OD) -> OD = a ; true },
    article(en, SD), " ", noun(en, S), " ",
    verb(en, V, T), " ",
    article(en, OD), " ", noun(en, O).

noun(en, butterfly) --> "butterfly".
noun(en, flower)    --> "flower".

verb(en, see, past) --> "saw".

article(en, a) --> "a".
article(en, the) --> "the".
