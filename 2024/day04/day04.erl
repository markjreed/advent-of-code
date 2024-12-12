#!/usr/bin/env escript
nth([],_) -> undefined;
nth([H|_],0) -> H;
nth([_|T],I) -> nth(T,I-1).

cell(M, I, J) -> nth(nth(M, I), J).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> [lists:droplast(Line) | get_all_lines(Device)]
    end.

print_matrix([]) -> io:nl();
print_matrix([H|T]) -> print_row(H),
    print_matrix(T).

print_row([]) -> io:nl();
print_row([H|T]) -> io:format("~c", [H]),
    print_row(T).

count_xmas(Map, Height, Width, I, J) -> 
    Cell = cell(Map, I, J),
    case Cell of
        $X -> lists:sum(
            lists:map(fun(D) -> says_xmas(Map,Height,Width,I,J,D) end,
                      lists:seq(0,7)));
        _ -> 0
    end.

says_xmas(Map, Height, Width, I, J, D) ->
    {DI, DJ} = get_direction(D), 
    says_mas(Map, Height, Width, I+DI, J+DJ, DI, DJ).

get_direction(0) -> {-1,  0};
get_direction(1) -> {-1,  1};
get_direction(2) -> { 0,  1};
get_direction(3) -> { 1,  1};
get_direction(4) -> { 1,  0};
get_direction(5) -> { 1, -1};
get_direction(6) -> { 0, -1};
get_direction(7) -> {-1, -1}.

says_mas(_, _, _, I, _, DI, _) when I + 2 * DI < 0 -> 0;
says_mas(_, Height, _, I, _, DI, _) when I + 2 * DI >= Height -> 0;
says_mas(_, _, _, _, J, _, DJ) when J + 2 * DJ < 0 -> 0;
says_mas(_, _, Width, _, J, _, DJ) when J + 2 * DJ >= Width -> 0;
says_mas(Map, _, _, I, J, DI, DJ) ->
    case cell(Map, I, J) of
        $M -> says_as(Map, I + DI, J +DJ, DI, DJ);
        _ -> 0
    end.

says_as(Map, I, J, DI, DJ) ->
    case cell(Map, I, J) of
        $A -> is_s(Map,  I + DI, J + DJ);
        _ -> 0
    end.

is_s(Map, I, J) ->
    case cell(Map, I, J) of
        $S -> 1;
        _ -> 0
    end.

main([]) -> throw(io:format("Usage: ~s filename~n", [escript:script_name()]));
main([FileName]) -> 
    Map = readlines(FileName),
    print_matrix(Map),
    Height = length(Map),
    Width = length(nth(Map,0)),
    Count = lists:sum(
        lists:map(
            fun(I) -> lists:sum(
                lists:map(fun(J) -> count_xmas(Map,Height,Width,I,J) end, 
                          lists:seq(0, Width - 1)))
            end, lists:seq(0, Height-1))),
    io:format("~p~n", [Count]).
