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
  
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 40 })
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      image_tag(gravatar_url, alt: user.name, class: "avatar")
    end

end
