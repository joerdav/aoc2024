defmodule Day01 do
  import AOC

  defp create_lists(inp) do
    inp
    |> String.split("\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn x -> String.split(x, "   ") end)
    |> Enum.map(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
    |> Enum.reduce({[], []}, fn {x, y}, {a1, a2} -> {[x | a1], [y | a2]} end)
  end

  defp p1(inp) do
    {lista, listb} = create_lists(inp)
    lista = Enum.sort(lista)
    listb = Enum.sort(listb)
    Enum.zip_reduce(lista, listb, 0, fn x, y, acc -> acc + abs(x - y) end)
  end

  defp p2(inp) do
    {lista, listb} = create_lists(inp)

    occurences =
      Enum.reduce(listb, %{}, fn x, acc ->
        case Map.get(acc, x) do
          count when is_number(count) -> Map.put(acc, x, count + 1)
          _ -> Map.put(acc, x, 1)
        end
      end)

    Enum.map(lista, fn x ->
      case Map.get(occurences, x) do
        nil -> 0
        y -> x * y
      end
    end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(1)))
    IO.puts("Real: ")
    IO.puts(p1(input!(1)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(1)))
    IO.puts("Real: ")
    IO.puts(p2(input!(1)))
  end
end
