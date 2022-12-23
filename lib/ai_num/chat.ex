defmodule AiNum.Chat do
  require OpenAI
  require Logger

  def handle_chat(message) do
    prompt = "Respond to the following as if it were a text from a friend:\n\nHuman: How are you\n\nResponse:"
    response =
      OpenAI.completions(
        "text-davinci-003",
        prompt: prompt,
        temperature: 0.9,
        max_tokens: 50,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0.6,
        stop: ["Response:", "Human:"]
      )

    Logger.info("Davinci response: #{inspect(response)}")

    response =
      case response do
        {:ok, %{:choices => [%{"text" => text}]}} -> text |> String.trim()
      {:error, error} ->
        Logger.error("Error: #{inspect(error)}")
        "Error: #{inspect(error)}"
      end

    %{text: response}
  end
end
