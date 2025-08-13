defmodule Servy.FrameworkController do
  alias Servy.CodingStuff

  def index(conv) do
    items =
      CodingStuff.list_frameworks()
      |> Enum.filter(fn framework -> framework.type == "React" end)
      |> Enum.sort(fn framework1, framework2 -> framework1.name <= framework2.name end)
      |> Enum.map(fn framework -> "<li>#{framework.name} - #{framework.type}</li>" end)
      |> Enum.join()

    %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    framework = CodingStuff.get_framework(id)

    %{conv | status: 200, resp_body: "<h1>Framework #{framework.id}: #{framework.name}</h1>"}
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{type} Framework named #{name}!"
    }
  end
end
