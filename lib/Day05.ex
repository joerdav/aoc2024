defmodule Day05 do
  import AOC

  defp valid?([_], _), do: true

  defp valid?(update_list, rule_set) do
    [head | tail] = update_list

    if Enum.any?(tail, fn i ->
         MapSet.member?(rule_set, {i, head})
       end) do
      false
    else
      valid?(tail, rule_set)
    end
  end

  defp parse_updates(s) do
    s
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ","))
  end

  defp parse_rules(s) do
    s
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.map(&String.split(&1, "|", parts: 2))
    |> MapSet.new(fn [a, b] -> {a, b} end)
  end

  defp p1(inp) do
    [rules, updates] = String.split(inp, "\n\n", parts: 2)

    rule_set = parse_rules(rules)

    updates
    |> parse_updates()
    |> Enum.filter(&valid?(&1, rule_set))
    |> Enum.map(fn i -> String.to_integer(Enum.at(i, length(i) |> div(2))) end)
    |> Enum.sum()
  end

  defp p2(inp) do
    [rules, updates] = String.split(inp, "\n\n", parts: 2)

    rule_set = parse_rules(rules)

    updates
    |> parse_updates()
    |> Enum.filter(&(!valid?(&1, rule_set)))
    |> Enum.map(fn i ->
      i
      |> Enum.sort(&MapSet.member?(rule_set, {&1, &2}))
      |> Enum.at(length(i) |> div(2))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(5)))
    IO.puts("Real: ")
    IO.puts(p1(input!(5)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(5)))
    IO.puts("Real: ")
    IO.puts(p2(input!(5)))
  end
end
