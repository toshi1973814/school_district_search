# Set the working application directory
# working_directory "/path/to/your/app"
working_directory ENV["APP_PATH"]

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "#{ENV["APP_PATH"]}/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "#{ENV["APP_PATH"]}/log/unicorn.log"
stdout_path "#{ENV["APP_PATH"]}/log/unicorn.log"

# Unicorn socket
listen "/tmp/unicorn.school_district_search.sock"
listen "/tmp/unicorn.myapp.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
