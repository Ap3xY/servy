defmodule Servy.Handler do
  def handle(request) do
    request |> parse() |> route() |> format_response()
  end

  def parse(request) do
    [method, endpoint, _version] =
      request |> String.split("\n") |> List.first() |> String.split(" ")

    %{method: method, path: endpoint, status: nil, resp_body: ""}
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/codinglanguages") do
    %{conv | status: 200, resp_body: "C++, Python, Javascript"}
  end

  def route(conv, "GET", "/frameworks") do
    %{conv | status: 200, resp_body: "NextJS, Springboot, Django"}
  end

  def route(conv, "GET", "/frameworks/" <> id) do
    %{conv | status: 200, resp_body: "Framework #{id}"}
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
GET /frameworks/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
