% Team: Tyler Yang, Fnu Chaitanya, Justin Su
-module(main).
-import(lists, [foldr/3]).
-export([start/0]).
-export([server1/0, server2/0, server3/0, server3/1]).
-export([sum_integers/2, product_integers/2]).

server1() -> 
    receive 
        halt -> 
            io:format("Server1: Stopping...~n"), 
            server2 ! halt;
        Work -> 
            io:format("Server1: Working...~n"),
            case Work of
                {add, {X, Y}} -> io:format("Server1: ~w + ~w = ~w~n", [X, Y, X + Y]);
                {sub, {X, Y}} -> io:format("Server1: ~w - ~w = ~w~n", [X, Y, X - Y]);
                {mult, {X, Y}} -> io:format("Server1: ~w * ~w = ~w~n", [X, Y, X * Y]);
                {'div', {X, Y}} -> 
                    if Y =:= 0 -> 
                        io:format("Server1: Division by zero error~n");
                    true -> 
                        io:format("Server1: ~w / ~w = ~w~n", [X, Y, X / Y])
                    end;
                {sqrt, X} -> io:format("Server1: sqrt(~w) = ~w~n", [X, math:sqrt(X)]);
                {neg, X} -> io:format("Server1: -(~w) = ~w~n", [X, X * -1]);
                _ -> 
                    server2 ! Work
            end,
            server1()
    end.

sum_integers(X, Acc) -> 
    if is_number(X) -> 
        X + Acc;
    true -> 
        Acc 
    end.

product_integers(X, Acc) -> 
    if is_number(X) -> 
        X * Acc;
    true -> 
        Acc 
    end.

server2() -> 
    receive 
        halt -> io:format("Server2: Stopping...~n"), server3 ! halt;
        Work -> 
            io:format("Server2: Working...~n"),
            case Work of 
                [Head | _] when is_integer(Head) -> 
                    io:format("Server2: ~w~n", [lists:foldr(fun sum_integers/2, 0, Work)]);
                [Head | _] when is_float(Head) -> 
                    io:format("Server2: ~w~n", [lists:foldr(fun product_integers/2, 1, Work)]);
                _ -> server3 ! Work
            end,
            server2()
    end.

server3(FailCount) -> 
    receive 
        halt -> 
            io:format("Server3: Stopping...~n"), 
            io:format("Total Non Handled Count: ~w~n", [FailCount]);
        Work -> 
            io:format("Server3: Working...~n"),
            case Work of 
                {error, Error} -> 
                    io:format("Server3: Error: ~s~n", [Error]),
                    server3(FailCount);
                _ -> 
                    io:format("Server3: Not Handled: ~p~n", [Work]),
                    server3(FailCount + 1)
            end
    end.

server3() -> 
    server3(0).

start() -> 
    Pid1 = spawn(fun server1/0),
    Pid2 = spawn(fun server2/0),
    Pid3 = spawn(fun server3/0),
    register(server1, Pid1),
    register(server2, Pid2),
    register(server3, Pid3),
    main().

get_numData() ->
    {ok, Work} = io:read("Enter a command: "),
    case Work of
        halt -> halt;  % Return 'halt'
        _ -> Work
    end.

main() -> 
    case get_numData() of 
        halt -> server1 ! halt;
        Work -> 
            server1 ! Work, 
            main()
    end.
