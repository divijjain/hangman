defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct turns_left: 7,
            game_state: :initializing,
            letters: [],
            used: MapSet.new()

  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.start())
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :loss] do
    return_with_tally(game)
  end

  def make_move(game , guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_letters(game),
      used: game.used |> MapSet.to_list |> Enum.sort,
    }
  end

  ########## private functions

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _) do
    %{game | used: MapSet.put(game.used,guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _good_guess = false) do
    %{game | game_state: :lost}
  end

  defp score_guess(game , _good_guess = false) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp maybe_won(true) do
    :won
  end

  defp maybe_won(false) do
    :good_guess
  end

  defp reveal_letters(game = %{game_state: :lost}) do
    Enum.map(game.letters, fn letter ->
      letter
    end)
  end

  defp reveal_letters(game) do
    Enum.map(game.letters, fn letter ->
      show(letter, MapSet.member?(game.used, letter))
    end)
  end

  defp show(letter, true) do
    letter
  end

  defp show(_letter, _) do
    "_"
  end

  #########

end
