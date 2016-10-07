class AddUniqueCompoundIndexToSignalName < ActiveRecord::Migration
  def change
    add_index :listen_signals, [:name, :deleted_at], unique: true
  end
end
