defmodule NoctilucentWeb.PageControllerTest do
  use NoctilucentWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Let's watch the stars from the balcony or read Orwell together."
  end
end
