
# App Setup Script

This repository contains a Bash script to automate the setup of a web application environment with PostgreSQL, Python, and Gunicorn.

## Features

- Installs required packages like Git, PostgreSQL, and Python.
- Sets up PostgreSQL database and user with the necessary privileges.
- Creates a Python virtual environment and installs dependencies.
- Runs the web app with Gunicorn using Uvicorn workers.
- Retries the Gunicorn server startup twice in case of failure.

## Prerequisites

- Ubuntu-based system (e.g., Ubuntu 20.04 or higher).
- A basic understanding of how to run shell scripts.
- Access to sudo privileges.

## Installation and Setup

### 1. Clone the repository

Clone this repository to your local machine or server.

```bash
git clone https://github.com/NaUzAr/app
cd app
```

### 2. Make the script executable

After navigating to the repository folder, give execute permissions to the setup script:

```bash
chmod +x setup.sh
```

### 3. Run the setup script

Execute the script to set up the environment and start the application:

```bash
./setup.sh
```

The script will:

- Install necessary packages (Git, PostgreSQL, Python).
- Set up a PostgreSQL database `myapi_db` and a user `myapi_user`.
- Create and activate a Python virtual environment.
- Install dependencies from `requirements.txt`.
- Attempt to start the Gunicorn server with Uvicorn workers, retrying once in case of failure.

### 4. Verify the application

Once the script finishes running, your application should be accessible via `http://your-server-ip:7000`.

## Customization

You may want to adjust the following settings in the script before running:

- **PostgreSQL credentials**: Modify the database and user creation commands in the script to match your desired credentials.
- **Gunicorn configuration**: Change the number of workers or the host/port if needed.

## Troubleshooting

- If Gunicorn fails to start after both attempts, check the logs for more details.
- Ensure that all dependencies are correctly listed in `requirements.txt`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For more information, please contact [Your Name] at [Your Email].
