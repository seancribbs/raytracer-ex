defmodule Raytracer.Nx.Geometry.Bounds do
  import Nx.Defn
  @default_defn_compiler EXLA

  # 2x2, float 64
  # @type t :: Nx.Tensor.t()

  def new2(x1, y1, x2, y2) when x1 <= x2 and y1 <= y2 do
    Nx.tensor([[x1, y1], [x2, y2]], type: {:f, 64})
  end

  def new3(x1, y1, z1, x2, y2, z2) when x1 <= x2 and y1 <= y2 and z1 <= z2 do
    Nx.tensor([[x1, y1, z1], [x2, y2, z2]], type: {:f, 64})
  end

  # def corner(bounds, 0) do
  #   bounds[0]
  # end

  # def corner(bounds, 1) do
  #   Nx.concatenate([
  #     Nx.new_axis(bounds[1][0], 0),
  #     Nx.new_axis(bounds[0][1], 0)
  #   ])
  # end

  # def corner(bounds, 2) do
  #   Nx.concatenate([
  #     Nx.new_axis(bounds[0][0], 0),
  #     Nx.new_axis(bounds[1][1], 0)
  #   ])
  # end

  # def corner(bounds, 3) do
  #   bounds[1]
  # end

  defn diagonal(bounds) do
    bounds[1] - bounds[0]
  end

  defn expand(bounds, delta) do
    union(bounds - delta, bounds + delta)
  end

  defn inside?(bounds, point) do
    Nx.all?(
      Nx.greater_equal(point, bounds[0]) and
        Nx.less_equal(point, bounds[1])
    )
  end

  defn inside_exclusive?(bounds, point) do
    Nx.all?(
      Nx.greater_equal(point, bounds[0]) and
        Nx.less(point, bounds[1])
    )
  end

  defn intersect(bounds1, bounds2) do
    Nx.concatenate([
      Nx.new_axis(max(bounds1[0], bounds2[0]), 0),
      Nx.new_axis(min(bounds1[1], bounds2[1]), 0)
    ])
  end

  defn lerp(bounds, t) do
    diagonal(bounds) * t + bounds[0]
  end

  defn offset(bounds, point) do
    (point - bounds[0]) / diagonal(bounds)
  end

  defn overlap?(bounds1, bounds2) do
    Nx.all?(
      Nx.greater_equal(bounds1[1], bounds2[0]) and
        Nx.less_equal(bounds1[0], bounds2[1])
    )
  end

  defn union(bounds1, bounds2) do
    Nx.concatenate([
      Nx.new_axis(min(bounds1[0], bounds2[0]), 0),
      Nx.new_axis(max(bounds1[1], bounds2[1]), 0)
    ])
  end
end
