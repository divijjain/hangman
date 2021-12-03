defmodule Dictionary.Runtime.Server do
  alias Dictionary.Impl.WordList

  use Agent

  @name __MODULE__

  @spec start_link(any()) :: {:ok, pid} | {:error, any}
  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @name)
  end

  @spec random_word() :: String.t()
  def random_word do
    Agent.get(@name, &WordList.random_word/1)
  end
end
