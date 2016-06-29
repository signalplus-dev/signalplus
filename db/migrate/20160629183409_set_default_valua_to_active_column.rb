class SetDefaultValuaToActiveColumn < ActiveRecord::Migration
  def change
    change_column :listen_signals, :active, :boolean, null: false, default: false
  end
end
