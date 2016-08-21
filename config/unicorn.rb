# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
@dir = ENV["APP_ROOT"] || File.dirname(__FILE__) + '/../'
@env = ENV["APP_ENV"] || "development"

# See https://rvm.io/integration/passenger/
#if ENV['MY_RUBY_HOME'] && ENV['MY_RUBY_HOME'].include?('rvm')
#  begin
#    gems_path = ENV['MY_RUBY_HOME'].split(/@/)[0].sub(/rubies/,'gems')
#    ENV['GEM_PATH'] = "#{gems_path}:#{gems_path}@global"
#    require 'rvm'
#    RVM.use_from_path! File.dirname(File.dirname(__FILE__))
#  rescue LoadError
#    raise "RVM gem is currently unavailable."
#  end
#end

# If you're not using Bundler at all, remove lines bellow
ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes worker_processes 1 #ENV["UNICORN_WORKERS"].to_i || 10

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"
if ENV["UNICORN_USER"]
  if ENV["UNICORN_GROUP"]
    user ENV["UNICORN_USER"], ENV["UNICORN_GROUP"]
  else
    user ENV["UNICORN_USER"]
  end
end

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
# working_directory "/path/to/app/current" # available in 0.94.0+
working_directory @dir

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
#listen "/tmp/.sock", :backlog => 64
listen 8080 #ENV["UNICORN_PORT"].to_i || 4567, :tcp_nopush => true
listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
# pid "/path/to/app/shared/pids/unicorn.pid"
pid "#{@dir}tmp/pids/unicorn.pid"

# By default, the Unicorn logger will write to stderr.
# Additionally, some applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
# stderr_path "./log/unicorn.stderr.log"
# stdout_path "./log/unicorn.stdout.log"
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

timeout 600

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  # defined?(ActiveRecord::Base) and
  #   ActiveRecord::Base.connection.disconnect!

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{@dir}tmp/pids/unicorn.pid.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  # defined?(ActiveRecord::Base) and
  #   ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
