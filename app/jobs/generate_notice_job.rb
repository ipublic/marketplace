class GenerateNoticeJob < ApplicationJob
  queue_as :default

  # exchange_name :GenerateNotice

  def perform(*args)
    # Do something later
    puts 'Perform a job'

    Sneakers.logger.info "Hello World!"
  end
end
