-module(main).
-export([p1/0]).
-export([p2/0]).

p1() ->
    match_numData(get_numData()).

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

p2() -> 
    case get_numData() of 
        0 -> match_numData(0);
        Num -> match_numData(Num), p2()
    end.