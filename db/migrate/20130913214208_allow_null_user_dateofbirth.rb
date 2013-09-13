class AllowNullUserDateofbirth < ActiveRecord::Migration
  def change
    change_column :users, :dateOfBirth, :date, :null => true
  end
end
