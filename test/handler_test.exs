defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Length: 20

           Bears, Lions, Tigers
           """
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 404 Not Found
           Content-Type: text/html
           Content-Length: 17

           No /bigfoot here!
           """
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1
    Host: example.com
    User-Agent: ExampleBrowser/1.0
    Accept: */*

    """

    response = handle(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Length: 20

           Bears, Lions, Tigers
           """
  end
end
