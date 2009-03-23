require_dependency "search" 

class Word < ActiveRecord::Base
	acts_as_taggable
	
  attr_accessible :word, :language, :definition, :example, :tag_list, :photo , :video_code
  attr_accessor :video_code
	
	define_index do
		indexes word
    has votes_count 
		set_property :delta => true
		has created_at
	end

  has_many :votes
	belongs_to :user

	
	has_many :votes do
		def latest
			find :all, :order => 'id DESC', :limit => 3
		end
	end
	
	has_attached_file :photo, :styles => { :thumb=> "75x75#", :large => "640x480>" }

#	validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
 	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']
  validates_presence_of :word, :language, :definition, :example
	validates_format_of :tag_list, :with => /^[a-zA-Z0-9\,\-\ ]*?$/, :message => 'can only be letters, numbers or commas'

	
	
	#== Callbacks
	before_validation :get_video_id
	after_create :create_initial_vote 
	
	
	def to_param
		"#{id}-#{word.gsub(/\W/, '-').downcase}"
	end 
	
	protected
		
	def create_initial_vote
	  votes.create :user => user
	end
	
		
	def get_video_id
    unless video_code.blank?    
     # Check whether Youtube embed code was entered
      doc = Hpricot.parse(video_code)
    
     #Check if there is a movie param
      embed_url = if (element = doc % "//param[@name='movie']")
                    element.attributes["value"]
                  elsif (element = doc % "//embed") #Check for the movie code in the embed element
                    element.attributes["src"]
                  end
    
      #If we have pulled out a URL from the embed code, get the v param
      if embed_url && (match = %r{/v/(\w+)&}.match(embed_url))
        self.video_id  = match[1]
      end
    
      #If the user entered the video page url
      query_string = video_code.split( '?', 2)[1]
      if query_string
        params = CGI.parse(query_string)
        if params.has_key?("v")
          self.video_id  = params["v"][0]
        end
      end
    end  
	end	
		
end
