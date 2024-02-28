workers ENV.fetch('WEB_CONCURRENCY', 2)

max_threads_count = ENV.fetch('RACK_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RACK_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count
port 3000
bind "unix:///app/tmp/#{ENV['HOSTNAME']}.sock"
