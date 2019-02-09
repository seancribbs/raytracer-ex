defmodule Raytracer.Generators do
  use PropCheck
  alias Raytracer.Geometry.{Matrix4x4, Point3, Vector3}

  def non_zero_number, do: such_that(n <- number(), when: n != 0)

  #
  # Matrix generators
  #

  def invertable_matrix4x4, do: such_that(m <- matrix4x4(), when: Matrix4x4.determinant(m) != 0)

  def matrix4x4 do
    let {m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33} <-
          {float(), float(), float(), float(), float(), float(), float(), float(), float(), float(),
           float(), float(), float(), float(), float(), float()} do
      Matrix4x4.new(
        {m00, m01, m02, m03},
        {m10, m11, m12, m13},
        {m20, m21, m22, m23},
        {m30, m31, m32, m33}
      )
    end
  end

  #
  # Point and vector generators
  #

  def point3 do
    let {x, y, z} <- {float(), float(), float()} do
      %Point3{x: x, y: y, z: z}
    end
  end

  def vector3 do
    let {dx, dy, dz} <- {float(), float(), float()} do
      %Vector3{dx: dx, dy: dy, dz: dz}
    end
  end
end
