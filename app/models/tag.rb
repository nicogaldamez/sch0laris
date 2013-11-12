# == Schema Information
#
# Table name: tags
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :description
  
  def self.tokens(query, can_create)
    tags = where("description like ?", "%#{query}%")
    query = query.gsub(/ /, "_")
    if tags.empty? && can_create
      [{id: "<<<#{query}>>>", description: "Crear: \"#{query}\""}]
    else
      if can_create
        tags << {id: "<<<#{query}>>>", description: "Crear: \"#{query}\""}
      end      
      tags
    end
  end
  
  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(description: $1).id }
    tokens.split(',')
  end
  
end
