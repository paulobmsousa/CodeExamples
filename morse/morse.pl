% Morse table facts
morse('A', ".-").     morse('B', "-...").   morse('C', "-.-.").   morse('D', "-..").
morse('E', ".").      morse('F', "..-.").   morse('G', "--.").    morse('H', "....").
morse('I', "..").     morse('J', ".---").   morse('K', "-.-").    morse('L', ".-..").
morse('M', "--").     morse('N', "-.").     morse('O', "---").    morse('P', ".--.").
morse('Q', "--.-").   morse('R', ".-.").    morse('S', "...").    morse('T', "-").
morse('U', "..-").    morse('V', "...-").   morse('W', ".--").    morse('X', "-..-").
morse('Y', "-.--").   morse('Z', "--..").
morse('0', "-----").  morse('1', ".----").  morse('2', "..---").  morse('3', "...--").
morse('4', "....-").  morse('5', ".....").  morse('6', "-....").  morse('7', "--...").
morse('8', "---..").  morse('9', "----.").
morse('.', ".-.-.-"). morse(',', "--..--"). morse('?', "..--.."). morse('\'', ".----.").
morse('!', "-.-.--"). morse('/', "-..-.").  morse('(', "-.--.").  morse(')', "-.--.-").
morse('&', ".-...").  morse(':', "---..."). morse(';', "-.-.-."). morse('=', "-...-").
morse('+', ".-.-.").  morse('-', "-....-"). morse('_', "..--.-"). morse('"', ".-..-.").
morse('$', "...-..-").morse('@', ".--.-."). morse(' ', "/").

% ASCII fallback encoding
ascii_morse(Char, Morse) :-
    char_code(Char, Code),
    Code >= 0, Code =< 127,
    ascii_bits(Code, Bits),
    atom_concat("..--", Bits, Morse).

ascii_bits(Code, Bits) :-
    ascii_bits(Code, 6, "", Bits).

ascii_bits(_, -1, Acc, Acc).
ascii_bits(Code, I, Acc, Bits) :-
    Bit is (Code >> I) /\ 1,
    (Bit =:= 1 -> append_atom(Acc, "-", NewAcc) ; append_atom(Acc, ".", NewAcc)),
    I1 is I - 1,
    ascii_bits(Code, I1, NewAcc, Bits).

append_atom(A, B, C) :- atom_concat(A, B, C).

% Encode a single character
encode_char(Char, Morse) :-
    upcase_atom(Char, Upper),
    (morse(Upper, Morse) -> true ; ascii_morse(Char, Morse)).

% Encode a string
encode_string([], []).
encode_string([Char|Rest], [Morse|EncodedRest]) :-
    encode_char(Char, Morse),
    encode_string(Rest, EncodedRest).

% Decode a Morse symbol
decode_char(Morse, Char) :-
    morse(Char, Morse), !.
decode_char(Morse, Char) :-
    atom_chars(Morse, ['.', '.', '-', '-', |Bits]),
    decode_bits(Bits, 0, Code),
    char_code(Char, Code).

decode_bits([], Val, Val).
decode_bits(['-'|Rest], Acc, Val) :-
    Acc1 is (Acc << 1) + 1,
    decode_bits(Rest, Acc1, Val).
decode_bits(['.'|Rest], Acc, Val) :-
    Acc1 is Acc << 1,
    decode_bits(Rest, Acc1, Val).

% Decode a Morse string
decode_string([], []).
decode_string([Morse|Rest], [Char|DecodedRest]) :-
    decode_char(Morse, Char),
    decode_string(Rest, DecodedRest).

% Utility to convert between strings and char lists
string_to_chars(String, Chars) :- atom_chars(String, Chars).
chars_to_string(Chars, String) :- atom_chars(String, Chars).

% Test runner
run_tests :-
    test("HELLO", "....|.|.-..|.-..|---"),
    test("Test 123!", "TEST 123!"),
    test("\x01", "\x01"),
    test("Address: 154 Pensilville - ON, CA", "ADDRESS: 154 PENSILVILLE - ON, CA").

test(Input, ExpectedOutput) :-
    string_to_chars(Input, Chars),
    encode_string(Chars, MorseList),
    atomic_list_concat(MorseList, '|', MorseAtom),
    atomic_list_concat(MorseList, '|', Encoded),
    split_string(Encoded, "|", "", MorseParts),
    decode_string(MorseParts, DecodedChars),
    chars_to_string(DecodedChars, Decoded),
    (Decoded = ExpectedOutput ->
        format("[PASS] ~w~n", [Input])
    ;
        format("[FAIL] ~w~n  Expected: ~w~n  Actual:   ~w~n", [Input, ExpectedOutput, Decoded])
    ).

% Entry point
:- initialization(main).
main :-
    run_tests,
    write("\nEnter a string to encode in Morse code:\n"),
    read_line_to_string(user_input, Input),
    string_to_chars(Input, Chars),
    encode_string(Chars, MorseList),
    atomic_list_concat(MorseList, '|', MorseAtom),
    format("\nEncoded Morse:\n~w\n", [MorseAtom]),
    split_string(MorseAtom, "|", "", MorseParts),
    decode_string(MorseParts, DecodedChars),
    chars_to_string(DecodedChars, Decoded),
    format("\nDecoded Text:\n~w\n", [Decoded]).
