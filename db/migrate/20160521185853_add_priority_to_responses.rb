class AddPriorityToResponses < ActiveRecord::Migration
  def change
    add_column :responses, :priority, :int
  end
end
