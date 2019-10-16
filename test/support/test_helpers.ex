defmodule Rumbl.TestHelpers do
   alias Rumbl.{
      Accounts,
      Multimedia
   }

   def user_fixture(attrs \\ %{}) do
      {:ok, user} =
         attrs
         |> Enum.into(%{
            name: "Some User",
            username: "user#{System.unique_integer([:positive])}",
            password: attrs[:password] || "supersecret"
         })
         |> IO.inspect(label: "WHAT IS BEING PASSED TO REGISTER_USER()")
         |> Accounts.register_user()

      # IO.inspect(user, label: "THIS IS USER FROM user_fixture/2")     
      user 
   end

   def video_fixture(%Accounts.User{} = user, attrs \\ %{}) do
      attrs =
         Enum.into(attrs, %{
            title: "A Title",
            url: "http://example.com",
            description: "a description"
         })

      {:ok, video} = Multimedia.create_video(user, attrs)

      video
   end
   
end