defmodule CoordinateTest do
  alias IslandEngine.Coordinate

  use ExUnit.Case
  doctest Coordinate

  test "Creates a coordinate with valid points" do
    expected = %Coordinate{row: 1, col: 2}
    created = Coordinate.new(1, 2)

    assert {:ok, expected} == created
  end

  test "Returns invalid coordinate error for invalid point" do
    assert {:error, :invalid_coordinate} == Coordinate.new(11, 1)
    assert {:error, :invalid_coordinate} == Coordinate.new(1, 11)
  end
end
