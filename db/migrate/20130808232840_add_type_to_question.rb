class AddTypeToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :post_type, :char, default: 'Q'
  end
end
