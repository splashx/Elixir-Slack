defmodule Slack.Rtm do
  @moduledoc false
  @url "https://slack.com/api/rtm.start?token="

  require Logger

  def start(token) do
    case HTTPoison.get(@url <> token) do
      {:ok, response} ->
        case JSX.decode(response.body, [{:labels, :atom}]) do
          {:ok, json} ->
            {:ok, json}
          error ->
            Logger.error("""
            Slack API returned non-JSON output: #{inspect response.body, pretty: true}
            HTTPoison returned: #{inspect error, pretty: true}
            """)
            raise RuntimeError, message: "Slack API returned non-JSON output\n#{inspect response.body, pretty: true}"
        end
      {:error, reason} -> {:error, reason}
    end
  end
end
