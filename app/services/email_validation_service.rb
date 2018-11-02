require 'net/http'
require 'httparty'  

class EmailValidationService
  include HTTParty

  BASE_URL = 'http://apilayer.net/api/check?'
  OK_CODE = '200'

  attr_reader :response

  def initialize(email)
    @email = email
    @response = {}
  end

  def validate!
    query = {
      "access_key": Rails.application.credentials.mailboxlayer[:access_key],
      "email": @email,
      "format": 1,
      "smtp": 1
    }

    result = HTTParty.get(BASE_URL, query: query, timeout: 10)
    @response = JSON.parse(result.response.body).symbolize_keys

  rescue Net::ReadTimeout
    @response = {
      "success": false,
      "error": {
        "info": "Network error, Please try again!"
      }
    }

    @response.symbolize_keys
  end
end
