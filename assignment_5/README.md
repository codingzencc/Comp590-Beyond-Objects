# Assignment 5: Hotswapping
Team members: Tyler Yang, Justin Su, Fnu Chaitanya

Example run:

```erl
10> c(main).
main.erl:4:2: Warning: export_all flag enabled - all functions will be exported
%    4| -compile([export_all]).
%     |  ^

{ok,main}
11> main:start().
Enter a command: rick.
Server1: Working...
Server2: Working...
Server3: Working...
Server3: Not Handled: rick
Enter a command: rick2.
Server1: Working...
Server2: Working...
Server3: Working...
Server3: Not Handled: rick2
Enter a command: rick3.
Server1: Working...
Server2: Working...
Server3: Working...
Server3: Not Handled: rick3
Enter a command: all_done.
ok
```
Then change the original file (uncomment rick, rick2, rick3).
After doing so recompile main and update server1 and server3.
```erl
12> c(main).
main.erl:4:2: Warning: export_all flag enabled - all functions will be exported
%    4| -compile([export_all]).
%     |  ^

{ok,main}
13> whereis(server1)!update.
Server1: Updating...
update
14> whereis(server3)!update.
Server3: Updating...
update
15> main:start().
Enter a command: rick.
Server1: Never gonna give you up
Enter a command: rick2.
Server1: Working...
Server2: Working...
Server3: Working...
Server3: Not Handled: rick2
Enter a command: rick3.
Server1: Working...
Server2: Working...
Server3: Never gonna run around and desert you
Enter a command: halt.
Server1: Stopping...
Server2: Stopping...
Server3: Stopping...
Total Non Handled Count: 4
Enter a command: all_done.
ok
```

