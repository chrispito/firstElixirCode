defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, filename) do
    File.write("Pictures/#{filename}.png", image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid, color: color} = image) do
    pixel_map = Enum.map grid, fn({code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      result = nil
      if rem(code, 2) == 0 do
        result = {top_left, bottom_right, color}
      else 
        result = {top_left, bottom_right, {25, 55, 158}}
      end
      result
    end


    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{pixel_map: pixel_map} = image) do
    image = :egd.create(250, 250)

    Enum.each pixel_map, fn({start, stop, color}) ->
      :egd.filledRectangle(image, start, stop, :egd.color(color))
    end

    :egd.render(image)
  end


  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end