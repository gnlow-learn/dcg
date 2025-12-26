:- use_module(library(dcgs)).

char_upper(L, U) :-
    once((char_code(L, C), C >= 97, C =< 122, U_code is C - 32, char_code(U, U_code); U = L)).

% ===

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
    josa(N, JosaType).

noun(ko, butterfly) --> "나비".
noun(ko, flower)    --> "꽃".

verb(ko, see, past) --> "보았다".

josa(butterfly, josa_subj) --> "가".
josa(flower, josa_subj)    --> "이".
josa(butterfly, josa_obj)  --> "를".
josa(flower, josa_obj)     --> "을".

% ===

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
