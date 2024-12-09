defmodule Day07 do
  import AOC

  defp equation_balances?(target, _, curr, []), do: target == curr

  defp equation_balances?(target, ops, curr, [head | tail]) do
    curr < target &&
      Enum.any?(ops, &equation_balances?(target, ops, &1.(curr, head), tail))
  end

  defp parse_inp(inp) do
    inp
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(fn equation_string ->
      [target_string, right_string] = String.split(equation_string, ":", parts: 2)

      nums =
        right_string
        |> String.trim(" ")
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(target_string), nums}
    end)
  end

  defp p1(inp) do
    ops = [&Kernel.+/2, &Kernel.*/2]

    parse_inp(inp)
    |> Enum.filter(fn {target, [head | tail]} ->
      equation_balances?(target, ops, head, tail)
    end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  defp p2(inp) do
    ops = [
      &Kernel.+/2,
      &Kernel.*/2,
      &String.to_integer(to_string(&1) <> to_string(&2))
    ]

    parse_inp(inp)
    |> Enum.filter(fn {target, [head | tail]} ->
      equation_balances?(target, ops, head, tail)
    end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(7)))
    IO.puts("Real: ")
    IO.puts(p1(input!(7)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(7)))
    IO.puts("Real: ")
    IO.puts(p2(input!(7)))
  end
end
