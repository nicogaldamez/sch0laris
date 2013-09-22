class DropTableQuestionViews < ActiveRecord::Migration
  def change
    drop_table :question_views
  end
end
