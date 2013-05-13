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

end
