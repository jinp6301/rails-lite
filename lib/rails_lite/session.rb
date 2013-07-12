require 'json'
require 'webrick'

class Session
  def initialize(req)
    found = nil
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app" 
        found = cookie
      end
    end
    if found.nil?
      @cookie = {} 
    else 
      @cookie = JSON.parse(found.value)
    end
  end

  def [](key)
  	@cookie[key]
  end

  def []=(key, val)
  	@cookie[key] = val
  end

  def store_session(res)
  	res.cookies << WEBrick::Cookie.new("_rails_lite_app", @cookie.to_json)
  end
end
