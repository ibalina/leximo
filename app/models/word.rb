require_dependency "search" 

class Word < ActiveRecord::Base
	acts_as_taggable
	after_create :create_initial_vote 

	validates_presence_of :word, :language, :definition, :example
	validates_format_of :tag_list, :with => /^[a-zA-Z0-9\,\-\ ]*?$/, :message => 'can only be letters, numbers or commas'
	has_many :votes
	belongs_to :user

	has_attached_file :photo, :styles => { :thumb=> "75x75#", :large => "640x480>" },
                  :url  => "/assets/words/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/words/:id/:style/:basename.:extension"

#	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']

	attr_accessible :word, :language, :definition, :example, :tag_list, :photo	
	define_index do
		indexes word

                has votes_count 
		set_property :delta => true

		has created_at
	end

	def to_param
		"#{id}-#{word.gsub(/\W/, '-').downcase}"
	end 
	has_many :votes do
		def latest
			find :all, :order => 'id DESC', :limit => 3
		end
	end
	
	protected
		def create_initial_vote
			votes.create :user => user
		end
end
