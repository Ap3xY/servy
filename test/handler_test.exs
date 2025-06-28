defmodule HandlerTest do
  use ExUnit.Case, async: true

  import Servy.Handler, only: [handle: 1]

  test "GET /games" do
    request = """
    GET /games HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 51\r
           \r
           Total War Shogun 2, Call of Duty 3, Baldur's gate 3
           """
  end
end
