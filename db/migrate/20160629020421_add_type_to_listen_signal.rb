class AddTypeToListenSignal < ActiveRecord::Migration
  def change
    add_column :listen_signals, :signal_type,  :string
  end
end
