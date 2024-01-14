class CreateFollows < ActiveRecord::Migration[7.1]
  def change
    create_table :follows do |t|
      t.bigint :follower_id
      t.bigint :followed_id

      t.timestamps
    end

    add_index :follows, :follower_id
    add_index :follows, :followed_id
    add_foreign_key :follows, :users, column: :follower_id
    add_foreign_key :follows, :users, column: :followed_id
  end
end
