defmodule P1 do
    def prog1 do
	get_num_data()
        |> match_num_data()
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
