defmodule Mandelbrot.Executor.MandelbrotTask do
  def execute_task(points, settings, socket) do
    # :timer.sleep(5000)
    results = Enum.map(points, &process_point(&1, settings)) |>
      Enum.map(&parse_tuple(&1))
    :gen_tcp.send(socket, results)
  end

  defp parse_tuple({x, y, z}) do
    Integer.to_string(x) <> " " <> Integer.to_string(y) <> " " <> Integer.to_string(z) <> "\n"
  end

  defp process_point(point, settings) do
    max_iter = 570

    cX = (elem(point, 0) - settings.x_position) / settings.zoom
    cY = (elem(point, 1) - settings.y_position) / settings.zoom

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

end
