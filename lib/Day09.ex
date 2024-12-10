defmodule Day09 do
  import AOC

  defp parse_inp(inp) do
    inp
    |> String.trim("\n")
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.reduce([], fn {c, idx}, acc ->
      case c do
        [l, r] ->
          reps = String.to_integer(l)
          spaces = String.to_integer(r)

          acc =
            acc ++ Enum.map(1..reps, fn _ -> idx end)

          if spaces == 0 do
            acc
          else
            acc ++ Enum.map(1..spaces, fn _ -> -1 end)
          end

        [l] ->
          reps = String.to_integer(l)

          acc ++ Enum.map(1..reps, fn _ -> idx end)
      end
    end)
  end

  defp sort(nums) do
    first_empty_idx = Enum.find_index(nums, &(&1 == -1))
    last_non_empty_reversed = nums |> Enum.reverse() |> Enum.find_index(&(&1 != -1))
    last_non_empty_idx = length(nums) - 1 - last_non_empty_reversed
    last_non_empty = Enum.at(nums, last_non_empty_idx)

    if first_empty_idx > last_non_empty_idx do
      nums
    else
      updated =
        Enum.with_index(nums)
        |> Enum.map(fn {num, idx} ->
          case idx do
            ^first_empty_idx -> last_non_empty
            ^last_non_empty_idx -> -1
            _ -> num
          end
        end)

      sort(updated)
    end
  end

  defp parse_inp2(inp) do
    inp
    |> String.trim("\n")
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.reduce([], fn {c, idx}, acc ->
      case c do
        [l, r] ->
          reps = String.to_integer(l)
          spaces = String.to_integer(r)

          acc =
            acc ++ [{idx, reps}]

          if spaces == 0 do
            acc
          else
            acc ++ [{-1, spaces}]
          end

        [l] ->
          reps = String.to_integer(l)

          acc ++ [{idx, reps}]
      end
    end)
  end

  defp sort2(nums) do
    {idx, _} = Enum.max_by(nums, fn {idx, _} -> idx end)
    sort2(nums, idx)
  end

  defp sort2(nums, 0), do: nums

  defp sort2(nums, curr_id) do
    curr = Enum.find_index(nums, fn {idx, _} -> idx == curr_id end)
    curr_rec = Enum.at(nums, curr)

    {_, csize} = curr_rec

    next_space =
      Enum.find_index(nums, fn {idx, v} ->
        v >= csize && idx == -1
      end)

    if(next_space < curr) do
      {_, ssize} = Enum.at(nums, next_space)

      nums =
        Enum.slice(nums, 0..(next_space - 1)) ++
          [curr_rec] ++
          if(ssize != csize, do: [{-1, ssize - csize}], else: []) ++
          Enum.slice(nums, (next_space + 1)..(curr - 1)) ++
          [{-1, csize}] ++
          Enum.slice(nums, (curr + 1)..length(nums))

      sort2(nums, curr_id - 1)
    else
      sort2(nums, curr_id - 1)
    end
  end

  defp p1(inp) do
    inp
    |> parse_inp()
    |> sort()
    |> Enum.with_index()
    |> Enum.filter(fn {n, _} -> n > 0 end)
    |> Enum.map(fn {n, idx} ->
      n * idx
    end)
    |> Enum.sum()
  end

  defp p2(inp) do
    inp
    |> parse_inp2()
    |> sort2()
    |> Enum.flat_map(fn {num, size} ->
      Enum.map(1..size, fn _ -> num end)
    end)
    |> Enum.with_index()
    |> Enum.filter(fn {n, _} -> n > 0 end)
    |> Enum.map(fn {n, idx} ->
      n * idx
    end)
    |> Enum.sum()
  end

  def part1 do
    IO.puts("Test: ")
    IO.puts(p1(test_input!(9)))
    IO.puts("Real: ")
    IO.puts(p1(input!(9)))
  end

  def part2 do
    IO.puts("Test: ")
    IO.puts(p2(test_input!(9)))
    IO.puts("Real: ")
    IO.puts(p2(input!(9)))
  end
end
