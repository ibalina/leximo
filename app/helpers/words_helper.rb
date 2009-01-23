module WordsHelper
	def word_list_heading
		word_type = case controller.action_name
			when 'index': 'Popular words'
			when 'recent': 'Recent words'
		end
	 "The Leximo revolution has started. Spread the word. " 
	end 
end
