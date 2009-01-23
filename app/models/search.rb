class Search < ActiveRecord::Base
      def search
	@words = ThinkingSphinx::Search.search params[:search], :page => 1, :per_page => 1, :order => "votes DESC"
      end
end
