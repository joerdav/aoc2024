defmodule Day03 do
  import AOC

  defp p1(inp) do
    String.trim(inp, " \n")
    |> String.split("mul(")
    # Remove first element, it isn't a match
    |> Enum.drop(1)
    # Find ending bracket and split the numbers
    |> Enum.map(&(String.split(&1, ")") |> Enum.at(0) |> String.split(",")))
    |> Enum.filter(fn l ->
      length(l) == 2 && Enum.all?(l, &(String.length(&1) > 0 && String.length(&1) < 4))
    end)
    |> Enum.map(fn [x, y] ->
      String.to_integer(x) * String.to_integer(y)
    end)
    |> Enum.sum()
  end

  defp p2(inp) do
    String.trim(inp, " \n")
    |> String.split("do()")
    |> Enum.map(fn d ->
      String.split(d, "don't()")
      |> Enum.at(0)
      |> p1()
    end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(3)))
    IO.puts("Real: ")
    IO.puts(p1(input!(3)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(3)))
    IO.puts("Real: ")
    IO.puts(p2(input!(3)))
  end
end
