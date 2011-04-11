class User
  include MongoMapper::Document         

  plugin MongoMapper::Devise
  devise :registerable, :database_authenticatable, :recoverable, :rememberable
  
  key :name, String
  key :freckle_email, String
  key :freckle_account, String
  key :freckle_api_token, String
  key :admin, Boolean, :default => false

  many :months

  def current_month
    self.months.find_or_create_by_month(Time.now.utc.at_beginning_of_month)
  end

  def establish_freckle_connection
    @freckle_connection_status ||=
      if freckle_email? and freckle_account? and freckle_api_token? # all data found
        Freckle.establish_connection( :account => freckle_account,
                                     :token => freckle_api_token )
        begin
          @freckle_user ||= Freckle::User.by_email(freckle_email)
          @freckle_user.present? ? :ok : :invalid_email
        rescue RestClient::Request::Unauthorized
          :invalid_api_token
        end
      else
        :field_missing
      end
  end

  def freckle_set_up?
    establish_freckle_connection == :ok
  end

  def freckle_user
    @freckle_user
  end

  # Make email case-insensitive for login purposes
  before_save :downcase_email

  def downcase_email
    puts self.inspect
    self.email.downcase! if self.email
  end

  def self.find_for_authentication(conditions)
    conditions[:email].downcase!
    super(conditions)
  end


# Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# validates_presence_of :attribute

# Assocations :::::::::::::::::::::::::::::::::::::::::::::::::::::
# belongs_to :model
# many :model
# one :model

# Callbacks ::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
# before_create :your_model_method
# after_create :your_model_method
# before_update :your_model_method 

# Attribute options extras ::::::::::::::::::::::::::::::::::::::::
# attr_accessible :first_name, :last_name, :email

# Validations
# key :name, :required =>  true      

# Defaults
# key :done, :default => false

# Typecast
# key :user_ids, Array, :typecast => 'ObjectId'
  
   
end
