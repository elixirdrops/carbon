defmodule Carbon.Web do
  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller
      
      import Ecto
      import Ecto.Query
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/carbon/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      def error_tag(form, field) do
        if error = form.errors[field] do
          content_tag :span, translate_error(error), class: "help-block"
        end
      end

      def translate_error({msg, opts}) do
        if count = opts[:count] do
          Gettext.dngettext(TshirtStore.Gettext, "errors", msg, msg, count, opts)
        else
          Gettext.dgettext(TshirtStore.Gettext, "errors", msg, opts)
        end
      end
    end
  end
  
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
