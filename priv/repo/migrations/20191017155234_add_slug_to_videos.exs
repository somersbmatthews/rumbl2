defmodule Rumbl.Repo.Migrations.AddSlugToVideos do
  use Ecto.Migration

  def change do
    add :slug, :string
  end
end
