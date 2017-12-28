defmodule IslandTest do
  alias IslandEngine.Island

  use ExUnit.Case
  doctest IslandEngine.Island

  test "Returns all valid types" do
    valid_types = [:atoll, :dot, :l_shape, :s_shape, :square]

    assert valid_types == Island.types()
  end
end
