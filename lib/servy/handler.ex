defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  alias Servy.Conv
  alias Servy.FrameworkController

  @pages_path "pages/about.html"

  import Servy.Parser, only: [parse: 1]

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request
    |> parse()
    |> route()
    |> format_response()
  end

  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 200, resp_body: "File error: File not Found"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 200, resp_body: "File error: #{reason}"}
  end

  def route(%Conv{ method: "GET", path: "/hibernate/" <> time } = conv) do
    time |> String.to_integer |> :timer.sleep

    %{ conv | status: 200, resp_body: "Awake!" }
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    File.read(@pages_path) |> handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/codinglanguages"} = conv) do
    %{conv | status: 200, resp_body: "C++, Python, Javascript"}
  end


  def route(%Conv{method: "GET", path: "/frameworks/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)

    FrameworkController.show(conv, params)
  end

  def route(%Conv{method: "GET", path: "/api/frameworks"} = conv) do
    Servy.Api.FrameworkController.index(conv)
  end


  def route(%Conv{method: "GET", path: "/frameworks"} = conv) do
    FrameworkController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/frameworks"} = conv) do
    FrameworkController.create(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path}, here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: #{conv.resp_content_type}
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      404 => "Not Found"
    }[code]
  end
end
