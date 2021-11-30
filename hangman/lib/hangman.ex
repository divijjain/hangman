defmodule Hangman do
  @moduledoc """
  some sort of public api
  """

  alias Hangman.Impl.Game
  alias Hangman.Type

  @type game :: Game.t()

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  defdelegate make_move(game, guess), to: Game
end
