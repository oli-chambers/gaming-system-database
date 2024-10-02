#!/bin/bash

# Database connection details
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="gamingsystem"
DB_USER="postgres"
DB_MANAGER="manageruser"
DB_PASSWORD="pass"

#Script to create the database
psql -U postgres -h localhost -p 5432 -a -f IM.sql

# Function to execute SQL file
execute_sql_file() {

    psql -U "$1" -h localhost -p 5432 -d gamingsystem -a -f "$2"
}

# Execute SQL statements for each user
echo "Executing script as testuser with player privileges"
execute_sql_file "testuser" "player.sql"
echo "Executing script as employeeuser with employee privileges"
execute_sql_file "employeeuser" "employee.sql"
echo "Executing script as manageruser with manager privileges"
execute_sql_file "manageruser" "manager.sql"


# Provide feedback
echo "SQL script execution completed."

