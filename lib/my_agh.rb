require 'net/http'
require 'api-auth'

class MyAgh
  attr_accessor :access_id
  attr_accessor :authentication_token
  attr_accessor :base_url
  attr_accessor :headers
  attr_accessor :api_version

  def initialize(*args)
    @access_id = Rails.application.secrets.my_access_id
    @authentication_token = Rails.application.secrets.my_authentication_token
    @base_url = Rails.application.secrets.my_api_base_url
    @headers = {
      'Accept' => "Accept: application/agh.edu.pl; version=#{Rails.application.secrets.my_api_version}", 
      'Content-Type' =>'application/json'
    }
  end

  def version
    base_uri = URI("#{@base_url}/version")
    request = Net::HTTP::Get.new(base_uri.path, @headers)
    signed_request = ApiAuth.sign!(request, @access_id, @authentication_token)
    res = Net::HTTP.start(base_uri.hostname, base_uri.port) {|http|
      puts http.request(signed_request).body
    }
  end
end