class User
  include ActiveModel::Validations
  include ActiveModel::SecurePassword
  include ActiveModel::Serialization  
  
  include ActiveHash

  attr_accessor :username, :password_digest

  has_secure_password
  has_hash_attributes key: :username, value: :password_digest

  validates :username, length: { in: 4..20 }
  validates :password, length: { minimum: 6 }

  def attributes
    {'username' => nil, 'password_digest' => nil}
  end
end