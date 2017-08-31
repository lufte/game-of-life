defmodule Life do
  @moduledoc """
  Documentation for Life.
  """

  @doc """
  """
  def run do
    ExNcurses.n_begin
    grid = build_grid(40, 30, [{2,2}, {3,3}, {3, 4}, {4, 3}, {2, 4}])
    loop(grid)
    ExNcurses.n_end
  end

  def loop(grid) do
    ExNcurses.clear
    grid
    |> Enum.filter(fn e -> elem(e, 1) end)
    |> Enum.each(fn e -> ExNcurses.mvprintw(elem(elem(e, 0), 0), elem(elem(e, 0), 1), "8") end)
    ExNcurses.refresh
    loop(tick(grid))
  end

  def build_grid(n, m, initial_state) do
    for x <- 0..n - 1, y <- 0..m - 1, into: %{}, do: {{x, y}, Enum.member?(initial_state, {x, y})}
  end

  def tick(grid) do
    grid
    |> Enum.map(fn x -> update_cell(x, grid) end)
    |> Enum.into(%{})
  end

  def update_cell({{x, y}, true}, grid) do
    case get_alive_neighbours(x, y, grid) do
      n when n > 1 and n < 4 ->
        {{x, y}, true}
      _ ->
        {{x, y}, false}
    end
  end

  def update_cell({{x, y}, false}, grid) do
    case get_alive_neighbours(x, y, grid) do
      3 ->
        {{x, y}, true}
      _ ->
        {{x, y}, false}
    end
  end

  def get_alive_neighbours(x, y, grid) do
    grid
    |> Enum.filter(fn e -> 
      not (elem(elem(e, 0), 0) == x and elem(elem(e, 0), 1) == y)
      and abs(elem(elem(e, 0), 0) - x) <= 1
      and abs(elem(elem(e, 0), 1) - y) <= 1
      and elem(e, 1)
    end)
    |> Enum.count()
  end
end
