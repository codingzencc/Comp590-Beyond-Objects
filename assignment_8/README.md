# Assignment 8

The parsing for rust is a bit of a pain, so instead of entering a tuple in brackets, I decided to just parse with commas as the delimiter, meaning there is no need to include {} brackets. For array inputs, [] is still necessary.
```rust
C:\Users\nitsuj\rust>rustc hw8.rs

C:\Users\nitsuj\rust>hw8
Enter a message (or 'halt' to stop):
add, 3, 2
(serv1) Add: 3 + 2 = 5
Enter a message (or 'halt' to stop):
sub, 5, 10
(serv1) Sub: 5 - 10 = -5
Enter a message (or 'halt' to stop):
mult, 2.2, 12
(serv1) Mult: 2.2 * 12 = 26.400000000000002
Enter a message (or 'halt' to stop):
div, 32,4
(serv1) Div: 32 / 4 = 8
Enter a message (or 'halt' to stop):
neg,90
(serv1) Neg: -(90) = -90
Enter a message (or 'halt' to stop):
sqrt, 40
(serv1) Sqrt: sqrt(40) = 6.324555320336759
Enter a message (or 'halt' to stop):
[1,2,3,4,a,5]
(serv2) Sum: 15
Enter a message (or 'halt' to stop):
[1.5,a,b,c,20]
(serv2) Product: 30
Enter a message (or 'halt' to stop):
error, some error
(serv3) Error: some error
Enter a message (or 'halt' to stop):
add, a,1
(serv3) Not handled: add, a,1
Enter a message (or 'halt' to stop):
gibberish
(serv3) Not handled: gibberish
Enter a message (or 'halt' to stop):
halt
(serv1) Halting
(serv2) Halting
(serv3) Halting
(serv3) Unprocessed messages count: 2
```
