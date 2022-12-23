defmodule AiNum.Commands do
  require Logger

  @leader "/"

  @help """
  ~~~Help Page~~~
  Usage: /<command> <args>
  Commands:
    /image <prompt> - Generate an image from a prompt
    /wtf     - About this phone number
    /help    - Show this page
    /stats   - Show stats of this project
    /statsme - Show my stats
    /support - Support this project
    STOP     -stop receiving messages

  or just send me a text about something, but please only one at a time, I'm slow
  """

  @wtf """
  Run by Austin Theriault
  > Email: austin@cutedogs.org
  > Github: https://github.com/ajbt200128
  > Venmo: @ajbt200128 (Please)
  > Paypal: https://paypal.me/austintheriault

  Please be nice :( every text costs me a few cents
  Privacy Policy: Assume I can read everything sent here, but I probably won't
  """

  @not_recognized "Sorry queen, I don't know that, try /help"

  @shill """
  This isn't cheap.
  Venmo: @ajbt200128
  Paypal: https://paypal.me/austintheriault
  """

  def get_leader do
    @leader
  end

  # idea:
  # /send_text <number> <msg> send other person a text
  # /send_image <number> <image> send other person an image
  # Save responses, ask gpt to generate occaasional texts about them
  def handle_command(message, user) do
    message = message |> String.split(" ", parts: 2, trim: true)

    command =
      message |> List.first() |> String.split(@leader, parts: 2, trim: true) |> List.last()

    body = List.last(message)

    case command do
      "image" ->
        AiNum.User.image_count_inc(user)
        %{media: image(body)}

      "help" ->
        %{text: help()}

      "wtf" ->
        %{text: wtf()}

      "stats" ->
        %{text: stats()}

      "statsme" ->
        %{text: statsme(user)}

      "support" ->
        %{text: shill()}

      _ ->
        %{text: @not_recognized}
    end
  end

  defp shill do
    @shill
  end

  defp help do
    @help
  end

  defp wtf do
    @wtf
  end

  defp stats do
    """
    ~~~Stats~~~
    Total Images Generated: #{AiNum.User.total_image_count}
    Total Texts Received: #{AiNum.User.total_text_count}
    Total Users: #{AiNum.User.total_user_count}

    #{@shill}
    """
  end

  defp statsme(user) do
    """
    ~~~Stats~~~
    Total Images Generated: #{user.image_count}
    Total Texts Received: #{user.text_count}

    #{@shill}
    """
  end

  defp image(description) do
    # Maybe check usage limits
    Logger.info("Creating image with description: #{description}")

    image =
      OpenAI.Images.Generations.fetch(
        [prompt: description, size: "512x512"],
        recv_timeout: 10 * 60 * 1000
      )

    Logger.info("DallE response #{inspect(image)}")

    case image do
      {:ok, %{:data => [%{"url" => url}]}} ->
        url

      {:error, error} ->
        Logger.error("Error: #{inspect(error)}")
        "http://clipart-library.com/new_gallery/crying-emoji/Loudly_Crying_Face_Emoji_grande.png"
    end
  end
end
