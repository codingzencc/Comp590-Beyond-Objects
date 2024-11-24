use std::sync::{mpsc, Arc, Mutex};
use std::thread;
use std::f64;

#[derive(Debug, Clone)]
enum Message {
    Halt,
    Add(f64, f64),
    Sub(f64, f64),
    Mult(f64, f64),
    Div(f64, f64),
    Neg(f64),
    Sqrt(f64),
    List(Vec<String>),
    Error(String),
    Other(String),
}

fn serv1(tx2: mpsc::Sender<Message>, rx1: mpsc::Receiver<Message>, tx_done: mpsc::Sender<()>) {
    thread::spawn(move || {
        for message in rx1 {
            match message {
                Message::Halt => {
                    println!("(serv1) Halting");
                    tx2.send(Message::Halt).unwrap();
                    break;
                }
                Message::Add(a, b) => {
                    println!("(serv1) Add: {} + {} = {}", a, b, a + b);
                    tx_done.send(()).unwrap();                }
                Message::Sub(a, b) => {
                    println!("(serv1) Sub: {} - {} = {}", a, b, a - b);
                    tx_done.send(()).unwrap();                 }
                Message::Mult(a, b) => {
                    println!("(serv1) Mult: {} * {} = {}", a, b, a * b);
                    tx_done.send(()).unwrap();                 }
                Message::Div(a, b) => {
                    if b != 0.0 {
                        println!("(serv1) Div: {} / {} = {}", a, b, a / b);
                    } else {
                        println!("(serv1) Error: Division by zero");
                    }
                    tx_done.send(()).unwrap();                }
                Message::Neg(a) => {
                    println!("(serv1) Neg: -({}) = {}", a, -a);
                    tx_done.send(()).unwrap();                 }
                Message::Sqrt(a) => {
                    if a >= 0.0 {
                        println!("(serv1) Sqrt: sqrt({}) = {}", a, a.sqrt());
                    } else {
                        println!("(serv1) Error: Cannot take square root of negative number");
                    }
                    tx_done.send(()).unwrap(); 
                }
                Message::Other(_) => {
                    tx2.send(message).unwrap(); // Forward to serv2
                }
                _ => {
                    tx2.send(message).unwrap(); // Forward to serv2
                }
            }
        }
    });
}

fn serv2(tx3: mpsc::Sender<Message>, rx2: mpsc::Receiver<Message>, tx_done: mpsc::Sender<()>) {
    thread::spawn(move || {
        for message in rx2 {
            match message {
                Message::Halt => {
                    println!("(serv2) Halting");
                    tx3.send(Message::Halt).unwrap();
                    break;
                }
                Message::List(list) => {
                    if let Some(first) = list.get(0) {
                        let head: f64 = first.parse().unwrap();
                        if head == head as i32 as f64 {
                            // Sum the numbers in the list
                            let sum: f64 = list.iter()
                                .filter_map(|x| x.parse::<f64>().ok())
                                .sum();
                            println!("(serv2) Sum: {}", sum);
			    tx_done.send(()).unwrap();
                        } else {
                            // Multiply the numbers in the list
                            let product: f64 = list.iter()
                                .filter_map(|x| x.parse::<f64>().ok())
                                .product();
                            println!("(serv2) Product: {}", product);
		            tx_done.send(()).unwrap();
                        }
                    }
                }
                Message::Other(_) => {
                    tx3.send(message).unwrap(); // Forward to serv3
                }
                _ => {
                    tx3.send(message).unwrap(); // Forward to serv3
                }
            }
        }
    });
}

fn serv3(accumulator: usize, rx3: Arc<Mutex<mpsc::Receiver<Message>>>, tx_done: mpsc::Sender<()>) {
    thread::spawn(move || {
        let mut unprocessed = accumulator;
        loop {
            let message = rx3.lock().unwrap().recv().unwrap(); // Lock the receiver and receive the message
            match message {
                Message::Halt => {
                    println!("(serv3) Halting");
		    println!("(serv3) Unprocessed messages count: {}", unprocessed);
		    tx_done.send(()).unwrap();
                    break;
                }
                Message::Error(err) => {
		    println!("(serv3) Error: {}", err);
		    tx_done.send(()).unwrap();
		}
                Message::Other(msg) => {
                    println!("(serv3) Not handled: {}", msg);
                    unprocessed += 1;
		    tx_done.send(()).unwrap(); // Signal that the message is processed
                }
                _ => {}
            }
        }
    });
}

fn main() {
    let (tx1, rx1) = mpsc::channel();
    let (tx2, rx2) = mpsc::channel();
    let (tx3, rx3) = mpsc::channel();
    let (tx_done, rx_done) = mpsc::channel(); // Channel to signal completion of processing

    // Wrap rx3 in Arc<Mutex> to allow sharing across threads
    let rx3 = Arc::new(Mutex::new(rx3));

    // Spawn the servers
    serv1(tx2, rx1, tx_done.clone());
    serv2(tx3, rx2, tx_done.clone());
    serv3(0, rx3.clone(), tx_done);

    // Read input from stdin
    loop {
        let mut input = String::new();
        println!("Enter a message (or 'halt' to stop):");
        std::io::stdin().read_line(&mut input).expect("Failed to read line");
        let input = input.trim();

        if input == "halt" {
            tx1.send(Message::Halt).unwrap();
            // Wait for the halt message to be processed by serv3
            rx_done.recv().unwrap();  // Blocking on receiving the halt message
            break;
        }

        // Parse input into Message
        let parts: Vec<&str> = input.split(',').collect();

        if parts.len() == 3 {
            let op = parts[0].trim();

            // Try parsing a and b as f64 or i64
            let a_result: Result<f64, _> = parts[1].trim().parse();
            let b_result: Result<f64, _> = parts[2].trim().parse();

            // Handle each case for valid or invalid values of a and b
            let msg = match (a_result, b_result) {
                (Ok(a), Ok(b)) => {
                    // If both a and b are valid floats
                    match op {
                        "add" => Message::Add(a, b),
                        "sub" => Message::Sub(a, b),
                        "mult" => Message::Mult(a, b),
                        "div" => Message::Div(a, b),
                        _ => Message::Other(input.to_string()), // If operation is unknown
                    }
                }
                (Ok(_a), Err(_)) => {
                    // If only a is valid, forward as a string
                    Message::Other(input.to_string())
                }
                (Err(_), Ok(_b)) => {
                    // If only b is valid, forward as a string
                    Message::Other(input.to_string())
                }
                (Err(_), Err(_)) => {
                    // If neither a nor b is a valid number, forward as a string
                    Message::Other(input.to_string())
                }
            };

            tx1.send(msg).unwrap();
        } else if parts.len() == 2 {
            let op = parts[0].trim();
            let a_result: Result<f64, _> = parts[1].trim().parse();

            let msg = match op {
                "neg" => {
                    if let Ok(a) = a_result {
                        Message::Neg(a)
                    } else {
                        Message::Other(input.to_string())
                    }
                }
                "sqrt" => {
                    if let Ok(a) = a_result {
                        Message::Sqrt(a)
                    } else {
                        Message::Other(input.to_string())
                    }
                }
                "error" => {
                    let error_msg = parts[1].trim().to_string();
                    Message::Error(error_msg)
                }
                _ => Message::Other(input.to_string()),
            };

            tx1.send(msg).unwrap();
        } else if input.starts_with('[') && input.ends_with(']') {
            let list = input.trim_matches(|c| c == '[' || c == ']');
            let msg = Message::List(list.split(',').map(|s| s.trim().to_string()).collect());
            tx1.send(msg).unwrap();
        } else {
            tx1.send(Message::Other(input.to_string())).unwrap();
        }

        // Block until the message has been fully processed by one of the servers
        rx_done.recv().unwrap(); // Waiting for the "done" signal
    }
}
