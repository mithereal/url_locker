defmodule UrlLockerWeb.ErrorJSONTest do
  use UrlLockerWeb.ConnCase, async: true

  test "renders 404" do
    assert UrlLockerWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert UrlLockerWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
