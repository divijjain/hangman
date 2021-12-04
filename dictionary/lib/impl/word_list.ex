defmodule Dictionary.Impl.WordList do
  @spec word_list :: list(String.t())
  def word_list do
    "../dictionary/assets/words.txt"
    |> Path.expand()
    |> IO.inspect()
    |> File.read!()
    |> String.trim()
    |> String.split()
  end

  @spec random_word(list(String.t())) :: String.t()
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end
end
