class CreateQuestionViews < ActiveRecord::Migration
  def change
    create_table :question_views, :force => true do |t|
      t.integer :question_id
      t.integer :user_id
      t.timestamps
    end
    
    add_index :question_views, :user_id
    add_index :question_views, :question_id
  end
end