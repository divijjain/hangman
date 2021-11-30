defmodule Dictionary do
  @wordlist File.read!(Path.join(["assets", "words.txt"]))
            |> String.trim()
            |> String.split()

  @doc """
  this function returns a random word
  """
  def random_word do
    @wordlist
    |> Enum.random()
  end
end
