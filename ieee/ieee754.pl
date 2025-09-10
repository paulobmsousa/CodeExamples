:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(readutil)).  % for read_line_to_codes/2
:- use_module(library(clpfd)).     % for bitwise ops

% --- Convert float to IEEE-754 binary string ---
ieee754_to_bin(Float, BinStr) :-
    % Get the 4 bytes representing the float32 in big-endian order
    float32_codes(Float, Codes),  % SWI-Prolog built-in
    phrase(bytes_to_bits(Codes), Bits),
    atom_chars(BinStr, Bits).

% --- Convert IEEE-754 binary string to float ---
bin_to_ieee754(BinStr, Float) :-
    atom_chars(BinStr, Bits),
    length(Bits, 32) -> true ; throw(error(domain_error(length_32_bits, BinStr), _)),
    phrase(bits_to_bytes(Bits), Codes),
    float32_codes(Float, Codes).

% --- DCG: bytes to bits ---
bytes_to_bits([])     --> [].
bytes_to_bits([B|Bs]) -->
    { findall(BitChar,
              (between(7,0,I),
               (B >> I) /\ 1 =:= 1 -> BitChar = '1' ; BitChar = '0'),
              BitList)
    },
    BitList,
    bytes_to_bits(Bs).

% --- DCG: bits to bytes ---
bits_to_bytes([])     --> [].
bits_to_bytes(Bits)   -->
    { length(ByteBits, 8),
      append(ByteBits, Rest, Bits),
      bits_to_byte(ByteBits, Byte)
    },
    [Byte],
    bits_to_bytes(Rest).

bits_to_byte(Bits, Byte) :-
    foldl(bit_accumulate, Bits, 0, Byte).

bit_accumulate('1', Acc, Out) :- Out #= (Acc << 1) \/ 1.
bit_accumulate('0', Acc, Out) :- Out #= (Acc << 1) \/ 0.

% --- Main predicate ---
main :-
    current_prolog_flag(argv, Argv),
    ( Argv = [Arg] ->
        atom_number(Arg, Float),
        ieee754_to_bin(Float, BinStr),
        format("IEEE-754 binary of ~6f: ~s~n", [Float, BinStr]),
        bin_to_ieee754(BinStr, Recovered),
        format("Recovered float from binary: ~6f~n", [Recovered])
    ; format("Usage: swipl -q -f script.pl -- <float_number>~n", [])
    ).

:- initialization(main, main).
