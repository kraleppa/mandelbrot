defmodule Mandelbrot do
  def mandelbrot_task(points) do
    {:ok, file} = File.open("results.txt", [:write])
    results = Enum.map(points, &process_point(&1)) |>
    Enum.map(&parse_tuple(&1))

    IO.puts(file, results)

  end

  defp parse_tuple({x, y, z}) do
    Integer.to_string(x) <> " " <> Integer.to_string(y) <> " " <> Integer.to_string(z) <> "\n"
  end

  defp process_point(point) do
    max_iter = 570
    zoom = 220
    xPosition = 500
    yPosition = 300

    cX = (elem(point, 0) - xPosition) / zoom
    cY = (elem(point, 1) - yPosition) / zoom

    iter = loop(cX, cY, 0, 0, max_iter)
    {elem(point, 0), elem(point, 1), iter}
  end

  defp loop(cX, cY, zx, zy, iter) do
    if zx * zx + zy * zy < 4 and iter > 0 do
      tmp = zx * zx - zy * zy + cX
      zy = 2.0 * zx * zy + cY
      zx = tmp
      iter = iter - 1
      loop(cX, cY, zx, zy, iter)
    else
      iter
    end
  end

  def start(_type, _args) do
    Executor.Supervisor.start_link()
  end
end
