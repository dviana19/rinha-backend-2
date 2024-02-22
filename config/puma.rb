workers 0
threads 0,3
#port 3000
bind "unix:///app/tmp/#{ENV['HOSTNAME']}.sock"
#bind "unix:///var/tmp/#{ENV['HOSTNAME']}.sock"
preload_app!
