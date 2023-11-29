class AddForeignKeyToEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :evaluations, :songs
    add_foreign_key :evaluations, :users
  end
end
