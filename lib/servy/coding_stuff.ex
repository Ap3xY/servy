defmodule Servy.CodingStuff do
  alias Servy.Framework

  def list_frameworks do
    [
      %Framework{id: 1, name: "NextJS", type: "React", hot: true},
      %Framework{id: 2, name: "SpringBoot", type: "Java", hot: false}
    ]
  end

  def get_framework(id) when is_integer(id) do
    Enum.find(list_frameworks(), fn framework -> framework.id == id end)
  end

  def get_framework(id) when is_binary(id) do
    id |> String.to_integer() |> get_framework()
  end
end
