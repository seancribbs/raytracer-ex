defmodule Raytracer.TGAImage do
  defstruct [
    id_length: 0,
    color_map_type: 0,
    image_type: 2,
    color_map_specification: %{
      first_entry_index: 0,
      num_entries: 0,
      entry_size: 0,
    },
    x_origin: 0,
    y_origin: 0,
    width: 0,
    height: 0,
    pixel_depth: 24,
    descriptor: 0,
  ]

  @doc """
  Writes the `image` and `pixels` data to the file at the specified `path`.
  """
  def write(image, path, pixels) do
    File.write(path, file_data(image, pixels), [:binary, :raw])
  end

  defp file_data(image, pixels) do
    header(image) <> format_pixels(image, pixels, "") <> footer()
  end

  defp header(image) do
    <<image.id_length::little-8>> <>
      <<image.color_map_type::little-8>> <>
      <<image.image_type::little-8>> <>
      color_map_specification_to_binary(image.color_map_specification) <>
      <<image.x_origin::little-16>> <>
      <<image.y_origin::little-16>> <>
      <<image.width::little-16>> <>
      <<image.height::little-16>> <>
      <<image.pixel_depth::little-8>> <>
      <<image.descriptor::little-8>>
  end

  defp color_map_specification_to_binary(color_map_specification) do
    <<color_map_specification.first_entry_index::little-16>> <>
      <<color_map_specification.num_entries::little-16>> <>
      <<color_map_specification.entry_size::little-8>>
  end

  defp format_pixels(_, "", acc), do: acc
  defp format_pixels(
    %__MODULE__{pixel_depth: pixel_depth} = image,
    <<pixel::24>> <> rest,
    acc
  ) when pixel_depth == 24 do
    format_pixels(image, rest, acc <> <<pixel::little-24>>)
  end

  defp footer() do
    "TRUEVISION-XFILE." <> :binary.copy(<<0>>, 9)
  end
end