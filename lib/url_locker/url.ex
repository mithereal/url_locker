defmodule Url do
  use Agent

  @salt = Application.get_env(:url_locker, :salt)
  @secret = Application.get_env(:url_locker, :secret)

  def start_link(%{url: url, confirm: password}) do
    name = url |> encrypt(password)
    Agent.start_link(fn -> {url, nil} end, name: name)
    name
  end

  def start_link(%{url: url, password: password, hint: nil}) do
    name = url |> encrypt(password)
    Agent.start_link(fn -> {url, nil} end, name: name)
    name
  end

  def start_link(%{url: url, password: password, hint: hint}) do
    name = url |> encrypt(password)
    Agent.start_link(fn -> {url, hint} end, name: name)
    name
  end

  def encrypt(url, nil) do
    url
  end

  def encrypt(url, password) do
    #    Safetybox.encrypt(url, password, @salt)
  end

  def decrypt(url) do
    Agent.get(url)
  end

  def decrypt(url, password) do
    #    Safetybox.decrypt(url, password, @salt)
    Agent.get(url)
  end
end
