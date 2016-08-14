class DeviseTokenAuthCreateUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string, :null => false, :default => "email"
    add_column :users, :uid, :string, :null => false, :default => ""

    ## Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime

    update_user_table

    ## Tokens
    add_column :users, :tokens, :json

    add_index :users, [:uid, :provider], :unique => true
  end

  def down
    remove_index :users, [:uid, :provider]

    remove_column :users, :provider
    remove_column :users, :uid

    ## Confirmable
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at

    ## Tokens
    remove_column :users, :tokens
  end

  private

  def update_user_table
    sql = <<-SQL
      UPDATE
        users
      SET
        uid = email,
        provider = 'email',
        confirmed_at = '#{Time.current}';
    SQL

    ActiveRecord::Base.connection.execute(sql)
  end
end
