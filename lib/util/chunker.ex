defmodule Util.Chunker do
  def chunk(list, parts), do: do_chunk(list, parts, [])

  defp do_chunk(_, 0, chunks), do: chunks

  defp do_chunk(to_chunk, parts, chunks) do
  chunk_length = to_chunk |> length() |> div(parts)
  {chunk, rest} = Enum.split(to_chunk, chunk_length)
  do_chunk(rest, parts - 1, [chunk | chunks])
  end
end
