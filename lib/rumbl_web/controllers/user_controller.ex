defmodule RumblWeb.UserController do
   use RumblWeb, :controller

   alias Rumbl.Accounts
   alias Rumbl.Accounts.User
   alias RumblWeb.ErrorHelpers

   plug :authenticate_user when action in [:index, :show]

   def index(conn, _params) do 
            users = Accounts.list_users()
            render(conn, "index.html", users: users)
   end

   def show(conn, %{"id" => id}) do
      user = Accounts.get_user(id)
      render(conn, "show.html", user: user)
   end

   def new(conn, _params) do
      changeset = Accounts.change_user(%User{})
      render(conn, "new.html", changeset: changeset)
   end

   def create(conn, %{"user" => user_params}) do
      case Accounts.register_user(user_params) do
         {:ok, user} ->
            conn
            |> RumblWeb.Auth.login(user)
            |> put_flash(:info, "#{user.name} created!")
            |> redirect(to: Routes.user_path(conn, :index))
         
         {:error, %Ecto.Changeset{} = changeset} ->

            case  ErrorHelpers.get_first_error_message(changeset) do
               "should be at least %{count} character(s)" ->
               conn
               |> put_flash(:info, "should be at least 6 character(s)")
               |> redirect(to: Routes.user_path(conn, :new))
            end

            # IO.inspect(ErrorHelpers.get_first_error_message(changeset))
            
            # IO.inspect(conn)
            # |> put_flash(:info, "#{ErrorHelpers.get_first_error_message(changeset)}")
            # |> redirect(to: Routes.user_path(conn, :new))
      end
   end

   # defp authenticate(conn, _opts) do
   #    if conn.assigns.current_user do
   #       conn
   #    else
   #       conn
   #       |> put_flash(:error, "You must be logged in to access that page")
   #       |> redirect(to: Routes.page_path(conn, :index))
   #       |> halt()
   #    end
   # end

end

