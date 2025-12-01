#!/usr/bin/env escript
%% -*- erlang -*-
%%! -smp enable -sname factorial -mnesia debug verbose

main([Filename, TargetString]) ->
    case file:read_file(Filename) of
        {ok, Binary} ->
            Matrix = convert_to_matrix(Binary),
            IndexSequence = lists:seq(1, length(Matrix)),
            io:format("Target String: ~p~n", [TargetString]),
            Idices = [{X, Y} || X <- IndexSequence, Y <- IndexSequence],
            io:format("Idices: ~p~n", [Idices]),

            % /Users/greg/Documents/advent-of-code-2024/test_4_3.txt 
            io:format("Diagonal NE: ~p~n", [get_diagonal_ne(2, 2, Matrix)]),
            io:format("Diagonal SE: ~p~n", [get_diagonal_se(2, 2, Matrix)]),
            io:format("Diagonal SW: ~p~n", [get_diagonal_sw(2, 2, Matrix)]),
             io:format("Diagonal NW: ~p~n", [get_diagonal_nw(10, 10, Matrix)]),
            % io:format("Column: ~p~n", [get_column(1, 1, Matrix, positive)]),
            % io:format("Row: ~p~n", [get_row(1, 1, Matrix, positive)]),
            
            % use anonymous func to eliminate need for adding Matrix to every tuple - equivalent to [ some expression using Foo || Foo <- someList ]
            io:format("Sum: ~p~n", 
                [lists:sum(lists:map(fun (Tup) -> check_index(Tup, Matrix, TargetString) end, Idices))]
            );
        {error, Reason} ->
            io:format("Failed to read file: ~p~n", [Reason])
    end;
main(_) ->
    io:format("Usage: ./4.erl <filename> <target-string>~n").

convert_to_matrix(Binary) ->
    Lines = string:split(binary_to_list(Binary), "\n", all),
    % noticed that split created trailing empty str...
    [Line || Line <- Lines, Line =/= ""].

% guard sequence of guard expressions using semicolons to guard for one truthy expression (or)

check_index({RowN, ColN}, Matrix, TargetString) ->
% io:format("made it here 1"),

io:format("Index: ~p~n", [{RowN, ColN}]),
% io:format("Letter: ~s~n", [get_element(RowN, ColN, Matrix)]),
     case get_element(RowN, ColN, Matrix) ==  $X of
        true -> lists:sum([check_direction(TargetString, RowN, ColN, Matrix, Direction) ||  Direction <- lists:seq(0,7)]);
        false -> 0
     end.

check_direction(TargetString, RowN, ColN, Matrix, 0) -> 
    Result = check_string(TargetString, string:slice(get_column(RowN, ColN, Matrix, negative),0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, Result, 0]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 1) -> 
    Result = check_string(TargetString, string:slice(get_diagonal_ne(RowN, ColN, Matrix), 0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 1, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 2) -> 
    Result = check_string(TargetString, string:slice(get_row(RowN, ColN, Matrix, positive),0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 2, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 3) -> 
    Result = check_string(TargetString, string:slice(get_diagonal_se(RowN, ColN, Matrix), 0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 3, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 4) -> 
    Result = check_string(TargetString, string:slice(get_column(RowN, ColN, Matrix, positive), 0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 4, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 5) -> 
    Result = check_string(TargetString, string:slice(get_diagonal_sw(RowN, ColN, Matrix), 0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 5, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 6) -> 
    Result = check_string(TargetString, string:slice(get_row(RowN, ColN, Matrix, negative),0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 6, Result]),
    Result;
check_direction(TargetString, RowN, ColN, Matrix, 7) -> 
    Result = check_string(TargetString, string:slice(get_diagonal_nw(RowN, ColN, Matrix), 0, length(TargetString))),
    io:format("~p,~p,~p=~p~n", [RowN, ColN, 7, Result]),
    Result.

check_string(TargetString, String) when TargetString =:= String ->
io:format("checking '~s' == '~s'~n", [TargetString, String]), 1;
check_string(TargetString, String) when TargetString /= String ->
io:format("checking '~s' /= '~s'~n", [TargetString, String]), 0.

get_element(RowN, ColN, Matrix) when RowN < 1; RowN > length(Matrix); ColN < 1 ->
    nil;
get_element(RowN, ColN, Matrix) ->
    Row = lists:nth(RowN, Matrix),
    case ColN > length(Row) of
        true -> nil;
        false -> lists:nth(ColN, Row)
    end.

remove_nil([]) -> [];
remove_nil([H|T]) when H == nil -> remove_nil(T);
% /= is a new one for me...
remove_nil([H|T]) when H /= nil -> [H|remove_nil(T)].


% negative is up
get_column(RowN, ColN, Matrix, negative) ->
    lists:reverse(
        string:slice(
            [lists:nth(ColN, Row) || Row <- Matrix],
            0,
            RowN
        )
    );

% positive is down
get_column(RowN, ColN, Matrix, positive) ->
    string:slice(
        [lists:nth(ColN, Row) || Row <- Matrix],
        RowN-1,
        length(Matrix)
    ).

% backwards means negative...
get_row(RowN, ColN, Matrix, negative) ->
    lists:reverse(
        string:slice(
            lists:nth(RowN, Matrix),
            0,
            ColN
        )
    );
get_row(RowN, ColN, Matrix, positive) ->
    Row = lists:nth(RowN, Matrix),
    string:slice(
        Row,
        ColN-1,
        string:length(Row)
    ).


get_diagonal_ne(RowN, ColN, Matrix) ->
    remove_nil([get_element(RowN - Delta, ColN + Delta, Matrix) || Delta <- lists:seq(0, length(Matrix))]).
get_diagonal_se(RowN, ColN, Matrix) ->
    remove_nil([get_element(RowN + Delta, ColN + Delta, Matrix) || Delta <- lists:seq(0, length(Matrix))]).
get_diagonal_sw(RowN, ColN, Matrix) ->
    remove_nil([get_element(RowN + Delta, ColN - Delta, Matrix) || Delta <- lists:seq(0, length(Matrix))]).
get_diagonal_nw(RowN, ColN, Matrix) ->
    remove_nil([get_element(RowN - Delta, ColN - Delta, Matrix) || Delta <- lists:seq(0, length(Matrix))]).
%get_diagonal(RowN, ColN, Matrix) ->
%    remove_nil([get_element(ColN + Delta, RowN - Delta, Matrix) || Delta <- lists:seq(-length(Matrix), length(Matrix))]).
