defmodule Servy.Plugins do

  require Logger

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings"}
  end

  def rewrite_path(conv), do: conv

  def log(conv) do
    Logger.info(conv)
    conv
  end

  @doc """
  Logs 404 requests
  """
  def track(%{status: 404, path: path} = conv) do
    Logger.warning("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

end
