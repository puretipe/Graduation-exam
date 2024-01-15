class SetDefaultRoleForUsers < ActiveRecord::Migration[7.1]
  def up
    User.where(role: nil).update_all(role: :artist)
  end
end
