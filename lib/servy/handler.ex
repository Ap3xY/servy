defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> track
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

  def route(%{method: "GET", path: "/genres"} = conversation_string) do
    %{conversation_string | status: 200, response_body: "Strategy, FPS, RPG"}
  end

  def route(%{method: "GET", path: "/games"} = conversation_string) do
    %{
      conversation_string
      | status: 200,
        response_body: "Total War Shogun 2, Call of Duty 3, Baldur's gate 3"
    }
  end

  def route(%{method: "GET", path: "/games/" <> id} = conversation_string) do
    %{conversation_string | status: 200, response_body: "Game #{id}"}
  end

  def route(%{path: path} = conversation_string) do
    %{conversation_string | status: 404, response_body: "No #{path} here!"}
  end

  def track(%{status: 404, path: path} = conversation_string) do
    IO.puts("Warning #{path} is on the loose!")

    conversation_string
  end

  def track(conversation_string), do: conversation_string

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
