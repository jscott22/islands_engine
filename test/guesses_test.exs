defmodule GuessesTest do
  alias IslandEngine.{Guesses, Coordinate}

  use ExUnit.Case, async: true
  doctest IslandEngine.Guesses

  setup_all do
    guesses = Guesses.new()
    {:ok, coordinate} = Coordinate.new(1, 1)

    expected =
      MapSet.new()
      |> MapSet.put(coordinate)

    [guesses: guesses, coordinate: coordinate, expected: expected]
  end

  test "adds a hit", context do
    %{guesses: guesses, coordinate: coordinate, expected: expected} = context
    guesses = Guesses.add(guesses, :hit, coordinate)

    assert MapSet.equal?(expected, guesses.hits)
  end

  test "adds a miss", context do
    %{guesses: guesses, coordinate: coordinate, expected: expected} = context
    guesses = Guesses.add(guesses, :miss, coordinate)

    assert MapSet.equal?(expected, guesses.misses)
  end
end
