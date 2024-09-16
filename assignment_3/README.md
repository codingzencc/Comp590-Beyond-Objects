# README: Running `p1` and `p2` Modules in Erlang Shell

Example Output for p1:

```erl
1> c(p1).
{ok,p1}
2> p1:prog1().
Enter a number: 5.
The number you entered is: 5
120
ok
3> p1:prog1()
Enter a number: abc.
The number you entered is: abc
not an integer
ok
```

Example output for p2:

```erl
1> c(p2).
{ok,p2}
2> p2:prog2().
Enter a number: -3.
The number you entered is: -3
2187.0
Enter a number: 7.
The number you entered is: 7
1.4757731615945522
Enter a number: 4.
The number you entered is: 4
24
Enter a number: 0.
The number you entered is: 0
0
ok
```