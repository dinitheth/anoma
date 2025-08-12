defmodule Anoma.SupervisorTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, sup} = Anoma.Supervisor.start_link([])
    on_exit(fn -> Supervisor.stop(sup) end)
    :ok
  end

  test "stop_node returns :ok when node is unknown" do
    assert :ok = Anoma.Supervisor.stop_node("unknown-node")
  end

  test "stop_node stops a running node" do
    node_id = Base.encode16(:crypto.strong_rand_bytes(8))

    {:ok, _pid} =
      Anoma.Supervisor.start_node(node_id: node_id, transaction: [mempool: []])

    pid = Anoma.Node.Registry.whereis(node_id, Anoma.Node.Supervisor)
    assert is_pid(pid)

    assert :ok = Anoma.Supervisor.stop_node(node_id)
    refute Process.alive?(pid)
  end
end

