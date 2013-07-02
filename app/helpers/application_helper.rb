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
      Date.strptime(aDate, (I18n.t "date.formats.default")).to_s 
    rescue ArgumentError
      ""
    end
    
  end

end
