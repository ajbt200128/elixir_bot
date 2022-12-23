defmodule AiNum.Commands do
  require Logger

  @leader "/"

  def get_leader do
    @leader
  end

  def handle_command(message) do
    message = message |> String.split(" ", parts: 2, trim: true)

    command =
      message |> List.first() |> String.split(@leader, parts: 2, trim: true) |> List.last()

    body = List.last(message)

    case command do
      "image" ->
        %{media: image(body)}

      _ ->
        %{text: "Command not recognized, try /help"}
    end
  end

  defp image(description) do
    Logger.info("Creating image with description: #{description}")

    image =
      OpenAI.Images.Generations.fetch(
        [prompt: description, size: "256x256"],
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
