defmodule Servy.Handler do
  def handle(request) do
    request |> parse() |> log |> route() |> format_response()
  end

  def parse(request) do
    [method, endpoint, _version] =
      request |> String.split("\n") |> List.first() |> String.split(" ")

    %{method: method, path: endpoint, resp_body: ""}
  end

  def log(conv) do
    IO.inspect(conv)

    conv
  end

  def route(conv) do
    conv = %{method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /codinglanguages HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

C++, Python, Javascript
"""

response = Servy.Handler.handle(request)

IO.puts(response)
