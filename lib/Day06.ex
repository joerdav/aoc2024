defmodule Day06 do
  import AOC

  defp add({a1, a2}, {b1, b2}), do: {a1 + b1, a2 + b2}

  defp out_of_bounds({px, py}, {bx, by}) do
    px < 0 || px > bx || py < 0 || py > by
  end

  defp move(pos, dir, bounds, grid, moves \\ MapSet.new()) do
    moves = MapSet.put(moves, pos)
    {nextx, nexty} = add(pos, dir)

    if out_of_bounds({nextx, nexty}, bounds) do
      moves
    else
      nextIsObstacle = grid |> Enum.at(nexty) |> String.at(nextx) |> Kernel.==("#")

      if nextIsObstacle do
        move(pos, rotate(dir), bounds, grid, moves)
      else
        move({nextx, nexty}, dir, bounds, grid, moves)
      end
    end
  end

  defp route_is_loop(pos, dir, bounds, grid),
    do: route_is_loop(pos, pos, dir, dir, bounds, grid, MapSet.new())

  defp route_is_loop(pos, startPos, dir, startDir, bounds, grid, visited) do
    if MapSet.member?(visited, {pos, dir}) do
      true
    else
      visited = MapSet.put(visited, {pos, dir})
      {nextx, nexty} = add(pos, dir)
      next = {nextx, nexty}

      if out_of_bounds(next, bounds) do
        false
      else
        nextIsObstacle = grid |> Enum.at(nexty) |> String.at(nextx) |> Kernel.==("#")

        if nextIsObstacle do
          route_is_loop(pos, startPos, rotate(dir), startDir, bounds, grid, visited)
        else
          route_is_loop(next, startPos, dir, startDir, bounds, grid, visited)
        end
      end
    end
  end

  defp p1(inp) do
    grid =
      inp
      |> String.trim("\n")
      |> String.split("\n")

    maxX = Enum.at(grid, 0) |> String.length() |> Kernel.-(1)
    maxY = length(grid) |> Kernel.-(1)

    startPos =
      Enum.with_index(grid)
      |> Enum.map(fn {r, y} ->
        idx = String.graphemes(r) |> Enum.find_index(&(&1 == "^"))

        if idx != nil do
          {idx, y}
        else
          nil
        end
      end)
      |> Enum.find(&(&1 != nil))

    startDir = {0, -1}

    move(startPos, startDir, {maxX, maxY}, grid)
    |> MapSet.size()
  end

  defp rotate(dir) do
    case dir do
      {0, -1} -> {1, 0}
      {1, 0} -> {0, 1}
      {0, 1} -> {-1, 0}
      {-1, 0} -> {0, -1}
    end
  end

  defp p2(inp) do
    grid =
      inp
      |> String.trim("\n")
      |> String.split("\n")

    maxX = Enum.at(grid, 0) |> String.length() |> Kernel.-(1)
    maxY = length(grid) |> Kernel.-(1)

    startPos =
      Enum.with_index(grid)
      |> Enum.map(fn {r, y} ->
        idx = String.graphemes(r) |> Enum.find_index(&(&1 == "^"))

        if idx != nil do
          {idx, y}
        else
          nil
        end
      end)
      |> Enum.find(&(&1 != nil))

    startDir = {0, -1}
    spots = move(startPos, startDir, {maxX, maxY}, grid)

    MapSet.delete(spots, startPos)
    |> MapSet.to_list()
    |> Enum.filter(fn {x, y} ->
      newGrid =
        grid
        |> Enum.with_index()
        |> Enum.map(fn {v, i} ->
          if i == y do
            v
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.map(fn {v, i} ->
              if i == x do
                "#"
              else
                v
              end
            end)
            |> Enum.join()
          else
            v
          end
        end)

      route_is_loop(startPos, startDir, {maxX, maxY}, newGrid)
    end)
    |> Enum.count()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(6)))
    IO.puts("Real: ")
    IO.puts(p1(input!(6)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(6)))
    IO.puts("Real: ")
    IO.puts(p2(input!(6)))
  end
end
