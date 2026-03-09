defmodule Recurse do
  def sum([head | tail], total) do
    sum(tail, total + head)
  end

  def sum([], total), do: IO.puts("#{total}")

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []
end
