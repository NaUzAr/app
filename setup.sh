#!/bin/bash

# Update and install Git
sudo apt update
sudo apt install git -y

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install wget and gnupg for PostgreSQL setup
sudo apt install -y wget gnupg

# Add PostgreSQL APT repository
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list

# Update and install PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Switch to postgres user and create the database and user
sudo -u postgres psql <<EOF
CREATE DATABASE myapi_db;
CREATE USER myapi_user WITH ENCRYPTED PASSWORD 'securepassword';
GRANT ALL PRIVILEGES ON DATABASE myapi_db TO myapi_user;
\q
EOF

# Install python3.8-venv for virtual environment setup
sudo apt install -y python3.8-venv

# Create a virtual environment and activate it
python3 -m venv myenv
source myenv/bin/activate

# Install Python dependencies from requirements.txt
pip install -r requirements.txt

# Switch to postgres user again to grant privileges and set superuser
sudo -i -u postgres psql <<EOF
\c myapi_db
GRANT ALL PRIVILEGES ON SCHEMA public TO myapi_user;
GRANT ALL PRIVILEGES ON DATABASE myapi_db TO myapi_user;
ALTER USER myapi_user WITH SUPERUSER;
\du myapi_user
\q
EOF

# Exit the postgres user
exit

# Try to run the Gunicorn server twice in case of failure
attempts=0
max_attempts=2
while [ $attempts -lt $max_attempts ]; do
    gunicorn app.main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:7000
    if [ $? -eq 0 ]; then
        echo "Gunicorn started successfully!"
        break
    else
        echo "Gunicorn failed. Retrying..."
        ((attempts++))
        if [ $attempts -eq $max_attempts ]; then
            echo "Gunicorn failed after $max_attempts attempts."
        fi
    fi
done
