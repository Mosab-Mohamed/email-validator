class Rack::Attack

  include AbstractController::Rendering

  ### Configure Cache ###

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new 


  ### Prevent Brute-Force Attacks ###

  # Throttle GET requests to /emails/validate by IP address
  throttle('email/validate', limit: 5, period: 1.second) do |req|
    if req.path.include?('/emails/validate') && req.get?
      req.ip
    end
  end

  # Throttle requests to 5 requests per second per ip
  throttle('req/ip', limit: 5, period: 1.second) { |req| req.ip }


  # Customize the response
  self.throttled_response = lambda do |env|
  [ 429,  # status
   { 'Content-Type' => 'application/json' },   # headers
   [
    {
      success: false,
      error: {
        code: 429, #429 Too Many Requests
        message: "Too many requests, please try again LATER!"
      }
    }.to_json
   ] # body
  ]
  end

  # Always allow requests from localhost (blocklist & throttles are skipped)
  safelist('allow from localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

end
