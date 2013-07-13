# encoding: UTF-8

module ApplicationHelper

	# Retorna el título completo
	def full_title(page_title)
		base_title = "Scholaris"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
  
  def parse_date(aDate)
    return aDate if aDate.blank?
    
    begin
      if aDate.class == String
        Date.strptime(aDate, (I18n.t "date.formats.default")).to_s 
      else
        aDate.strftime(I18n.t "date.formats.default")
      end
    rescue ArgumentError
      ""
    end
    
  end
  
  def avatar_for(user, options = { size: :mini })
    size = options[:size]
    if user.avatar.blank?
      if size == :mini
        image_tag 'icons/avatar_30.png', class: "avatar"  
      elsif size == :thumb
        image_tag 'icons/avatar_50.png', class: "avatar"
      end
      
    else
      image_tag user.avatar_url(size).to_s, class: "avatar"
    end 
  end

end
