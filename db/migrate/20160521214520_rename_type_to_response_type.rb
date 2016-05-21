class RenameTypeToResponseType < ActiveRecord::Migration
  def change
    rename_column :responses, :type, :response_type
  end
end
