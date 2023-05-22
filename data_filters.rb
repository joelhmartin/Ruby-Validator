# data_filters.rb
require 'rack/utils'

def h(data)
  if data
    Rack::Utils.escape_html(data)
  else
    ''
  end
end

def prep_string(data)
  data.strip
end

def length_is_not_above(data, max)
  data.length <= max
end

def length_is_not_below(data, min)
  data.length >= min
end

def length_is_within_range(data, min, max)
  return nil if data.nil? || data.empty?
  
  length = data.length
  if length < min || length > max
    "Length must be between #{min} and #{max} characters."
  else
    nil
  end
end

def is_valid_int(value)
  Integer(value)
  true
rescue ArgumentError
  false
end

def convert_to_int(value)
  value.to_i
end

def number_is_not_above(number, max)
  number <= max
end

def number_is_not_below(number, min)
  number >= min
end

def number_is_in_range(number, min, max)
  number_is_not_below(number, min) && number_is_not_above(number, max)
end

def number_is_valid_db_id(id)
  if is_valid_int(id) && number_is_in_range(id.to_i, 1, 1_000_000)
    nil
  else
    "#{id}: Invalid Number OR Must be between 1 and 1,000,000."
  end
end
