defmodule Recurse do
  def triple(list) do
    triple(list, [])
  end

  defp triple([head | tail], current_list) do
    triple(tail, [head * 3 | current_list])
  end

  defp triple([], current_list) do
    current_list |> Enum.reverse()
  end
end
