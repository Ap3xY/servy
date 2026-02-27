defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser
  alias Servy.Conv

  test "parses a request into a Conv Struct" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    conv = Parser.parse(request)

    assert conv == %Conv{
             method: "GET",
             path: "/wildthings",
             params: %{},
             headers: %{
               "Accept" => "*/*",
               "Host" => "example.com",
               "User-Agent" => "ExampleBrowser/1.0"
             }
           }
  end

  test "parses a list of header fields into a map" do
    header_lines = ["A: 1", "B: 2"]

    headers = Parser.parse_headers(header_lines, %{})

    assert headers == %{"A" => "1", "B" => "2"}
  end

  test "parses a string of params in to map if the content type is application/x-www-form-urlencoded" do
    content_type = "application/x-www-form-urlencoded"
    params_string = "name=Baloo&type=Brown"

    params_map = Parser.parse_params(content_type, params_string)

    assert params_map == %{"name" => "Baloo", "type" => "Brown"}
  end
end
