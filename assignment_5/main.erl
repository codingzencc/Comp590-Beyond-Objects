-module(main).
-import(lists, [foldr/3]).
-export([start/0]).
-export([server1/0, server2/0, server3/0, server3/1]).
-export([sum_integers/2, product_integers/2]).


server1() -> 
    receive 
        halt -> io:format("Server1: Stopping...~n"), server2 ! halt;
        updateServer1 -> 
            io:format("Server1: Updating...~n"),
            main:server1();
        Work -> 
            io:format("Server1: Working...~n"),
            case Work of
                {add, {X, Y}} -> io:format("Server1: ~w~n", [X + Y]);
                {sub, {X, Y}} -> io:format("Server1: ~w~n", [X - Y]);
                {mult, {X, Y}} -> io:format("Server1: ~w~n", [X * Y]);
                {'div', {X, Y}} -> io:format("Server1: ~w~n", [X / Y]);
                {sqrt, X} -> io:format("Server1: ~w~n", [math:sqrt(X)]);
                {neg, X} -> io:format("Server1: ~w~n", [X * -1]);
                _ -> server2 ! Work
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
        updateServer2 -> 
            io:format("Server2: Updating...~n"),
            main:server2();
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
        halt -> io:format("Server3: Stopping...~n"), io:format("Total Non Handled Count: ~w~n", [FailCount]);
        updateServer3 -> 
            io:format("Server3: Updating...~n"),
            main:server3(FailCount);
        Work -> 
            io:format("Server3: Working...~n"),
            case Work of 
                {error, Error} -> 
                    io:format("Server3: ~s~n", [Error]),
                    server3(FailCount);
                {_, Error} -> 
                    io:format("Server3: Not Handled, Error: ~s~n", [Error]),
                    server3(FailCount + 1)
            end
    end.

server3() -> 
    server3(0).

start() -> 
    Pid1 = spawn(main, server1, []),
    Pid2 = spawn(main, server2, []),
    Pid3 = spawn(main, server3, []),
    register(server1, Pid1),
    register(server2, Pid2),
    register(server3, Pid3),
    Pid1 ! {add, {1, 2}},
    Pid1 ! {sub, {3, 4}},
    Pid1 ! [1,2,3,4],
    Pid1 ! {error, "Error!"},
    Pid1 ! {unhandled, "unhandled"},
    main().

get_numData() ->
    {ok, Work} = io:read("Enter a command: "),
    Work.

main() -> 
    case get_numData() of 
        all_done -> server1 ! halt;
        Work -> server1 ! Work, main()
    end.