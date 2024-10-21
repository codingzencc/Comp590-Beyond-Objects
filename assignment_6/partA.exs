defmodule P2 do
    def prog2 do
    case get_num_data() do
      0 -> 
        IO.puts("Exiting the program.")
      n -> 
        match_num_data(n)
        prog2()  # Recursively call prog2 to continue the loop
    end
  end

    defp get_num_data do
        input = IO.gets("Enter a number: ")
        |> String.trim()
	
        try do
            String.to_integer(input)
        rescue
            ArgumentError -> nil
        end
    end

    defp match_num_data(n) do
        case is_number(n) do
            false -> IO.puts("not an integer")
            true ->
                var = case n do
                    n when n < 0 -> :math.pow(abs(n), 7)
                    n when n == 0 -> 0
                    n when rem(n, 7) == 0 -> :math.pow(n, 1/5)
                    n when n > 0 -> fact(n)
                end
                IO.puts(var)
        end
    end

    defp fact(n) when n > 0, do: n * fact(n - 1)
    defp fact(0), do: 1
end

P2.prog2()

