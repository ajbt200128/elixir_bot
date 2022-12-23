defmodule AiNum.Util do
  import ExTwiml

  def format_twiml(data) do
    twiml do
      message do
       if text = data[:text] do
         body text
       end
       if media = data[:media] do
         media media
       end
      end
    end
  end
end
