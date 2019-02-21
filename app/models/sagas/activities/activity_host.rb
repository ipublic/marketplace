class Sagas::Activities::ActivityHost

  def initialize(action, routing_slip)
    # send_message = send_message
  end


  def accept_message?(uri, routing_slip)
    # examine uri
  end


  def process_forward_message(routing_slip)
    return if routing_slip.is_completed?

    # if current step is successful, proceed. otherwise go to the unwind path
    if routing_slip.process_next?
      # recursion stands for passing context via message
      # routing_slip can be fully serialized and passed bewteen systems
      send_message(routing_slip.progress_uri, routing_slip)
    else
      # pass message to unwind message route
      send_message(routing_slip.compensation_uri)
    end
  end

  def process_backward_message(routing_slip)
    if routing_slip.is_in_progress?

      # undo_last can put new work on the routing_slip and return false to
      # go back on the foward path
      if routing_slip.undo_last

        # recursion stands for passing context via message
        # routing_slip can be fully serialized and passed bewteen systems
        send_message(routing_slip.compensation_uri, routing_slip)
      else
        send_message(routing_slip.progress_uri, routing_slip)
      end
    end
  end
end
