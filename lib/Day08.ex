defmodule Day08 do
  import AOC

  defp out_of_bounds({px, py}, {bx, by}) do
    px < 0 || px > bx || py < 0 || py > by
  end

  defp normal({ax, ay}) do
    d = Integer.gcd(ax, ay)
    {div(ax, d), div(ay, d)}
  end

  defp add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  defp sub({ax, ay}, {bx, by}) do
    {ax - bx, ay - by}
  end

  defp flip({x, y}) do
    {-x, -y}
  end

  defp parse_grid(inp) do
    grid =
      inp
      |> String.trim("\n")
      |> String.split("\n")

    bounds = {Enum.at(grid, 0) |> String.length() |> Kernel.-(1), length(grid) - 1}

    antennas =
      grid
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, idx}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _} -> c != "." end)
        |> Enum.reduce(acc, fn {c, cidx}, acc ->
          Map.put(acc, c, [{cidx, idx}] ++ Map.get(acc, c, []))
        end)
      end)

    {antennas, bounds}
  end

  defp get_antinodes(antennas), do: get_antinodes(antennas, MapSet.new())
  defp get_antinodes([_], antinodes), do: antinodes

  defp get_antinodes([head | tail], antinodes) do
    antinodes =
      tail
      |> Enum.reduce(antinodes, fn l, acc ->
        d = sub(head, l)

        acc
        |> MapSet.put(sub(l, d))
        |> MapSet.put(add(head, d))
      end)

    get_antinodes(tail, antinodes)
  end

  defp get_antinodes2(antennas, bounds), do: get_antinodes2(antennas, MapSet.new(), bounds)
  defp get_antinodes2([_], antinodes, _), do: antinodes

  defp get_antinodes2([head | tail], antinodes, bounds) do
    antinodes =
      tail
      |> Enum.reduce(antinodes, fn l, acc ->
        d = sub(head, l)
        len = normal(d)

        acc
        |> inlines(head, len, bounds)
        |> inlines(head, flip(len), bounds)
      end)

    get_antinodes2(tail, antinodes, bounds)
  end

  defp inlines(nodes, current, step, bounds) do
    next = add(current, step)

    if out_of_bounds(next, bounds) do
      MapSet.put(nodes, current)
    else
      inlines(MapSet.put(nodes, current), next, step, bounds)
    end
  end

  defp p1(inp) do
    {antennas, bounds} = parse_grid(inp)

    antinodes =
      Map.to_list(antennas)
      |> Enum.map(fn {_, a} -> get_antinodes(a) end)
      |> Enum.reduce(MapSet.new(), fn a, acc -> MapSet.union(a, acc) end)
      |> MapSet.filter(&(!out_of_bounds(&1, bounds)))

    MapSet.size(antinodes)
  end

  defp p2(inp) do
    {antennas, bounds} = parse_grid(inp)

    antinodes =
      Map.to_list(antennas)
      |> Enum.map(fn {_, a} -> get_antinodes2(a, bounds) end)
      |> Enum.reduce(MapSet.new(), fn a, acc -> MapSet.union(a, acc) end)
      |> MapSet.filter(&(!out_of_bounds(&1, bounds)))

    MapSet.size(antinodes)
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(8)))
    IO.puts("Real: ")
    IO.puts(p1(input!(8)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(8)))
    IO.puts("Real: ")
    IO.puts(p2(input!(8)))
  end
end
