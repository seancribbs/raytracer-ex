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

  # Problem: We can't assert the size/shape of each input tensor without a
  # separate function to add the guards
  defn cross(vector1, vector2) do
    Nx.concatenate([
      Nx.new_axis(vector1[1] * vector2[2] - vector1[2] * vector2[1], 0),
      Nx.new_axis(vector1[2] * vector2[0] - vector1[0] * vector2[2], 0),
      Nx.new_axis(vector1[0] * vector2[1] - vector1[1] * vector2[0], 0)
    ])
  end
end
