defmodule Day07 do
  import AOC

  defp equation_balances?(target, [l]), do: target == l

  defp equation_balances?(target, [head | tail]) do
    (target - head > 0 && equation_balances?(target - head, tail)) ||
      (rem(target, head) == 0 && equation_balances?(div(target, head), tail))
  end

  defp equation_balances2?(target, curr, []), do: target == curr

  defp equation_balances2?(target, curr, [head | tail]) do
  end

  defp p1(inp) do
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
        |> Enum.reverse()

      {String.to_integer(target_string), nums}
    end)
    |> Enum.filter(fn {target, nums} ->
      equation_balances?(target, nums)
    end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  defp p2(inp) do
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
    |> Enum.filter(fn {target, [head | tail]} ->
      equation_balances2?(target, head, tail)
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
