class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null:false
      t.string :password, null:false
      t.string :name, null:false
      t.date :dateOfBirth, null:false
      t.string :gender, limit:1

      t.timestamps
    end
    
    add_index :users,:email, unique:true
    add_index :users,:name
  end
end
