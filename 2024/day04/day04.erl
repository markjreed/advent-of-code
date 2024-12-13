#!/usr/bin/env escript
main([]) -> throw(io:format("Usage: ~s filename~n", [escript:script_name()]));
main([FileName]) -> 
    Puzzle = load(FileName),
    Height = length(Puzzle),
    Width = length(lists:nth(1,Puzzle)),
    XMAS = lists:sum(
        lists:map(
            fun(I) -> lists:sum(
                lists:map(fun(J) -> count_xmas(I,J,Puzzle,Height,Width) end, 
                          lists:seq(1, Width)))
            end, lists:seq(1, Height))),
    X_MAS = lists:sum(
        lists:map(
            fun(I) -> lists:sum(
                lists:map(fun(J) -> count_x_mas(I,J,Puzzle,Height,Width) end, 
                          lists:seq(1, Width)))
            end, lists:seq(1, Height))),
    io:format("~p~n", [XMAS]),
    io:format("~p~n", [X_MAS]).

% load file as a list of strings
load(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try readlines(Device)
      after file:close(Device)
    end.

% recursive helper to read list of lines from already-open file
% note: chops newline off the end of each line
readlines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> [lists:droplast(Line) | readlines(Device)]
    end.

% shorthand for 2D indexing
cell(I, J, Puzzle) -> lists:nth(J, lists:nth(I, Puzzle)).

% the heart of the problem - count all the ways you can spell
% 'XMAS' starting at this location. Passing the height and width
% in saves recomputing them and lets us use them in guards. e.g.
count_xmas(I, J, _, Height, Width) 
    when (I < 1) or (I > Height) or (J < 1) or (J > Width) -> 0;

% if the cell is not an X, return 0. otherwise, add up the
% results of trying to spell XMAS in all 8 directions
count_xmas(I, J, Puzzle, Height, Width) ->
    case cell(I, J, Puzzle) of
        $X -> lists:sum(
            lists:map(fun(D) -> says_xmas(I,J,Puzzle,Height,Width,D) end,
                      lists:seq(0,7)));
         _ -> 0
    end.

% given coordinates and a direction, try to spell XMAS in that
% direction starting at those coordinates
says_xmas(I, J, Puzzle, Height, Width, D) ->
    {DI, DJ} = get_direction(D), 
    says_mas(I+DI, J+DJ, Puzzle, Height, Width, DI, DJ).

% convert a direction number to a pair of coordinate deltas
get_direction(0) -> {-1,  0}; % north
get_direction(1) -> {-1,  1}; % northeast
get_direction(2) -> { 0,  1}; % east
get_direction(3) -> { 1,  1}; % southeast
get_direction(4) -> { 1,  0}; % south
get_direction(5) -> { 1, -1}; % southwest
get_direction(6) -> { 0, -1}; % west
get_direction(7) -> {-1, -1}. % northwest

% check for MAS at given coordinates with given direction deltas
says_mas(I, _, _, _, _, DI, _) when I + 2 * DI < 1 -> 0;
says_mas(I, _, _, Height, _, DI, _) when I + 2 * DI > Height -> 0;
says_mas(_, J, _, _, _, _, DJ) when J + 2 * DJ < 1 -> 0;
says_mas(_, J, _, _, Width, _, DJ) when J + 2 * DJ > Width -> 0;
says_mas(I, J, Puzzle, _, _, DI, DJ) ->
    case cell(I, J, Puzzle) of
        $M -> says_as(I + DI, J + DJ, Puzzle, DI, DJ);
        _ -> 0
    end.

says_as(I, J, Puzzle, DI, DJ) ->
    case cell(I, J, Puzzle) of
        $A -> is_s(I + DI, J + DJ, Puzzle);
        _ -> 0
    end.

is_s(I, J, Puzzle) ->
    case cell(I, J, Puzzle) of
        $S -> 1;
        _ -> 0
    end.

% part 2 - count X-MAS
count_x_mas(I, J, _, Height, Width) 
    when (I < 2) or (I > Height - 1) or (J < 2) or (J > Width - 1) -> 0;

% if the cell is not an A, return 0. otherwise, add up the
% results of trying to find all four ways of making two intersecting
% diagonal MAS:
%     M M   M S   S M  S S
%      A     A     A    A
%     S S   M S   M S  M M
count_x_mas(I, J, Puzzle, _, _) ->
    case cell(I, J, Puzzle) of
        $A -> try_x_mas(I, J, Puzzle);
        _ -> 0
    end.

try_x_mas(I, J, Puzzle) ->
    UL = cell(I-1,J-1,Puzzle),
    UR = cell(I-1,J+1,Puzzle),
    LL = cell(I+1,J-1,Puzzle),
    LR = cell(I+1,J+1,Puzzle),
    Positive = [LL|[$A|[UR]]],
    Negative = [UL|[$A|[LR]]],
    case (string:equal(Positive, "MAS") or string:equal(Positive,"SAM")) and
         (string:equal(Negative, "MAS") or string:equal(Negative,"SAM")) of
        true -> 1;
        false -> 0
    end.
