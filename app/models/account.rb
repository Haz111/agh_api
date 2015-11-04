class Account < ActiveRecord::Base
  before_create :generate_access_identity
  before_create :generate_authentication_token

  private

  def generate_authentication_token
    loop do
      self.authentication_token = ApiAuth.generate_secret_key 
      break unless Account.find_by(authentication_token: authentication_token)
    end
  end

  def generate_access_identity
    loop do
      self.access_id = SecureRandom.hex(6)
      break unless Account.find_by(access_id: access_id)
    end      
  end
end
