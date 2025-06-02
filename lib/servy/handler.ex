defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response_body: ""}
  end

  def route(conversation_string) do
    conversation_string = %{method: "GET", path: "/games", response_body: "Halo, CS2, COD"}
  end

  def format_response(conversation_string) do
    """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Halo, CS2, COD
    """
  end
end

request = """
GET /games HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
