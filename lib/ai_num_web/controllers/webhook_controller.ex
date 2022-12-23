defmodule AiNumWeb.WebhookController do
  use AiNumWeb, :controller
  require Logger

  # Maybe take confessions over phone call
  # /confessions command displays a random confession transcribed
  def webhook(conn, params) do
    Logger.info("webhook params: #{inspect(params)}")
    body = params["Body"]
    number = params["From"]
    user = AiNum.User.create_or_find(number)
    AiNum.User.text_count_inc(user)

    Logger.debug("User: #{inspect(user)}")
    body = body |> String.trim()

    response =
      if String.at(body, 0) == AiNum.Commands.get_leader() do
        AiNum.Commands.handle_command(body, user)
      else
        AiNum.Chat.handle_chat(body, user)
      end

    response = AiNum.Util.format_twiml(response)
    conn |> put_resp_header("Content-Type", "text/xml") |> resp(200, response)
  end
end
