module WordsHelper
	def word_list_heading
		word_type = case controller.action_name
			when 'index': 'Popular words'
			when 'recent': 'Recent words'
		end
		 "Become a part of the Revolution! Spread the word about Leximo!"
	end 
end
