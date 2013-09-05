class RemoveObjectChangesFromVersions < ActiveRecord::Migration
  def change
    remove_column :versions, :object_changes
  end
end
