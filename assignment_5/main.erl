% Team: Tyler Yang, Fnu Chaitanya, Justin Su
-module(main).
-import(lists, [foldr/3]).
-compile([export_all]).

server1() -> 
    receive
        halt -> 
            io:format("Server1: Stopping...~n"), 
            server2 ! halt;
	  % rick -> io:format("Server1: Never gonna give you up~n"), server1();
        update -> 
            io:format("Server1: Updating...~n"),
            main:server1();
        Work -> 
            io:format("Server1: Working...~n"),
            case Work of
                {'add', {X, Y}} -> io:format("Server1: ~w + ~w = ~w~n", [X, Y, X + Y]);
                {'sub', {X, Y}} -> io:format("Server1: ~w - ~w = ~w~n", [X, Y, X - Y]);
                {mult, {X, Y}} -> io:format("Server1: ~w * ~w = ~w~n", [X, Y, X * Y]);
                {'div', {X, Y}} -> 
                    if Y =:= 0 -> 
                        io:format("Server1: Division by zero error~n");
                    true -> 
                        io:format("Server1: ~w / ~w = ~w~n", [X, Y, X / Y])
                    end;
                {'sqrt', X} -> io:format("Server1: sqrt(~w) = ~w~n", [X, math:sqrt(X)]);
                {'neg', X} -> io:format("Server1: -(~w) = ~w~n", [X, X * -1]);
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
	  % rick2 -> io:format("Server2: Never gonna let you down~n"), server2();
        halt -> io:format("Server2: Stopping...~n"), server3 ! halt;
        update -> 
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
	  % rick3 -> io:format("Server3: Never gonna run around and desert you ~n"), server3();
        halt -> 
            io:format("Server3: Stopping...~n"), 
            io:format("Total Non Handled Count: ~w~n", [FailCount]);
        update -> 
            io:format("Server3: Updating...~n"),
            main:server3(FailCount);  
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
    case whereis(server1) of
        undefined -> 
            Pid1 = spawn(main, server1, []),
            register(server1, Pid1);
        _ -> 
            ok % Server1 already running
    end,

    case whereis(server2) of
        undefined -> 
            Pid2 = spawn(main, server2, []),
            register(server2, Pid2);
        _ -> 
            ok % Server2 already running
    end,

    case whereis(server3) of
        undefined -> 
            Pid3 = spawn(main, server3, []),
            register(server3, Pid3);
        _ -> 
            ok % Server3 already running
    end,

    main().

get_numData() ->
    {ok, Work} = io:read("Enter a command: "),
    case Work of
        halt -> server1 ! halt;  
        _ -> Work  % Otherwise return the input
    end.

main() -> 
    case get_numData() of 
	  all_done -> 
		 ok;
        Work -> 
            server1 ! Work, 
            main()
    end.
