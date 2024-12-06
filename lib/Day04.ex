defmodule Day04 do
  import AOC

  defp valid_coord(grid, {x, y}, expected) do
    max_x = String.length(Enum.at(grid, 0))
    max_y = length(grid)
    x >= 0 && x < max_x && y >= 0 && y < max_y && String.at(Enum.at(grid, y), x) == expected
  end

  defp add({a1, a2}, {b1, b2}), do: {a1 + b1, a2 + b2}

  defp check_for_xmas(grid, coord) do
    checks = [
      # m        a        s
      # north
      [{0, -1}, {0, -2}, {0, -3}],
      # south
      [{0, 1}, {0, 2}, {0, 3}],
      # west
      [{-1, 0}, {-2, 0}, {-3, 0}],
      # east
      [{1, 0}, {2, 0}, {3, 0}],
      # north-east
      [{1, -1}, {2, -2}, {3, -3}],
      # north-west
      [{-1, -1}, {-2, -2}, {-3, -3}],
      # south-east
      [{1, 1}, {2, 2}, {3, 3}],
      # south-west
      [{-1, 1}, {-2, 2}, {-3, 3}]
    ]

    Enum.filter(checks, fn check ->
      valid_coord(grid, add(coord, Enum.at(check, 0)), "M") &&
        valid_coord(grid, add(coord, Enum.at(check, 1)), "A") &&
        valid_coord(grid, add(coord, Enum.at(check, 2)), "S")
    end)
    |> Enum.count()
  end

  defp check_for_mas(grid, coord) do
    a =
      valid_coord(grid, add(coord, {-1, -1}), "M") &&
        valid_coord(grid, add(coord, {1, 1}), "S")

    b =
      valid_coord(grid, add(coord, {-1, -1}), "S") &&
        valid_coord(grid, add(coord, {1, 1}), "M")

    c =
      valid_coord(grid, add(coord, {1, -1}), "M") &&
        valid_coord(grid, add(coord, {-1, 1}), "S")

    d =
      valid_coord(grid, add(coord, {1, -1}), "S") &&
        valid_coord(grid, add(coord, {-1, 1}), "M")

    (a || b) && (c || d)
  end

  defp p1(inp) do
    grid =
      String.trim(inp, "\n")
      |> String.split("\n")

    Enum.map(0..(length(grid) - 1), fn row ->
      Enum.map(0..(String.length(Enum.at(grid, 0)) - 1), fn col ->
        if valid_coord(grid, {col, row}, "X") do
          check_for_xmas(grid, {col, row})
        else
          0
        end
      end)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp p2(inp) do
    grid =
      String.trim(inp, "\n")
      |> String.split("\n")

    Enum.map(0..(length(grid) - 1), fn row ->
      Enum.filter(0..(String.length(Enum.at(grid, 0)) - 1), fn col ->
        if valid_coord(grid, {col, row}, "A") do
          check_for_mas(grid, {col, row})
        else
          false
        end
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(4)))
    IO.puts("Real: ")
    IO.puts(p1(input!(4)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(4)))
    IO.puts("Real: ")
    IO.puts(p2(input!(4)))
  end
end
