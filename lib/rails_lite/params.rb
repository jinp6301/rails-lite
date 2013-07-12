require 'uri'

class Params
  def initialize(req, route_params)
    @req = req
    @params = {}
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
    @params.merge!(parse_www_encoded_form(req.body)) if req.body
    @params.merge!(parse_www_encoded_form(route_params)) if !!route_params
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    parsed_array = URI::decode_www_form(www_encoded_form)
    p parsed_array
    new_array = []
    parsed_array.each do |a, b|
      new_array << [parse_key(a), b]
    end
    keys_array = []
    value_array = []
    new_array.each do |a|
      keys_array << a[0]
      value_array << a[1]
    end
    make_nested_hash(keys_array, value_array)
  end

  def parse_key(key)
    key.scan(/\W?(\w+)\W?/).flatten
  end

  def make_nested_hash(keys_array, value_array)
    nested_hash = {}
    inner_hash = {}
    keys_array.each_with_index do |keys, j|
      keys.each_with_index do |key, i|
        if key == keys.first 
          nested_hash[key] ||= {}
          inner_hash = nested_hash[key]
        elsif key == keys.last
          inner_hash[key] = value_array[j]
        else
          inner_hash[key] ||= {}
          inner_hash = inner_hash[key]
        end
      end
    end
  end
end
