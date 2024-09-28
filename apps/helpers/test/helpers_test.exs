defmodule HelpersTest do
  use ExUnit.Case
  doctest Helpers

  test "absolutely truth" do
    assert 1 + 1 == 2
  end
end
