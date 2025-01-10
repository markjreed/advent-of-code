% defining a reversed form would not normally be necessary given
% pattern-matching, but this form lets it be used with maplist.
string_number(String, Number) :-
    number_string(Number, String).

read_lines(File, Lines) :-
    expects_dialect(sicstus),
    read_line(File, Codes),
    ( 
      Codes == end_of_file -> Lines = [];
      atom_codes(H, Codes),
      Lines = [H | T], 
      read_lines(File, T)
    ).

sum(L, N) :- sum(L, 0, N).
sum([],N,N).
sum([H|T],A,N) :- A1 is A + H, sum(T,A1,N).

min_list([H|T], Min) :- min_list(T, H, Min).

min_list([], Min, Min).
min_list([H|T], Min0, Min) :-
    Min1 is min(H, Min0),
    min_list(T, Min1, Min).

process(Line, Dimensions) :-
    split_string(Line, "x", "", DimensionString),
    maplist(string_number, DimensionString, Unsorted),
    msort(Unsorted, Dimensions).

part1([A,B,C], Total) :- 
    Total is 3 * A * B + 2 * A * C + 2 * B * C.

part2([A,B,C], Total) :- 
    Total is A + A + B + B + A * B * C.

main :-
    current_prolog_flag(argv, [InputFile | _]),
    open(InputFile, read, F),
    read_lines(F, Lines),
    maplist(process, Lines, Boxes),
    maplist(part1, Boxes, Part1Totals),
    sum(Part1Totals, Part1Total),
    writeln(Part1Total),
    maplist(part2, Boxes, Part2Totals),
    sum(Part2Totals, Part2Total),
    writeln(Part2Total),
    halt.
