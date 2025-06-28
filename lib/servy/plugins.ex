defmodule Servy.Plugins do
  def log(conversation_string), do: IO.inspect(conversation_string)

  def track(%{status: 404, path: path} = conversation_string) do
    IO.puts("Warning #{path} is on the loose!")

    conversation_string
  end

  def track(conversation_string), do: conversation_string
end
