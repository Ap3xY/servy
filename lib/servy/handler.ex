defmodule Servy.Handler do
  @moduledoc """
  Handles HTTP requests.
  """

  @pages_path "pages/about.html"

  @doc """
  Transforms the request into a response.
  """
  def handle(request) do
    request |> parse() |> route() |> format_response()
  end

  def parse(request) do
    [method, endpoint, _version] =
      request |> String.split("\n") |> List.first() |> String.split(" ")

    %{method: method, path: endpoint, status: nil, resp_body: ""}
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

  def route(%{method: "GET", path: "/about"} = conv) do
    File.read(@pages_path) |> handle_file(conv)
  end

  def route(%{method: "GET", path: "/codinglanguages"} = conv) do
    %{conv | status: 200, resp_body: "C++, Python, Javascript"}
  end

  def route(%{method: "GET", path: "/frameworks/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Framework #{id}"}
  end

  def route(%{method: "GET", path: "/frameworks"} = conv) do
    %{conv | status: 200, resp_body: "NextJS, Springboot, Django"}
  end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "No #{path}, here!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
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

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
