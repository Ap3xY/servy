defmodule Servy.Api.FrameworkController do
  def index(conv) do
    json = Servy.CodingStuff.list_frameworks()
    |> Poison.encode!

    %{ conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
