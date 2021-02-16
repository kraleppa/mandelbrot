defmodule Mandelbrot do
  def start(_type, _args) do
    Mandelbrot.Supervisor.start_link()
  end
end
