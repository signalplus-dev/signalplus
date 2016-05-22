class RenameListenToToName < ActiveRecord::Migration
  def change
    rename_column :listen_signals, :listen_to, :name
  end
end
