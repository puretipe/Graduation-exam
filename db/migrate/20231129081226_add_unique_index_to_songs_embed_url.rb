class AddUniqueIndexToSongsEmbedUrl < ActiveRecord::Migration[7.1]
  def change
    add_index :songs, :embed_url, unique: true
  end
end
