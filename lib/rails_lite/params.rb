require 'uri'

class Params
  def initialize(req, route_params)
    @req = req
    p req.query_string
    parse_www_encoded_form(req.query_string)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    @params = URI::decode_www_form(www_encoded_form)
  end

  def parse_key(key)

  end
end
