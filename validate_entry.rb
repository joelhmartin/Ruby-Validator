# validate_entry.rb
require_relative 'data_filters'

# Validates the entry of a new employee or update of an existing employee
def entry_valid?(params)
  errors = []

  errors << number_is_valid_db_id(params['employee_id'])
  errors << length_is_within_range(params['first_name'], 1, 25)
  errors << length_is_within_range(params['last_name'], 1, 25)
  errors << length_is_within_range(params['email'], 1, 50)
  errors << number_is_valid_db_id(params['extension']) && length_is_within_range(params['extension'], 1, 6)

  errors.compact! # Remove nil values from the array

  if errors.empty?
    true
  else
    errors
  end
end