# handle-form.rb
require 'sqlite3'

def get_full_list
  # Connect to the SQLite database
  employee_db = SQLite3::Database.new('employees.db')

  query = employee_db.prepare('SELECT * FROM employee ORDER BY last_name ASC')
  result_set = query.execute

  columns = result_set.columns  # Retrieve the column names
  data = result_set.to_a  # Retrieve the data rows

  employees = data.map { |row| Hash[columns.zip(row)] }  # Create hash map with column names as keys and row values as values

  query.close

  employees
end

def get_employee_to_edit(employee_id)
  # Connect to the SQLite database
  employee_db = SQLite3::Database.new('employees.db')

  query_data = { ':employee_id' => employee_id }
  query_string = "SELECT * FROM employee WHERE employee_id = :employee_id LIMIT 1"
  query = employee_db.prepare(query_string)
  query.bind_params(query_data)
  result_set = query.execute

  columns = result_set.columns  # Retrieve the column names
  data = result_set.next  # Retrieve the first row of data

  employee_to_edit = Hash[columns.zip(data)]  # Create hash map with column names as keys and row values as values

  query.close
  employee_to_edit
end

def update_employee(employee_id, first_name, last_name, email, extension)
  # Connect to the SQLite database
  employee_db = SQLite3::Database.new('employees.db')

  query_data = {
    ':employee_id' => employee_id,
    ':first_name' => first_name,
    ':last_name' => last_name,
    ':email' => email,
    ':extension' => extension
  }

  query_string = <<~SQL
    UPDATE employee
    SET first_name = :first_name,
        last_name = :last_name,
        email = :email,
        extension = :extension
    WHERE employee_id = :employee_id
  SQL

  query = employee_db.prepare(query_string)
  query.execute(query_data)
  query.close
end

def add_employee(employee_id, first_name, last_name, email, extension)
  # Connect to the SQLite database
  employee_db = SQLite3::Database.new('employees.db')

  query_data = {
    ':employee_id' => employee_id,
    ':first_name' => first_name,
    ':last_name' => last_name,
    ':email' => email,
    ':extension' => extension
  }

  query_string = <<~SQL
    INSERT INTO employee (employee_id, first_name, last_name, email, extension)
    VALUES (:employee_id, :first_name, :last_name, :email, :extension)
  SQL

  query = employee_db.prepare(query_string)
  query.execute(query_data)
  query.close
end

def delete_employee(employee_id)
  # Connect to the SQLite database
  employee_db = SQLite3::Database.new('employees.db')

  query_data = { ':employee_id' => employee_id }
  query_string = "DELETE FROM employee WHERE employee_id = :employee_id"
  query = employee_db.prepare(query_string)
  query.bind_params(query_data)
  query.execute
  query.close
end
