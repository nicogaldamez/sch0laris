class CreateQuestionsTagsTable < ActiveRecord::Migration
  def change
    create_table :questions_tags, :force => true do |t|
      t.integer :tag_id
      t.integer :question_id
    end
    add_index :questions_tags, :tag_id
    add_index :questions_tags, :question_id
  end
end