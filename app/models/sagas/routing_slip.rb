class Sagas::RoutingSlip

	attr_reader :completed_worklogs, :next_work_item

	# completed_worklogs = Stack.new #worklog stack
	# next_work_item = WorkItemQueue.new # work_item queue


	def initialize(work_items = [])
		raise ArgumentError.new "expected array" unless work_items.is_a? Array

		work_items.each { |work_item| WorkItemQueue.enqueue work_item }
	end

	def is_completed?
		next_work_item.count == 0
	end

	def is_in_progress?
		completed_worklogs.count > 0
	end

	def process_next
		raise StandardError.new("invalid operation") if is_completed?

		current_item = WorkItemQueue.dequeue

		activity = activator.new(current_item.activity_type)

		begin
			result = activity.do_work(current_item)
			completed_worklogs.push(result) if result.present?
		rescue => e
			puts "#{e.class}: #{e.message}"
		end

		result
	end

	def progresss_uri
		next_work_item.peek.activity_type.work_item_queue_address unless is_completed?
	end

	def compensation_uri
		completed_worklogs.peek.activity_type.compensation_queue_address if is_in_progress?
	end

	def undo_last
		raise StandardError.new("invalid operation") if is_in_progress?

		current_item = completed_worklogs.pop
		activity = current_item.activity_type.new

		begin
			activity.compensate(current_item)
		rescue => e
			puts "#{e.class}: #{e.message}"
		end

	end


end
