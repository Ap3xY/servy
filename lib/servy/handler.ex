defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, status: nil, response_body: ""}
  end

  def log(conversation_string), do: IO.inspect(conversation_string)

  def route(conversation_string) do
    route(conversation_string, conversation_string.method, conversation_string.path)
  end

  def route(conversation_string, "GET", "/genres") do
    %{conversation_string | status: 200, response_body: "Strategy, FPS, RPG"}
  end

  def route(conversation_string, "GET", "/games") do
    %{
      conversation_string
      | status: 200,
        response_body: "Total War Shogun 2, Call of Duty 3, Baldur's gate 3"
    }
  end

  def route(conversation_string, "GET", "/games/" <> id) do
    %{conversation_string | status: 200, response_body: "Game #{id}"}
  end

  def route(conversation_string, _method, path) do
    %{conversation_string | status: 404, response_body: "No #{path} here!"}
  end

  def format_response(conversation_string) do
    """
    HTTP/1.1 #{conversation_string.status} #{status_reason(conversation_string.status)}
    Content-Type: text/html
    Content-Length: #{String.length(conversation_string.response_body)}

    #{conversation_string.response_body}
    """
  end

  defp status_reason(status_code) do
    %{
      200 => "OK",
      404 => "Not Found"
    }[status_code]
  end
end

request = """
GET /games/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
