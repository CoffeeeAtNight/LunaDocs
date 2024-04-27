defmodule LunadocsWeb.ErrorJSONTest do
  use LunadocsWeb.ConnCase, async: true

  test "renders 404" do
    assert LunadocsWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert LunadocsWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
