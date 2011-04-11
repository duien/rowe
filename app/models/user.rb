class User
  include MongoMapper::Document         

  plugin MongoMapper::Devise
  devise :registerable, :database_authenticatable, :recoverable, :rememberable
  
  key :name, String
  key :freckle_email, String
  key :freckle_account, String
  key :freckle_api_token, String

  many :months

  def current_month
    self.months.find_or_create_by_month(Time.now.utc.at_beginning_of_month)
  end

  def freckle_set_up?
    freckle_email? and
      freckle_account? and
      freckle_api_token? and
      Freckle.establish_connection( :account => freckle_account,
                                    :token => freckle_api_token )
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
