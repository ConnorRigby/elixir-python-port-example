defmodule PyportTest do
  use ExUnit.Case

  describe "echos data to the example port" do
    setup do
      {:ok, pid} = Pyport.start_link()
      {:ok, [pid: pid]}
    end

    test "binary", %{pid: pid} do
      :ok = Pyport.echo(pid, "hello world")
      assert_receive "hello world"
    end

    test "atom", %{pid: pid} do
      :ok = Pyport.echo(pid, :hello_world)
      assert_receive :hello_world
    end

    test "number", %{pid: pid} do
      :ok = Pyport.echo(pid, 10.5)
      :ok = Pyport.echo(pid, 11)

      assert_receive 10.5
      assert_receive 11
    end

    test "map", %{pid: pid} do
      :ok = Pyport.echo(pid, %{hello: :world})
      assert_receive %{hello: :world}
    end

    test "tupple", %{pid: pid} do
      :ok = Pyport.echo(pid, {:hello, :world})
      assert_receive {:hello, :world}
    end

    test "list", %{pid: pid} do
      :ok = Pyport.echo(pid, [:hello, :world])
      assert_receive [:hello, :world]

    end

    test "weird stuff", %{pid: pid} do
      fun = fn() -> :hello end
      ref = make_ref()
      :ok = Pyport.echo(pid, pid)
      :ok = Pyport.echo(pid, ref)
      :ok = Pyport.echo(pid, fun)
      assert_receive ^pid
      assert_receive ^ref
      assert_receive ^fun
    end
  end
end
