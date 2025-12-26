:- module(romanize, [romanize/2]).

:- use_module(library(dcgs)).

vowel_map(0, "a").  % ㅏ
vowel_map(5, "e").  % ㅔ
vowel_map(20, "i"). % ㅣ
vowel_map(13, "u"). % ㅜ
vowel_map(8, "o").  % ㅗ
vowel_map(18, "").  % ㅡ

cho_map(0, "g").   % ㄱ
cho_map(2, "n").   % ㄴ
cho_map(3, "d").   % ㄷ
cho_map(5, "r").   % ㄹ
cho_map(6, "m").   % ㅁ
cho_map(7, "b").   % ㅂ
cho_map(9, "s").   % ㅅ
cho_map(11, "").   % ㅇ
cho_map(12, "j").  % ㅈ
cho_map(14, "ch"). % ㅊ

translate([]) --> [].
translate([C|Cs]) -->
    { char_code(C, Code),
      Code >= 44032, Code =< 55203 },
    !,
    { 
        Base is Code - 44032,
        ChoIdx is Base // 588,
        JungIdx is (Base mod 588) // 28
    },
    emit(ChoIdx, cho_map),
    emit(JungIdx, vowel_map),
    translate(Cs).
translate([C|Cs]) --> [C], translate(Cs).

emit(Idx, Map) --> 
    { Goal =.. [Map, Idx, Lat], call(Goal) }, 
    !, 
    Lat.
emit(_, _) --> "".

romanize(Input, Output) :-
    phrase(translate(Input), Result),
    atom_chars(Output, Result).
