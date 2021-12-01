defmodule TextClient.Impl.Player do
  @type game :: Hangma.game()

  @type tally :: Hangman.tally()

  @type state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulation you have sucessfully won")
  end

  @spec interact(state) :: :ok
  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts("soyry you have already lost the word was #{tally.letters |> Enum.join()}")
  end

  def interact({game, tally}) do
    IO.puts(feedback_for(tally))
    IO.puts(current_word(tally))
     Hangman.make_move(game, get_guess())
    |> interact()
  end

  def feedback_for(tally = %{game_state: :initializing}) do
    IO.puts("welcome! guess this #{tally.letters |> length()} letters word")
  end

  def feedback_for(%{game_state: :good_guess}) do
    IO.puts("good guess!")
  end

  def feedback_for(%{game_state: :bad_guess}) do
    IO.puts("bad guess!")
  end

  def feedback_for(%{game_state: :already_used}) do
    IO.puts("sorry try you already guessed this letter")
  end

  def current_word(tally) do
    [
      "Words so far ",
      tally.letters |> Enum.join(" "),
      "  turns left ",
      tally.turns_left |> to_string,
      "  used so far ",
      tally.used |> Enum.join(",")
    ]
  end

  def get_guess() do
    IO.gets("enter the next character ")
    |> String.trim()
    |> String.downcase()
  end
end
