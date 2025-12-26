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
cho_map(15, "k").  % ㅋ
cho_map(16, "t").  % ㅌ
cho_map(17, "p").  % ㅍ
cho_map(18, "h").  % ㅎ

jong_map(1, "g").
jong_map(4, "n").
jong_map(7, "d").
jong_map(8, "l").
jong_map(16, "m").
jong_map(17, "b").
jong_map(19, "s").
jong_map(21, "ng").
jong_map(22, "j").

translate([]) --> [].
translate([C|Cs]) -->
    { char_code(C, Code),
      Code >= 44032, Code =< 55203 },
    !,
    { 
        Base is Code - 44032,
        ChoIdx is Base // 588,
        JungIdx is (Base mod 588) // 28,
        JongIdx is Base mod 28
    },
    emit(ChoIdx, cho_map),
    emit(JungIdx, vowel_map),
    emit(JongIdx, jong_map),
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
