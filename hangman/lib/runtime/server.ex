defmodule Hangman.Runtime.Server do
  alias Hangman.Impl.Game

  use GenServer

  ### external api functions

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  ###

  ### internal callback functions

  def init(_init_arg) do
    state = Game.new_game()
    {:ok, state}
  end

  def handle_call({:make_move, guess}, _from, state) do
    {new_state, tally} = Game.make_move(state, guess)
    {:reply, tally, new_state}
  end

  def handle_call(:tally, _from, state) do
    tally = Game.tally(state)
    {:reply, tally, state}
  end

  ##
end
