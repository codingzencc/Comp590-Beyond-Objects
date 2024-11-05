// Team members: Justin Su, Tyler Yang, Fnu Chaitanya
package main

import (
    "fmt"
    "math/rand"
    "sync"
    "time"
)

var (
    nChairs   = 5           // Number of waiting chairs in the barber shop
    waiting   = 0           // Number of customers waiting (not including the one being served)
    mutex     sync.Mutex    // Mutex for mutual exclusion
    customers *sync.Cond    // Condition variable for waiting customers
    barbers   *sync.Cond    // Condition variable for barber availability
)

func barber() {
    for {
        mutex.Lock()
        // If there are no customers, the barber goes to sleep
        for waiting == 0 {
            fmt.Println("Barber is sleeping as there are no customers.")
            customers.Wait()
        }
        // Barber is awake and ready to cut hair
        waiting--
        fmt.Printf("Barber is ready to cut hair. Waiting customers: %d\n", waiting)
        barbers.Signal()
        mutex.Unlock()

        // Cut hair (simulate time taken to cut hair)
        cutHair()
    }
}

func customer(id int) {
    mutex.Lock()
    fmt.Printf("Customer %d arrived.\n", id)
    if waiting < nChairs {
        waiting++
        fmt.Printf("Customer %d is waiting. Total waiting: %d\n", id, waiting)
        customers.Signal()  // Wake up the barber if he's sleeping
        barbers.Wait()      // Wait for the barber to be ready
        mutex.Unlock()

        // Get a haircut (simulate time taken to get a haircut)
        getHaircut(id)
    } else {
        mutex.Unlock()
        fmt.Printf("Customer %d is leaving as there are no available chairs.\n", id)
    }
}

func cutHair() {
    fmt.Println("Barber is cutting hair.")
    time.Sleep(time.Duration(rand.Intn(1000)+500) * time.Millisecond)
    fmt.Println("Barber finished cutting hair.")
}

func getHaircut(id int) {
    fmt.Printf("Customer %d is getting a haircut.\n", id)
    time.Sleep(time.Duration(rand.Intn(1000)+500) * time.Millisecond)
    fmt.Printf("Customer %d is done with the haircut.\n", id)
}

func main() {
    rand.Seed(time.Now().UnixNano())

    mutex = sync.Mutex{}
    customers = sync.NewCond(&mutex)
    barbers = sync.NewCond(&mutex)

    // Start the barber goroutine
    go barber()

    // Generate customer arrivals at random intervals
    totalCustomers := 20
    for i := 1; i <= totalCustomers; i++ {
        time.Sleep(time.Duration(rand.Intn(500)) * time.Millisecond)
        go customer(i)
    }

    // Allow time for all customers to be processed
    time.Sleep(10 * time.Second)
    fmt.Println("Barber shop is closing.")
}
