class User

  include DataMapper::Resource

  property :id, Serial
  property :email, String, unique: true
  property :username, String, unique: true
  property :display_name, String
  property :password_digest, Text
  property :token, String

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    user = first(:email => email)
    user if user && BCrypt::Password.new(user.password_digest) == password
  end

  attr_reader :password
  attr_accessor :password_confirmation

  validates_confirmation_of :password

end