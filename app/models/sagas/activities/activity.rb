class Sagas::Activities::Activity


	def do_work(work_item)
		# logfile: activity title
		# perform activity work
		# logfile: activity success
		# return value
	end

	def compensate(item, routing_slip)
		item.result
		# logfile: canceled instance
	end

	def work_item_queue_address
		Uri.new("sb://activity_actions")
	end

	def uri_compensation_queue_address
		Uri.new("sb://activity_cancel_actions")
	end


end
