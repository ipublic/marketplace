module Dispatcher

	WORK_ITEM_QUEUE = ""

  class RoutingSlip

    def initialize(workflow)
    	workflow.tasks.each { |task| WORK_ITEM_QUEUE.enqueue task }
    	@completed_tasks = workflow.completed_tasks 
    end

    def is_completed?
      next_task.count == 0
    end

    def is_in_progress?
      completed_tasks.count > 0
    end

    def process_next_task
      current_task = WORK_ITEM_QUEUE.dequeue
      return if current_task.blank?

      task = Task.new(current_task.task_kind)

      begin
        result = task.do_work(current_task)
        completed_tasks.push(result) if result.present?
      rescue => e
        puts "#{e.class}: #{e.message}"
      end

      result
    end

    def progresss_uri
      next_task.peek.task_kind.task_queue_address unless is_completed?
    end

    def compensation_uri
      completed_tasks.peek.task_kind.compensation_queue_address if is_in_progress?
    end

    def undo_last
      raise StandardError.new("invalid operation") if is_in_progress?

      current_task = completed_tasks.pop
      task = current_task.task_kind.new

      begin
        task.compensate(current_task)
      rescue => e
        puts "#{e.class}: #{e.message}"
      end

    end


  end


end
