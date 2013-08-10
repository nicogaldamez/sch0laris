class AddPolymorphicFieldToVote < ActiveRecord::Migration
  def change
    add_column :votes, :voteable_id, :integer
    add_column :votes, :voteable_type, :string
    remove_column :votes, :answer_id
    
    add_index :votes, [:voteable_id, :voteable_type]
  end
end