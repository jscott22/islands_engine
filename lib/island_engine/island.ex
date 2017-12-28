defmodule IslandEngine.Island do
  alias IslandEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @doc """
  Creates a new island given a type and a starting point
    
  ## Examples 

    iex> IslandEngine.Island.new(:l_shape, %IslandEngine.Coordinate{col: 6, row: 4})
    {:ok, %IslandEngine.Island{
      coordinates: MapSet.new([
        %IslandEngine.Coordinate{col: 6, row: 4},
        %IslandEngine.Coordinate{col: 6, row: 5},
        %IslandEngine.Coordinate{col: 6, row: 6},
        %IslandEngine.Coordinate{col: 7, row: 6}
      ]),
      hit_coordinates: MapSet.new([])
    }}
    
  """

  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  @doc """
  Determines if a newly placed island overlaps with an existing one
  """

  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
  end

  @doc """
  Determines if a guess was a hit or miss for a specific island
  """

  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  @doc """
  Determines if an island is "forested" ie. all coordinates have been guessed succesfully
  """

  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  @doc """
  Returns a list of valid island types
  """

  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  # returns a list of offset coordinate tuples based on type, erroring if invalid island type

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]

  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]

  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]

  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]

  defp offsets(:dot), do: [{0, 0}]

  defp offsets(_), do: {:error, :invalid_island_type}

  # creates a mapset of coordinates for a starting point based on offsets

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  # adds a coordinate to a mapset, erroring if it is a invalid coordinate

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} ->
        {:cont, MapSet.put(coordinates, coordinate)}

      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end
end
