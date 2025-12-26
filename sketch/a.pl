:- use_module(library(dcgs)).

ko_sentence(s(decl, active, past, pred(V, agent(Subj, det(none)), obj(Obj, det(none))))) -->
    noun_ko(Subj), " 가 ", 
    noun_ko(Obj), " 을 ", 
    verb_ko(V, past).

noun_ko(butterfly) --> "나비".
noun_ko(flower)    --> "꽃".

verb_ko(see, past) --> "보았다".
verb_ko(see, pres) --> "본다".

en_sentence(s(decl, active, past, pred(V, agent(Subj, det(SubjDet)), obj(Obj, det(ObjDet))))) -->
    article(SubjDet), " ", noun_en(Subj), " ",
    verb_en(V, past), " ",
    article(ObjDet), " ", noun_en(Obj).

article(a) --> "a".
article(a) --> "A".
article(the) --> "the".
article(the) --> "The".
article(none) --> "".

noun_en(butterfly) --> "butterfly".
noun_en(flower)    --> "flower".

verb_en(see, past) --> "saw".
verb_en(see, pres) --> "sees".
