defmodule Dictionary do
  alias Dictionary.Impl.WordList

  @spec start :: list(String.t())
  defdelegate start, to: WordList, as: :word_list

  @doc """
  this function returns a random word
  """
  @spec random_word(list(String.t())) :: String.t()
  defdelegate random_word(word_list), to: WordList
end
