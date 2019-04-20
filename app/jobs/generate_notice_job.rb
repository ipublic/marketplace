class GenerateNoticeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
		puts 'Perform a job'
		
		Sneakers.logger.info "Hello World!" 
  end
end
