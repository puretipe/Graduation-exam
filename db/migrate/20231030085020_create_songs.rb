class CreateSongs < ActiveRecord::Migration[7.1]
  def change
    create_table :songs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true
      t.references :focus_point, null: false, foreign_key: true
      t.string :embed_url
      t.string :title
      t.string :artist
      t.string :software_name
      t.text :description

      t.timestamps
    end
  end
end
