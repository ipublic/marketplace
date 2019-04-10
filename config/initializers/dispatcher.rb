
require 'sneakers'
require 'sneakers/metrics/logging_metrics'

# Mongoid extension to support GlobalID
# JSON adapter for


# config.acapi.publish_amqp_events = :log # or true in production env
# config.acapi.app_id = "enroll"

# ExchangeType

# Process
#   RoutingSlip - has_many Tasks
#   ID
# Task
#   TaskHost
#   Task

# AMQP TaskHost URI format
# scheme: "amqp"
# userinfo:
# host: "main??"
# port
# registry
# path: "exchange"
# opaque:
# query:
# fragment:


# EnterpriseService
# TaskHost
#   ID
#   AMQP Exchange
#   AMQP Message Routing Key
#   ReplyTo
#   Expires (TTL)
#   MIME type

########################
#### Configure AMQP ####
########################

# AMQP host connection information


# Well-known Services
# Logger

# Specify AMQP Topology for Enterprise PubSub

# AMQP Exchanges this component uses to publishes events

# AMQP Queues this component uses to subscribe to events


#### Start Services ####
# Start Redis
$redis = Redis.new

# Start Bunny


# Start Sneakers Workers

# You can use Worker YAML Config File
# Specify an ENV WORKER_GROUP_CONFIG as a path to YAML file (or by convention ./config/sneaker_worker_groups.yml)
# bundle exec ruby -e "require 'sneakers/spawner';Sneakers::Spawner.spawn"

# File Stucture
# foogroup:
#   classes: FooWorker
#   workers: 8
# slowgroup:
#   classes: SlowWorker
#   workers: 2

# You can use Bunny connection to AMQP server as it's far more efficient than
# Sneakers default where each worker opens its own connection

# Sneakers.configure :connection => Bunny.new(…)

# Initialize Sneakers Workers

# include ::Sneakers::WorkerGroup

# Daemon
# :runner_config_file => nil,  # A configuration file (see below)
# :metrics => nil,             # A metrics provider implementation
# :daemonize => true,          # Send to background
# :start_worker_delay => 0.2,  # When workers do frenzy-die, randomize to avoid resource starvation
# :workers => 4,               # Number of per-cpu processes to run
# :log  => 'sneakers.log',     # Log file
# :pid_path => 'sneakers.pid', # Pid file

# Workers
# :timeout_job_after => 5,      # Maximal seconds to wait for job
# :prefetch => 10,              # Grab 10 jobs together. Better speed.
# :threads => 10,               # Threadpool size (good to match prefetch)
# :env => ENV['RACK_ENV'],      # Environment
# :durable => true,             # Is queue durable?
# :ack => true,                 # Must we acknowledge?
# :heartbeat => 2,              # Keep a good connection with broker
# :exchange => 'sneakers',      # AMQP exchange
# :hooks => {}                  # prefork/postfork hooks
# :start_worker_delay => 10     # Delay between thread startup

# Local (per worker)
# class ProfilingWorker
#   include Sneakers::Worker
#   from_queue 'downloads',
#              :env => 'test',
#              :durable => false,
#              :ack => true,
#              :threads => 50,
#              :prefetch => 50,
#              :timeout_job_after => 1,
#              :exchange => 'dummy',
#              :heartbeat => 5
#   def work(msg)
#     ack!
#   end
# end

# opts = {
#   :amqp => 'CLOUDAMQP_URL',
#   :vhost => 'username',
#   :exchange => 'sneakers',
#   :exchange_type => :direct
# }

# Sneakers.configure(opts)

# Autoscaling
# workers 2

# before_fork do
#   Sneakers::logger.info "I'm in a child process!"
# end


# after_fork do
#   Sneakers::logger.info " I'm in a child process!"
# end


Sneakers.configure(
  # daemonize:              true,
  heartbeat:              10,
  log:                    'log/sneakers.log',
  metrics:                Sneakers::Metrics::LoggingMetrics.new,

  retry_exchange:         'activejob-retry',
  retry_error_exchange:   'activejob-error',
  retry_requeue_exchange: 'activejob-retry-requeue'
)

Sneakers.logger.level = Logger::INFO

# Start this using something like:
# WORKERS=ActiveJob::QueueAdapters::SneakersAdapter::JobWrapper rake sneakers:run

#### Configure ActiveJob ####
# Set Sneakers as ActiveJob Queue Adapter
Rails.application.config.active_job.queue_adapter = :sneakers
