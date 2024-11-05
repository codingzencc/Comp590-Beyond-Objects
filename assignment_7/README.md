## Sleeping Barber Problem in Go

The barber shop has one barber, one barber chair, and n chairs for waiting customers, if any, to sit on. 
If there are no customers present, the barber sits down in the barber chair and falls asleep. 
When a customer arrives, he has to wake up the sleeping barber. If additional customers arrive
while the barber is cutting a customer's hair, they either sit down (if there are empty chairs) 
or leave the shop (if all chairs are full). 
The problem is to program the barber and the customers without getting into race conditions.

```go
go run main.go
warning: GOPATH set to GOROOT (/usr/local/go) has no effect
Barber is sleeping as there are no customers.
Customer 1 arrived.
Customer 1 is waiting. Total waiting: 1
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 1 is getting a haircut.
Barber finished cutting hair.
Barber is sleeping as there are no customers.
Customer 2 arrived.
Customer 2 is waiting. Total waiting: 1
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 2 is getting a haircut.
Customer 1 is done with the haircut.
Customer 3 arrived.
Customer 3 is waiting. Total waiting: 1
Customer 2 is done with the haircut.
Barber finished cutting hair.
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 3 is getting a haircut.
Customer 4 arrived.
Customer 4 is waiting. Total waiting: 1
Barber finished cutting hair.
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 4 is getting a haircut.
Customer 3 is done with the haircut.
Customer 5 arrived.
Customer 5 is waiting. Total waiting: 1
Customer 4 is done with the haircut.
Barber finished cutting hair.
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 5 is getting a haircut.
Customer 6 arrived.
Customer 6 is waiting. Total waiting: 1
Customer 5 is done with the haircut.
Barber finished cutting hair.
Barber is ready to cut hair. Waiting customers: 0
Barber is cutting hair.
Customer 6 is getting a haircut.
Customer 6 is done with the haircut.
Barber finished cutting hair.
Barber is sleeping as there are no customers.
Barber shop is closing.
```
