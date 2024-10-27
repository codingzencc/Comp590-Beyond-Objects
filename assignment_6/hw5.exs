defmodule Main do
  def server1 do
    receive do
      #:rick -> 
	#IO.puts("pickle rick")
	#Main.server1()
      :halt ->
        IO.puts("Server1: Stopping...")
        send(:server2, :halt)
      :update ->
        IO.puts("Server1: Updating...")
        Main.server1()
      work ->
        IO.puts("Server1: Working...")
        case work do
          {:add, {x, y}} -> IO.puts("Server1: #{x} + #{y} = #{x + y}")
          {:sub, {x, y}} -> IO.puts("Server1: #{x} - #{y} = #{x - y}")
          {:mult, {x, y}} -> IO.puts("Server1: #{x} * #{y} = #{x * y}")
          {:div, {x, y}} ->
            if y == 0 do
              IO.puts("Server1: Division by zero error")
            else
              IO.puts("Server1: #{x} / #{y} = #{x / y}")
            end
          {:sqrt, x} -> IO.puts("Server1: sqrt(#{x}) = #{:math.sqrt(x)}")
          {:neg, x} -> IO.puts("Server1: -(#{x}) = #{x * -1}")
          _ -> send(:server2, work)
        end
        server1()
    end
  end

  def sum_integers(x, acc) do
    if is_number(x) do
      x + acc
    else
      acc
    end
  end

  def product_integers(x, acc) do
    if is_number(x) do
      x * acc
    else
      acc
    end
  end

  def server2 do
    receive do
      #:rick2 ->
	#IO.puts("prickle rick")
	#Main.server2()
      :halt ->
        IO.puts("Server2: Stopping...")
        send(:server3, :halt)
      :update ->
        IO.puts("Server2: Updating...")
        Main.server2()
      work ->
        IO.puts("Server2: Working...")
        case work do
          [head | _] when is_integer(head) ->
            IO.puts("Server2: #{Enum.reduce(work, 0, &sum_integers/2)}")
          [head | _] when is_float(head) ->
            IO.puts("Server2: #{Enum.reduce(work, 1, &product_integers/2)}")
          _ -> send(:server3, work)
        end
        server2()
    end
  end

  def server3(fail_count \\ 0) do
    receive do
      #:rick3 ->
	#IO.puts("pringle rick")
	#Main.server3(fail_count)
      :halt ->
        IO.puts("Server3: Stopping...")
        IO.puts("Total Non Handled Count: #{fail_count}")
      :update ->
        IO.puts("Server3: Updating...")
        Main.server3(fail_count)
      {:error, error} ->
        IO.puts("Server3: Error: #{error}")
        server3(fail_count)
      work ->
        IO.puts("Server3: Not Handled: #{inspect(work)}")
        server3(fail_count + 1)
    end
  end

  def start do
  unless Process.whereis(:server1) do
    pid1 = spawn(__MODULE__, :server1, [])
    Process.register(pid1, :server1)
  end

  unless Process.whereis(:server2) do
    pid2 = spawn(__MODULE__, :server2, [])
    Process.register(pid2, :server2)
  end

  unless Process.whereis(:server3) do
    pid3 = spawn(__MODULE__, :server3, [])
    Process.register(pid3, :server3)
  end

  main()
end


  def get_num_data do
    work = IO.gets("Enter a command: ") |> String.trim() |> Code.eval_string() |> elem(0)
    case work do
      :halt -> send(:server1, :halt)
      _ -> work
    end
  end

  def main do
    case get_num_data() do
      :all_done -> :ok
      work ->
        send(:server1, work)
        main()
    end
  end
end
