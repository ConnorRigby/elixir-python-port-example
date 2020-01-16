defmodule Pyport do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [self()], opts)
  end

  def echo(pid, data) do
    GenServer.cast(pid, {:echo, data})
  end

  def init([owner]) do
    send(self(), :open_port)
    {:ok, %{port: nil, owner: owner}}
  end

  def handle_info(:open_port, state) do
    python = System.find_executable("python3")
    script = Application.app_dir(:pyport, ["priv", "example.py"])

    port =
      :erlang.open_port({:spawn_executable, python}, [
        :binary,
        {:packet, 4},
        {:args, ["-u", script]},
        :nouse_stdio
      ])

    {:noreply, %{state | port: port}}
  end

  def handle_info({port, {:data, data}}, %{port: port} = state) do
    send(state.owner, :erlang.binary_to_term(data))
    {:noreply, state}
  end

  def handle_cast({:echo, command}, %{port: port} = state) do
    true = :erlang.port_command(port, :erlang.term_to_binary(command))
    {:noreply, state}
  end
end
