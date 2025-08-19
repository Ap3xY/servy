defmodule Servy.FrameworkController do
  alias Servy.CodingStuff

  @templates_path "templates"

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{conv | status: 200, resp_body: content}
  end

  def index(conv) do
    frameworks =
      CodingStuff.list_frameworks()
      |> Enum.sort(fn framework1, framework2 -> framework1.name <= framework2.name end)

    render(conv, "index.eex", frameworks: frameworks)
  end

  def show(conv, %{"id" => id}) do
    framework = CodingStuff.get_framework(id)

    render(conv, "show.eex", framework: framework)
  end

  def create(conv, %{"name" => name, "type" => type} = _params) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{type} Framework named #{name}!"
    }
  end
end
