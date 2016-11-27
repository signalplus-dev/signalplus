class ScopeUniqueIndexOnEmailForUsers < ActiveRecord::Migration[5.0]
  def up
    remove_index :users, :email
    add_index :users, [:email, :deleted_at], unique: true
  end

  def down
    remove_index :users, [:email, :deleted_at]
    add_index :users, :email, unique: true
  end
end
