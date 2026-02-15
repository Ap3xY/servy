defmodule Recurse do
  def sum([head | tail], total) do
    sum(tail, total + head)
  end

  def sum([], total), do: IO.puts("#{total}")
end

Recurse.sum([1, 2, 3, 3], 0)
