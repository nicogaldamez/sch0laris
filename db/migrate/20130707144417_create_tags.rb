class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :description

      t.timestamps
    end
    add_index :tags, :description, :unique => true
  end
end