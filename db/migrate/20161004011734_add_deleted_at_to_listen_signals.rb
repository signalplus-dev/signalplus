class AddDeletedAtToListenSignals < ActiveRecord::Migration
  def change
    add_column :listen_signals, :deleted_at, :datetime
    add_index :listen_signals, :deleted_at
  end
end
