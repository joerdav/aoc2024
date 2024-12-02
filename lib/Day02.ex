defmodule Day02 do
  import AOC

  defp get_reports(inp) do
    String.split(inp, "\n")
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn x ->
      String.split(x, " ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp safe(report, dir \\ :none)
  defp safe([], _), do: true
  defp safe([_], _), do: true

  defp safe(r, dir) do
    [curr | tail] = r
    [next | _] = tail
    diff = abs(curr - next)

    cond do
      # Wrong step size
      diff < 1 || diff > 3 ->
        false

      # Wrong direction
      curr > next && dir == :up ->
        false

      curr < next && dir == :down ->
        false

      # All good
      true ->
        safe(tail, if(next > curr, do: :up, else: :down))
    end
  end

  defp p1(inp) do
    get_reports(inp)
    |> Enum.filter(&safe/1)
    |> Enum.count()
  end

  defp p2(inp) do
    get_reports(inp)
    |> Enum.map(fn x ->
      if safe(x) do
        true
      else
        Enum.any?(0..(length(x) - 1), fn i ->
          safe(List.delete_at(x, i))
        end)
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(2)))
    IO.puts("Real: ")
    IO.puts(p1(input!(2)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(2)))
    IO.puts("Real: ")
    IO.puts(p2(input!(2)))
  end
end
