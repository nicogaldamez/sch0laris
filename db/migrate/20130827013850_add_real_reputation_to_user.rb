class AddRealReputationToUser < ActiveRecord::Migration
  def change
    add_column :users, :real_reputation, :integer, default: 1
  end
end