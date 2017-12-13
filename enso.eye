# Eye self-configuration section
Eye.config do
  logger '/tmp/eye.log'
end

# Adding application
Eye.application 'test' do
  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))
  stdall 'trash.log' # stdout,err logs for processes by default
  env 'APP_ENV' => 'production' # global env for each processes
  trigger :flapping, times: 10, within: 1.minute, retry_in: 10.minutes
  check :cpu, every: 10.seconds, below: 100, times: 3 # global check for all processes

  # daemon with 3 children
  process :enso do
    pid_file 'enso.pid'
    start_command 'ruby enso.rb start'
    stop_command  'ruby enso.rb stop'
    stdall 'enso.log'

    start_timeout 10.seconds
    stop_timeout 5.seconds

    monitor_children do
      restart_command 'kill -2 {PID}' # for this child process
      check :memory, below: 300.megabytes, times: 3
    end
  end
end
