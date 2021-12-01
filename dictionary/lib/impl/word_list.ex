defmodule Dictionary.Impl.WordList do
  @spec word_list :: list(String.t())
  def word_list do
    File.read!(Path.join(["assets", "words.txt"]))
    |> String.trim()
    |> String.split()
  end

  @spec random_word(list(String.t())) :: String.t()
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
