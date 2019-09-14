defmodule Yoneda do
  defmodule Message do
    defstruct [:author_id, :text]
  end

  def test do
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "a", text: "1"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "b", text: "2"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "c", text: "3"})
    :timer.sleep(50)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "d", text: "4"})
    :timer.sleep(100)
    Yoneda.Dialogue.message(1, %Yoneda.Message{author_id: "e", text: "5"})
  end
end
