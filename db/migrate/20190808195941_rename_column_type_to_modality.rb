class RenameColumnTypeToModality < ActiveRecord::Migration[6.0]
  def change
    rename_column :sessions, :type, :modality
  end
end
