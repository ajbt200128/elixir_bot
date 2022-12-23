defmodule AiNumWeb.WebhookController do
  use AiNumWeb, :controller
  require Logger

  # idea:
  # @signup # -> signup other person
  # Ask for persons name and ask gpt to respond with that
  # @send send other person a text
  # Save responses, ask gpt to generate occaasional texts about them
  # @image -> send image
  # take calls and use transcript software, feed to gpt
  def webhook(conn, params) do
    Logger.info("webhook params: #{inspect(params)}")
    body = params["Body"]
    body = body |> String.trim()

    response =
      if String.at(body, 0) == AiNum.Commands.get_leader() do
        AiNum.Commands.handle_command(body)
      else
        AiNum.Chat.handle_chat(body)
      end

    response = AiNum.Util.format_twiml(response)
    conn |> put_resp_header("Content-Type", "text/xml") |> resp(200, response)
  end
end
