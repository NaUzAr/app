
# Project Name

This is a simple setup guide for a Python web application using **Gunicorn**, **PostgreSQL**, and **Virtualenv**.

## Prerequisites

Before starting, ensure you have the following software installed:

- **Ubuntu 20.04+**
- **Git**
- **Python 3.8+**
- **PostgreSQL**

## Installation Steps

### 1. Update and Install Git

```bash
sudo apt update
sudo apt install git -y
```

### 2. Clone the Repository

```bash
git clone https://github.com/NaUzAr/app
cd app
```

### 3. Update and Upgrade System Packages

```bash
sudo apt update
sudo apt upgrade -y
```

### 4. Install PostgreSQL

#### Install Dependencies

```bash
sudo apt install -y wget gnupg
```

#### Add PostgreSQL APT Repository

```bash
wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
```

#### Install PostgreSQL

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```

#### Start and Enable PostgreSQL Service

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 5. Configure PostgreSQL

#### Create Database and User

```bash
sudo -u postgres psql <<EOF
CREATE DATABASE myapi_db;
CREATE USER myapi_user WITH ENCRYPTED PASSWORD 'securepassword';
GRANT ALL PRIVILEGES ON DATABASE myapi_db TO myapi_user;
\q
EOF
```

### 6. Set Up Python Environment

#### Install Python 3.8 Virtualenv

```bash
sudo apt install -y python3.8-venv
```

#### Create and Activate Virtual Environment

```bash
python3 -m venv myenv
source myenv/bin/activate
```

#### Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 7. Configure PostgreSQL User Privileges

```bash
sudo -i -u postgres psql <<EOF
\c myapi_db
GRANT ALL PRIVILEGES ON SCHEMA public TO myapi_user;
GRANT ALL PRIVILEGES ON DATABASE myapi_db TO myapi_user;
ALTER USER myapi_user WITH SUPERUSER;
\du myapi_user
\q
EOF
```

### 8. Run Gunicorn Server

Run the application with **Gunicorn** using the following command:

```bash
gunicorn app.main:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:7000
```

### 9. Retry Gunicorn Start if It Fails

In case the Gunicorn server fails to start, the script will attempt to run it again.

```bash
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
```

## Conclusion

This setup will create a web application using **Gunicorn** as the application server, **PostgreSQL** as the database, and a **Python virtual environment** for dependency management.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
