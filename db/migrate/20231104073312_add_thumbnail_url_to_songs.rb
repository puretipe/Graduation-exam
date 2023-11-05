class AddThumbnailUrlToSongs < ActiveRecord::Migration[7.1]
  def change
    add_column :songs, :thumbnail_url, :string
  end
end
