# Assignment 6: Elixir
Team members: Justin Su, Tyler Yang, Fnu Chaitanya

Assignment 3:
p1:
```erl
iex(4)> c("hw3p1.exs")
[P1]
iex(5)> P1.prog1()
Enter a number: 0
0
:ok
iex(6)> P1.prog1()
Enter a number: 7
1.4757731615945522
:ok
iex(7)> P1.prog1()
Enter a number: -2
128.0
:ok
iex(8)> P1.prog1()
Enter a number: a
not an integer
:ok
```
p2:
```erl
iex(2)> c "hw3p2.exs"
Enter a number: 7
1.4757731615945522
Enter a number: -2
128.0
Enter a number: a
not an integer
Enter a number: 0
Exiting the program.
[P2]
```

Assignment 5: The example is the same as the one given in HW5, but this time with elixir
```erl
iex(31)> c "hw5.exs"
[Main]
iex(33)> Main.start()
Enter a command: :rick
Server1: Working...
Server2: Working...
Server3: Not Handled: :rick
Enter a command: :rick2
Server1: Working...
Server2: Working...
Server3: Not Handled: :rick2
Enter a command: :rick3
Server1: Working...
Server2: Working...
Server3: Not Handled: :rick3
Enter a command: :all_done
:ok
```
Then uncomment ricks in hw5.exs
```erl
iex(34)> c "hw5.exs"
[Main]
iex(35)> send(Process.whereis(:server1),:update)
Server1: Updating...
:update
iex(36)> send(Process.whereis(:server3),:update)
Server3: Updating...
:update
iex(37)> Main.start()
Enter a command: :rick
pickle rick
Enter a command: :rick2
Server1: Working...
Server2: Working...
Server3: Not Handled: :rick2
Enter a command: :rick3
Server1: Working...
Server2: Working...
pringle rick
Enter a command: :halt
Server1: Stopping...
Server2: Stopping...
Server3: Stopping...
Total Non Handled Count: 4
Enter a command: all_done
:ok
```
