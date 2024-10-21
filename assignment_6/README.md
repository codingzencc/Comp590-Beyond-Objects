# Assignment 6: Elixir
Team members: Justin Su, Tyler Yang, Fnu Chaitanya

Part A:
p1:

p2:
```erl
iex(2)> c "partA.exs"
    warning: redefining module P2 (current version defined in memory)
    │
  1 │ defmodule P2 do
    │ ~~~~~~~~~~~~~~~
    │
    └─ partA.exs:1: P2 (module)

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

Part B: The example is the same as the one given in HW5
```erl
iex(31)> c "partB.exs"
    warning: redefining module Main (current version defined in memory)
    │
  1 │ defmodule Main do
    │ ~~~~~~~~~~~~~~~~~
    │
    └─ partB.exs:1: Main (module)

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
# Uncomment ricks in partB.exs
iex(34)> c "partB.exs"
    warning: redefining module Main (current version defined in memory)
    │
  1 │ defmodule Main do
    │ ~~~~~~~~~~~~~~~~~
    │
    └─ partB.exs:1: Main (module)

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
