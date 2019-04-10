require 'sneakers'
module Dispatcher
  class Tasks::EchoTask
    include Sneakers::Worker

    from_queue 'downloads'

    def work(message)
      begin
        puts "Message is: #{message}"
        logger.info "Success: ECHOED <#{message}>"

        # Send 
        publish("JSON-formatted w/instance ack for <#{message}>", :to_queue => 'ActionJob-supplied unique IE/Time stamped batch response queue')
        ack!
      rescue e
        logger.info "Failure: unable to ECHO <#{message}>"
        worker_trace "Failed to ECHO <#{message}>"
        publish("JSON-formatted w/instance nak for <#{message}>", :to_queue => 'ActionJob-supplied unique ID/Time stamped batch response queue')
        reject!
      end
    end

  end
end
