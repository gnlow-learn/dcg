:- use_module(library(dcgs)).

ko_sentence(s(decl, active, past, pred(V, agent(Subj, det(SubjDet)), obj(Obj, det(ObjDet))))) -->
    article(ko, SubjDet), noun(ko, Subj), " 가 ", 
    article(ko, ObjDet), noun(ko, Obj), " 을 ", 
    verb(ko, V, past).

en_sentence(s(decl, active, past, pred(V, agent(Subj, det(SubjDet)), obj(Obj, det(ObjDet))))) -->
    article(en, SubjDet), " ", noun(en, Subj), " ",
    verb(en, V, past), " ",
    article(en, ObjDet), " ", noun(en, Obj).

noun(ko, butterfly) --> "나비".
noun(ko, flower)    --> "꽃".

noun(en, butterfly) --> "butterfly".
noun(en, flower)    --> "flower".

verb(ko, see, past) --> "보았다".
verb(ko, see, pres) --> "본다".

verb(en, see, past) --> "saw".
verb(en, see, pres) --> "sees".

article(ko, none) --> "".

article(en, a) --> "a".
article(en, a) --> "A".
article(en, the) --> "the".
article(en, the) --> "The".
article(en, none) --> "a".
