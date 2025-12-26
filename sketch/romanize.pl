:- module(romanize, [romanize/2]).
:- use_module(library(dcgs)).
:- use_module(library(lists)).

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

jong_map(1, "g").   % ㄱ
jong_map(4, "n").   % ㄴ
jong_map(7, "d").   % ㄷ
jong_map(8, "l").   % ㄹ
jong_map(16, "m").  % ㅁ
jong_map(17, "b").  % ㅂ
jong_map(19, "s").  % ㅅ
jong_map(21, "ng"). % ㅇ
jong_map(22, "j").  % ㅈ

romanize(Input, Output) :-
    (   nonvar(Input)
    ->  phrase(translate_to_eng(Input), Result),
        (   is_list_of_integers(Result) -> atom_codes(Output, Result)
        ;   atom_chars(Output, Result)
        )
    ;   nonvar(Output)
    ->  (   atom(Output) -> atom_codes(Output, RomanList) 
        ;   RomanList = Output 
        ),
        phrase(translate_to_kor(HangulCodes), RomanList),
        atom_codes(Input, HangulCodes)
    ).

is_list_of_integers([]).
is_list_of_integers([H|T]) :- integer(H), is_list_of_integers(T).

translate_to_eng([]) --> [].
translate_to_eng([C|Cs]) -->
    { char_code(C, Code), Code >= 44032, Code =< 55203 },
    !,
    { Base is Code - 44032,
      ChoIdx is Base // 588,
      JungIdx is (Base mod 588) // 28,
      JongIdx is Base mod 28 },
    emit(ChoIdx, cho_map),
    emit(JungIdx, vowel_map),
    emit(JongIdx, jong_map),
    translate_to_eng(Cs).
translate_to_eng([C|Cs]) --> [C], translate_to_eng(Cs).

emit(Idx, Map) --> { Goal =.. [Map, Idx, Lat], call(Goal) }, !, Lat.
emit(_, _) --> "".

translate_to_kor([]) --> [].
translate_to_kor([Code|Cs]) -->
    parse_syllable(Code),
    !,
    translate_to_kor(Cs).
translate_to_kor([C|Cs]) --> [C], translate_to_kor(Cs).

parse_syllable(Code) -->
    get_cho(ChoIdx),
    get_jung(JungIdx),
    % 여기서 "으" (초성 11 + 중성 18) 인 경우를 차단
    { \+ (ChoIdx = 11, JungIdx = 18) },
    get_jong(JongIdx),
    { Code is (ChoIdx * 588) + (JungIdx * 28) + JongIdx + 44032 }.

get_cho(Idx) --> match_map(cho_map, Idx), !.
get_cho(11)  --> [].

get_jung(Idx) --> match_map(vowel_map, Idx), !.
get_jung(18)  --> [].

get_jong(Idx) -->
    match_map(jong_map, Idx),
    (   next_is_vowel -> { fail } ; { true } ),
    !.
get_jong(0) --> [].

next_is_vowel(S, S) :-
    S = [H|_],
    vowel_map(_, [Vh|_]),
    char_code_equal(H, Vh).

char_code_equal(X, X) :- !.
char_code_equal(C, Code) :- integer(Code), char_code(C, Code), !.
char_code_equal(Code, C) :- integer(Code), char_code(C, Code).

match_map(MapName, Idx) -->
    { findall(Len-(Str-I), (
        Goal =.. [MapName, I, Str], 
        call(Goal), 
        Str \= "", 
        length(Str, Len)
      ), Matches),
      keysort(Matches, Sorted),
      reverse(Sorted, Descending) },
    select_match(Descending, Idx).

select_match([_-(Str-Idx)|_], Idx) --> consume_str(Str).
select_match([_|Rest], Idx) --> select_match(Rest, Idx).

consume_str([]) --> [].
consume_str([H|T]) --> [C], { char_code_equal(C, H) }, consume_str(T).
