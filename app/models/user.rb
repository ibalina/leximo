require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :words 
  has_many :votes
  has_many :words_voted_on, :through => :votes,	:source => :word
  
  has_attached_file :photo, :styles => { :thumb=> "75x75#", :large => "250x250>" },
                  :url  => "/assets/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/users/:id/:style/:basename.:extension"

# validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/pjpeg']


   def to_param
	login
   end

   # Virtual attribute for the unencrypted password
  attr_accessor :password  
#  attr_accessor :beta_key

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 6..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_format_of       :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i
#  validates_presence_of :beta_key, :if => Proc.new { |user| user.new_record? }, :message => 'Please type in your beta key'
#  validates_each :beta_key, :if => Proc.new { |user| user.new_record? }, :allow_nil => true do |record, attr, value|
#  record.errors.add attr, 'Invalid key' unless value == 'theleximorevolution'
#  end

  has_and_belongs_to_many :roles

  before_save :encrypt_password
  before_create :make_activation_code

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :identity_url, :name, :location, :web, :bio, :photo #, :beta_key

  class ActivationCodeNotFound < StandardError; end
  class AlreadyActivated < StandardError
    attr_reader :user, :message;
    def initialize(user, message=nil)
      @message, @user = message, user
    end
  end
    
#  def beta?
#	!beta_key.blank? && beta_key == 'theleximorevolution'
#  end
  
  # Finds the user with the corresponding activation code, activates their account and returns the user.
  #
  # Raises:
  #  +User::ActivationCodeNotFound+ if there is no user with the corresponding activation code
  #  +User::AlreadyActivated+ if the user with the corresponding activation code has already activated their account
  def self.find_and_activate!(activation_code)
  raise ArgumentError if activation_code.nil?
    user = find_by_activation_code(activation_code)
  raise ActivationCodeNotFound if !user
  raise AlreadyActivated.new(user) if user.active?
    user.send(:activate!)
    user
  end

  def active?
    # the presence of an activation date means they have activated
    !activated_at.nil?
  end

  # Returns true if the user has just been activated.
  def pending?
    @activated
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  # Updated 2/20/08
  def self.authenticate(login, password)    
    u = find :first, :conditions => ['login = ?', login] # need to get the salt
    u && u.authenticated?(password) ? u : nil  
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end
  
  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attribute(:password_reset_code, nil)
    @reset_password = true
  end  

  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end

  def recently_reset_password?
    @reset_password
  end

  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end

  def has_role?(name)
    self.roles.find_by_name(name) ? true : false
  end


protected

  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
     not_openid? && (crypted_password.blank? || !password.blank?)
  end
  
  def not_openid?
     identity_url.blank?
  end

  def make_activation_code
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

private

  def activate!
    @activated = true
    self.update_attribute(:activated_at, Time.now.utc)
  end    

end
