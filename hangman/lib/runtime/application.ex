defmodule Hangman.Runtime.Application do
  @super GameStarter

  use Application

  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @super}
    ]

    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_game do
    DynamicSupervisor.start_child(@super, {Hangman.Runtime.Server, nil})
  end
end
