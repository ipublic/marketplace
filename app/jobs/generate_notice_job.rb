class GenerateNoticeJob < ApplicationJob
  queue_as :default

  before_enqueue do |job|
    puts "Before job is enqueued"
  end

  before_perform do |job|
    puts "Before job is performed"
  end

  def perform(*args)
    # Do something later
		puts 'Perform a job'
		
		Sneakers.logger.info "Hello World!" 
  end
end
