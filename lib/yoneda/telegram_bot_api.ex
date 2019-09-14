defmodule Yoneda.TelegramBotAPI do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://api.telegram.org/bot" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end

  def process_response(%{body: body}) do
    body
  end

  def send_message(bot_id, chat_id, text) do
    query = URI.encode_query(chat_id: chat_id, text: text)
    get!("#{bot_id}/sendMessage?#{query}")
  end
end
