% Module: p1
% This module provides a program that takes a number input, checks whether it's a valid number,
% and performs different operations based on the value of the number.

-module(p1).
-export([prog1/0]).

get_numData() ->
    {ok, Num} = io:read("Enter a number: "),
    io:format("The number you entered is: ~w~n", [Num]),
    Num.

match_numData(N) ->
    case is_number(N) of 
        false -> io:format("not an integer~n");
        true -> Var = case N of
                    N when N < 0 -> math:pow(abs(N), 7);
                    N when N == 0 -> 0;
                    N when N rem 7 == 0 -> math:pow(N, 1/5);
                    N when N > 0 -> fact(N)
                end,
                io:format("~w~n", [Var])
    end.

fact(N) when N > 0 -> N * fact(N-1);
fact(0) -> 1.

prog1() ->
    match_numData(get_numData()).
