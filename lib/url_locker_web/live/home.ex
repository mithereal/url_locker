defmodule UrlLockerWeb.Live.Home do
  use UrlLockerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="items-center justify-center">
        <h1 class="text-2xl font-bold text-white mb-2 text-center">🔒 URL Locker</h1>
        <p class="text-sm text-slate-400 text-center mb-6">
          Lock a URL behind a password and add a hint to help you remember it.
        </p>
        <.form
          :let={f}
          for={@form}
          id="url-locker"
          phx-submit="encrypt"
          phx-mounted={JS.focus_first()}
          action={~p"/"}
          class="space-y-4"
        >
          <div>
            <label for="url" class="block text-sm font-medium text-slate-300 mb-1">URL</label>
            <.input
              name="url"
              field={f[:url]}
              required
              phx-mounted={JS.focus()}
              placeholder="https://example.com"
              class="w-full px-3 py-2 rounded-lg bg-slate-900 text-slate-100 border border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label for="password" class="block text-sm font-medium text-slate-300 mb-1">
              Password
            </label>
            <.input
              name="password"
              field={f[:password]}
              type="password"
              value={f[:password].value}
              required
              class="w-full px-3 py-2 rounded-lg bg-slate-900 text-slate-100 border border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label for="confirm" class="block text-sm font-medium text-slate-300 mb-1">
              Confirm Password
            </label>
            <.input
              field={f[:confirm]}
              value={f[:confirm].value}
              type="password"
              name="confirm"
              required
              class="w-full px-3 py-2 rounded-lg bg-slate-900 text-slate-100 border border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <div>
            <label for="hint" class="block text-sm font-medium text-slate-300 mb-1">
              Hint (optional)
            </label>
            <.input
              field={f[:hint]}
              value={f[:hint].value}
              name="hint"
              placeholder="e.g. Favorite pet's name"
              class="w-full px-3 py-2 rounded-lg bg-slate-900 text-slate-100 border border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          <.button
            phx-disable-with="Working ..."
            class="w-full mt-4 py-2 rounded-lg bg-blue-600 text-white font-semibold hover:bg-blue-500 transition-colors"
          >
            Lock URL
          </.button>
        </.form>
        <div>
          <label for="result" class="block text-sm font-medium text-slate-300 mb-1">Result</label>
          <.input
            name="result"
            value={@url_result}
            class="w-full px-3 py-2 rounded-lg bg-slate-900 text-slate-100 border border-slate-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{"password" => nil, "confirm" => nil, "hint" => nil, "url" => nil}, as: "url")
    {:ok, assign(socket, form: form, trigger_submit: false, url_result: nil)}
  end

  @impl true
  def handle_event(
        "encrypt",
        data,
        socket
      ) do
    result =
      case data["password"] == data["confirm"] do
        true -> Url.start_link(%{url: data["url"], confirm: data["confirm"]})
        false -> nil
      end

    {:noreply, assign(socket, trigger_submit: true, url_result: result)}
  end

  @impl true
  def handle_event(
        "decrypt",
        data,
        socket
      ) do
    result = Url.decrypt(data["url"], data["confirm"])

    {:noreply, assign(socket, trigger_submit: true, url_result: result)}
  end
end
