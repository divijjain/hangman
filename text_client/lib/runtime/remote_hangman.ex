defmodule TextClient.Runtime.RemoteHangman do
  @hangman :"hangman@divijs-MacBook-Air"

  def connect do
    :rpc.call(@hangman, Hangman, :new_game, [])
  end
end
