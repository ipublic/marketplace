class ApplicationJob < ActiveJob::Base


  before_enqueue do |job|
    puts "Before job is enqueued"
  end

  after_enqueue do |job|
    puts "After job is enqueued"
  end

  before_perform do |job|
    puts "Before job is performed"
  end

  after_perform do |job|
    puts "After job is performed"
  end


  def sneakers_worker_process
  end

  def publish_amqp_exchange_id
  end

  def publish_anqp_routing_key
  end

  def reply_to_amqp_exchange_id
  end

  def reply_to_amqp_queue_id
  end

  def reply_to_amqp_routing_key
  end

  def reply_to_amqp_queue_ttl
  end

end
