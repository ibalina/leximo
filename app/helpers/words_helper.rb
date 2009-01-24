module WordsHelper
	def word_list_heading
		word_type = case controller.action_name
			when 'index': 'Popular words'
			when 'recent': 'Recent words'
		end
		 "We are not liberators. Liberators do not exist. The people liberate themselves."
	end 
end
