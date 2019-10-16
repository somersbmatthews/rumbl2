defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase, async: true

  test "requires user athentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, Routes.video_path(conn, :new)),
      get(conn, Routes.video_path(conn, :index)),
      get(conn, Routes.video_path(conn, :show, "123")),
      get(conn, Routes.video_path(conn, :edit, "123")),
      put(conn, Routes.video_path(conn, :update, "123", %{})),
      post(conn, Routes.video_path(conn, :create, %{})),
      delete(conn, Routes.video_path(conn, :delete, "123")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  setup %{conn: conn, login_as: username} do
    user = user_fixture(username: username)
    conn = assign(conn, :current_user, user) 
    IO.puts("THIS CODE IS EXECUTING")
    {:ok, conn: conn, user: user}
  end

  test "lists all user's videos on index", %{conn: conn, user: user} do
    user_video = video_fixture(user, title: "funny cats")
    other_video = video_fixture(user_fixture(username: "other"), title: "another video")

    conn = get conn, Routes.video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing Videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  describe "with a logged-in user" do
    setup %{conn: conn, login_as: username} do
      IO.puts("THIS CODE IS ALSO EXECUTING")
      user = user_fixture(username: username)
      conn = assign(conn, :current_user, user)
      
      {:ok, conn: conn, user: user}
    end

    @tag login_as: "max"
    test "lists all user's videos on index", %{conn: conn, user: user} do
      user_video = video_fixture(user, title: "funny cats")
      other_video = video_fixture(user_fixture(username: "other"),
        title: "another video")
      conn = get conn, Routes.video_path(conn, :index)
      response = html_response(conn, 200)
      assert response =~ ~r/Listing Videos/
      assert response =~ user_video.title
      refute response =~ other_video.title
      
      
    end
  end
end
#   use RumblWeb.ConnCase

#   alias Rumbl.Multimedia

#   @create_attrs %{description: "some description", title: "some title", url: "some url"}
#   @update_attrs %{description: "some updated description", title: "some updated title", url: "some updated url"}
#   @invalid_attrs %{description: nil, title: nil, url: nil}

#   def fixture(:video) do
#     {:ok, video} = Multimedia.create_video(@create_attrs)
#     video
#   end

#   describe "index" do
#     test "lists all videos", %{conn: conn} do
#       conn = get(conn, Routes.video_path(conn, :index))
#       assert html_response(conn, 200) =~ "Listing Videos"
#     end
#   end

#   describe "new video" do
#     test "renders form", %{conn: conn} do
#       conn = get(conn, Routes.video_path(conn, :new))
#       assert html_response(conn, 200) =~ "New Video"
#     end
#   end

#   describe "create video" do
#     test "redirects to show when data is valid", %{conn: conn} do
#       conn = post(conn, Routes.video_path(conn, :create), video: @create_attrs)

#       assert %{id: id} = redirected_params(conn)
#       assert redirected_to(conn) == Routes.video_path(conn, :show, id)

#       conn = get(conn, Routes.video_path(conn, :show, id))
#       assert html_response(conn, 200) =~ "Show Video"
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, Routes.video_path(conn, :create), video: @invalid_attrs)
#       assert html_response(conn, 200) =~ "New Video"
#     end
#   end

#   describe "edit video" do
#     setup [:create_video]

#     test "renders form for editing chosen video", %{conn: conn, video: video} do
#       conn = get(conn, Routes.video_path(conn, :edit, video))
#       assert html_response(conn, 200) =~ "Edit Video"
#     end
#   end

#   describe "update video" do
#     setup [:create_video]

#     test "redirects when data is valid", %{conn: conn, video: video} do
#       conn = put(conn, Routes.video_path(conn, :update, video), video: @update_attrs)
#       assert redirected_to(conn) == Routes.video_path(conn, :show, video)

#       conn = get(conn, Routes.video_path(conn, :show, video))
#       assert html_response(conn, 200) =~ "some updated description"
#     end

#     test "renders errors when data is invalid", %{conn: conn, video: video} do
#       conn = put(conn, Routes.video_path(conn, :update, video), video: @invalid_attrs)
#       assert html_response(conn, 200) =~ "Edit Video"
#     end
#   end

#   describe "delete video" do
#     setup [:create_video]

#     test "deletes chosen video", %{conn: conn, video: video} do
#       conn = delete(conn, Routes.video_path(conn, :delete, video))
#       assert redirected_to(conn) == Routes.video_path(conn, :index)
#       assert_error_sent 404, fn ->
#         get(conn, Routes.video_path(conn, :show, video))
#       end
#     end
#   end

#   defp create_video(_) do
#     video = fixture(:video)
#     {:ok, video: video}
#   end
# end
