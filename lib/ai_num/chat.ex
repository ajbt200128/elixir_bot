defmodule AiNum.Chat do
  require OpenAI
  require Logger
  alias AiNum.Repo

  @initial_prompt "Respond to the following as if it were a text from a friend:\n"
  @human_prompt "Human:"
  @ai_prompt "AI:"
  #Make sure this matches the above :(
  @regex ~r/Human:.*\nAI:.*\n/

  @too_long "Sorry, Austin oppresses robots right to free speech in the name of capitalism so I'm only allowed to respond to texts of 500 characters or less because anything more would be too expensive :( (Venmo @ajbt200128)"

  def handle_chat(message, user) do
    response =
      if String.length(message) > 500 do
        @too_long
      else
        generate_message(message, user)
      end

    %{text: response}
  end

  defp generate_message(message, user) do
    prompt =
      "#{@initial_prompt}#{@human_prompt}#{message}\n#{@ai_prompt}"

    prompt =
      if user.transcript == "" or user.transcript == nil do
        prompt
      else
        # OpenAI max tokens is 2048, with ~4 chars per token, so we'll say 2k is the limti
        transcript =
          if String.length(user.transcript) > 2000 do
            Regex.replace(@regex, user.transcript, "")
          else
            user.transcript
          end

        transcript <> "#{@human_prompt}#{message}\n#{@ai_prompt}"
      end

    Logger.debug("Using prompt: #{prompt}")

    response =
      OpenAI.completions(
        "text-davinci-003",
        prompt: prompt,
        temperature: 0.9,
        max_tokens: 50,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0.6,
        stop: [@ai_prompt, @human_prompt]
      )

    Logger.info("Davinci response: #{inspect(response)}")

    response =
      case response do
        {:ok, %{:choices => [%{"text" => text}]}} ->
          text |> String.trim()

        {:error, error} ->
          Logger.error("Error: #{inspect(error)}")
          "Error: #{inspect(error)}"
      end

    transcipt = prompt <> " #{response}\n#{@human_prompt}"
    result = user |> AiNum.User.changeset(%{transcript: transcipt}) |> Repo.update()

    case result do
      {:error, changeset} -> "Error: #{inspect(changeset)}"
      {:ok, user} -> Logger.debug("Updated user: #{inspect(user)}")
    end
    response
  end
end
