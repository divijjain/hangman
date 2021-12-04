defmodule Hangman do
  @moduledoc """
  some sort of public api
  """

  def new_game do
    {:ok, pid} = Hangman.Runtime.Application.start_game()
    pid
  end

  def make_move(pid, guess) do
    tally = GenServer.call(pid, {:make_move, guess})
    {pid, tally}
  end

  def tally(pid) do
    GenServer.call(pid, :tally)
  end
end
