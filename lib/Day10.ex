defmodule Day10 do
  import AOC

  defp parse(inp) do
    inp
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, lineidx}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {c, charidx}, acc ->
        Map.put(acc, {charidx, lineidx}, String.to_integer(c))
      end)
    end)
  end

  defp addvec({ax, ay}, {bx, by}), do: {ax + bx, ay + by}

  defp uniq_trails(pos, target, positions), do: uniq_trails(pos, target, positions, MapSet.new())
  defp uniq_trails(pos, 10, _, acc), do: MapSet.put(acc, pos)

  defp uniq_trails(pos, target, positions, acc) do
    [
      addvec(pos, {0, -1}),
      addvec(pos, {0, 1}),
      addvec(pos, {-1, 0}),
      addvec(pos, {1, 0})
    ]
    |> Enum.filter(fn p ->
      v = Map.get(positions, p)
      v != nil && v == target
    end)
    |> Enum.reduce(acc, fn pos, acc ->
      uniq_trails(pos, target + 1, positions, acc)
    end)
  end

  defp p1(inp) do
    positions = parse(inp)

    positions
    |> Map.to_list()
    |> Enum.filter(fn {_, v} -> v == 0 end)
    |> Enum.map(fn {pos, _} -> uniq_trails(pos, 1, positions) |> MapSet.size() end)
    |> Enum.sum()
  end

  defp trails(_, 10, _), do: 1

  defp trails(pos, target, positions) do
    [
      addvec(pos, {0, -1}),
      addvec(pos, {0, 1}),
      addvec(pos, {-1, 0}),
      addvec(pos, {1, 0})
    ]
    |> Enum.filter(fn p ->
      v = Map.get(positions, p)
      v != nil && v == target
    end)
    |> Enum.map(fn pos ->
      trails(pos, target + 1, positions)
    end)
    |> Enum.sum()
  end

  defp p2(inp) do
    positions = parse(inp)

    positions
    |> Map.to_list()
    |> Enum.filter(fn {_, v} -> v == 0 end)
    |> Enum.map(fn {pos, _} -> trails(pos, 1, positions) end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(10)))
    IO.puts("Real: ")
    IO.puts(p1(input!(10)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(10)))
    IO.puts("Real: ")
    IO.puts(p2(input!(10)))
  end
end
