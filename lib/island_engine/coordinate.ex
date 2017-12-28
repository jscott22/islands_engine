defmodule IslandEngine.Coordinate do
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  @doc """
  Creates a new coordinate given a row and col value between 1 and 10
  """

  def new(row, col) when row in @board_range and col in @board_range do
    {:ok, %Coordinate{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
