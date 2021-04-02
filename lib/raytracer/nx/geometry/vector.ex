defmodule Raytracer.Nx.Geometry.Vector do
  import Kernel, except: [length: 1]
  import Nx.Defn
  @default_defn_compiler EXLA

  defdelegate abs(vector), to: Nx
  defdelegate add(vector, vector_or_point), to: Nx
  defdelegate divide(vector, scalar), to: Nx
  defdelegate dot(vector1, vector2), to: Nx

  defn length_squared(vector) do
    Nx.dot(vector, vector)
  end

  defn length(vector) do
    vector
    |> length_squared()
    |> Nx.sqrt()
  end

  defdelegate max_component(vector), to: Nx, as: :reduce_max
  defdelegate min_component(vector), to: Nx, as: :reduce_min
  defdelegate multiply(vector, scalar), to: Nx
  defdelegate negate(vector), to: Nx

  defn normalize(vector) do
    Nx.divide(vector, length(vector))
  end

  defdelegate subtract(vector1, vector2), to: Nx

  defn cross(vector1, vector2) do
    # Assert these are both 3D vectors
    transform({Nx.shape(vector1), Nx.shape(vector2)}, fn
      {{3}, {3}} ->
        :ok

      {s1, s2} ->
        raise ArgumentError,
              "both vectors must have 3 dimensions, got #{inspect(s1)} and #{inspect(s2)}"
    end)

    Nx.concatenate([
      Nx.new_axis(vector1[1] * vector2[2] - vector1[2] * vector2[1], 0),
      Nx.new_axis(vector1[2] * vector2[0] - vector1[0] * vector2[2], 0),
      Nx.new_axis(vector1[0] * vector2[1] - vector1[1] * vector2[0], 0)
    ])
  end

  defn decompose(vector1, vector2) do
    normalized = normalize(vector1)
    parallel = Nx.multiply(normalized, Nx.dot(normalized, vector2))
    perpendicular = Nx.subtract(vector2, parallel)
    {parallel, perpendicular}
  end

  @tolerance 0.0002
  defn perpendicular?(vector1, vector2) do
    vector1
    |> normalize()
    |> Nx.dot(normalize(vector2))
    |> Nx.all_close?(0.0, atol: @tolerance)
  end
end
