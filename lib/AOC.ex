defmodule AOC do
  def test_input!(day) do
    File.read!("./inputs/"<>to_string(day)<>"_test")
  end
  def input!(day) do
    File.read!("./inputs/"<>to_string(day))
  end
end
