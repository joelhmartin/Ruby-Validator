# app.rb
require 'sinatra'
require 'erb'
require_relative 'handle_form' 
require_relative 'data_filters'
require_relative 'validate_entry'

errors = []

get '/' do
  if params['edit']
    employee_id = params['employee_id']
    employee_to_edit = employee_id ? get_employee_to_edit(employee_id) : nil
  end
  # Get the list of employees
  employees = get_full_list()
  # Create an ERB renderer with the template
  template = File.read('employees.html.erb')
  renderer = ERB.new(template)

  # Render the template with the provided data
  result = renderer.result(binding)

  # Output the rendered HTML
  result
end

post '/' do
  employee_id = params['employee_id']
  first_name = params['first_name']
  last_name = params['last_name']
  email = params['email']
  extension = params['extension']

  # Reset the errors array
  errors = []

  if params['update']
    # checks if the entry is valid
    validation_result = entry_valid?(params)
    if validation_result == true
      update_employee(employee_id, first_name, last_name, email, extension)
    else
      # returns the list of errors generated from the validation
      errors = validation_result
    end

    redirect '/'

  elsif params['add'] 
    # checks if the entry is valid
    validation_result = entry_valid?(params)
    if validation_result == true
      add_employee(employee_id, first_name, last_name, email, extension)
    else
      # returns the list of errors generated from the validation
      errors = validation_result
    end

    redirect '/'

  elsif params['delete']
    employee_id = params['employee_id']
    delete_employee(employee_id)

    redirect '/'

  else
    # Handle other actions or render the form again
    # ...
  end
end