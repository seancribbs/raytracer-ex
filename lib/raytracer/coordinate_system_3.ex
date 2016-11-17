defmodule Raytracer.CoordinateSystem3 do
  @moduledoc """
  """

  alias Raytracer.Vector3

  defstruct [
    u_axis: %Vector3{dx: 1.0, dy: 0.0, dz: 0.0},
    v_axis: %Vector3{dx: 0.0, dy: 1.0, dz: 0.0},
    w_axis: %Vector3{dx: 0.0, dy: 0.0, dz: 1.0},
  ]

  @doc """
  Creates a three-dimensional coordinate system from `vector`.

  This function assumes that `vector` is normalized.
  """
  def create_from_vector(%Vector3{dx: dx, dy: dy, dz: dz} = vector) when abs(dx) > abs(dy) do
    v_axis =
      %Vector3{dx: -dz, dy: 0.0, dz: dx}
      |> Vector3.divide(:math.sqrt(dx * dx + dz * dz))
    w_axis = Vector3.cross(vector, v_axis)
    %__MODULE__{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end

  def create_from_vector(%Vector3{dy: dy, dz: dz} = vector) do
    v_axis =
      %Vector3{dx: 0.0, dy: dz, dz: -dy}
      |> Vector3.divide(:math.sqrt(dy * dy + dz * dz))
    w_axis = Vector3.cross(vector, v_axis)
    %__MODULE__{u_axis: vector, v_axis: v_axis, w_axis: w_axis}
  end
end
