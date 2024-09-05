public class DiningPhilosophers {

    // Constants for the number of philosophers
    private static final int NUM_PHILOSOPHERS = 5;

    public static void main(String[] args) {
        // Array to track eating counts
        Integer[] eaten = new Integer[NUM_PHILOSOPHERS];
        for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
            eaten[i] = 0;
        }

        // Initialize forks and philosophers
        Fork[] forks = new Fork[NUM_PHILOSOPHERS];
        Philosopher[] philosophers = new Philosopher[NUM_PHILOSOPHERS];

        for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
            forks[i] = new Fork();
        }

        for (int i = 0; i < NUM_PHILOSOPHERS; i++) {
            philosophers[i] = new Philosopher(i, forks[i], forks[(i + 1) % NUM_PHILOSOPHERS], eaten);
        }

        // Start philosopher threads
        for (Philosopher philosopher : philosophers) {
            philosopher.start();
        }

        for (Philosopher philosopher : philosophers) {
            try {
                philosopher.join();
            } catch (InterruptedException e) {
                System.err.println("Philosopher thread interrupted: " + e.getMessage());
                Thread.currentThread().interrupt();
            }
        }
    }
}

// Fork class representing a single fork
class Fork {
    private int takenBy = -1;
    public synchronized void take(int philosopher) {
        takenBy = philosopher;
    }
    public synchronized void drop(int philosopher) {
        takenBy = -1;
    }
}

// Philosopher class representing a single philosopher
class Philosopher extends Thread {
    private final int id;
    private final Fork leftFork;
    private final Fork rightFork;
    private final Integer[] eaten;

    public Philosopher(int id, Fork leftFork, Fork rightFork, Integer[] eaten) {
        this.id = id;
        this.leftFork = leftFork;
        this.rightFork = rightFork;
        this.eaten = eaten;
    }

    private void eat() {
        // Find the philosopher with the maximum eaten count
        int maxInd = -1;
        int maxValue = -1;
        for (int i = 0; i < eaten.length; i++) {
            if (eaten[i] > maxValue) {
                maxValue = eaten[i];
                maxInd = i;
            }
        }

        // If this philosopher has eaten the most and is the one with the maximum index, they return without eating
        if (eaten[id] >= eaten[maxInd] && maxInd == id) {
            return;
        }

        
        /*
        * Philosopher picks up forks and eats:
        * Philosophers with even IDs (0, 2, 4) will pick up their right fork first, followed by their left fork.
        * Philosophers with odd IDs (1, 3) will pick up their left fork first, followed by their right fork.
        * 
        * To avoid deadlock, no two adjacent philosophers are both trying to grab the same
        * forks at the same time in the same order.
        * 
        * For example:
        * - Philosopher 0 will pick up Fork 1 first (right), then Fork 0 (left).
        * - Philosopher 1 will pick up Fork 1 first (left), then Fork 2 (right).
        */
        Fork firstFork = (id % 2 == 0) ? rightFork : leftFork;
        Fork secondFork = (id % 2 == 0) ? leftFork : rightFork;

        synchronized (firstFork) {
            firstFork.take(id);
            synchronized (secondFork) {
                secondFork.take(id);
                eaten[id]++;
                System.out.println("Frequency of eating: [" + eatingFrequency() + "]");
                secondFork.drop(id);
            }
            firstFork.drop(id);
        }
    }
    public void think() {
        return;
    }

    public void run() {
        while (true) {
            eat();
            think();
        }
    }

    // Prints the current eating status of all philosophers
    private String eatingFrequency() {
        StringBuilder status = new StringBuilder();
        for (int i = 0; i < eaten.length; i++) {
            status.append(eaten[i]);
            if (i != eaten.length - 1) {
                status.append(", ");
            }
        }
        return status.toString();
    }
}
