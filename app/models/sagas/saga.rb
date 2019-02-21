# The Saga pattern solves for long-lived, distributed transactions without using two-pase commit.
# Each activity in a workflow must succeed in order for the overarching transaction 
# to succeed.  If a component-level activity fails, any preceding activities are reversed

class Sagas::Saga

	RESERVATION_ROUTING_SLIP = [
			# Sagas::Activities::ReserveCarActivity.new(args), 
			# Sagas::Activities::ReserveHotelActivity.new(args), 
			# Sagas::Activities::ReserveFlightActivity.new(args) 
		]

	RESERVATION_ACTIVITY_SERVICES = [
			# Sagas::Activities::ReserveCarActivityService,
			# Sagas::Activities::ReserveHotelActivityService,
			# Sagas::Activities::ReserveFlightActivityService
		]

	def initialize(routing_slip = [])
		@processes		||= RESERVATION_ACTIVITY_SERVICES
		@routing_slip		= routing_slip || Sagas::RoutingSlip.new(RESERVATION_ROUTING_SLIP)
		@initial_uri		= @routing_slip.progress_uri

		send_message
	end

	def send_message
		process = @processes.detect { |process| process.accept_message?(@initial_uri, @routing_slip) }
		if process.present?
			process(@initial_uri, @routing_slip)
		else
			raise StandardError.new "unrecognized uri for initial process: #{@uri} in processes: #{@processes}"
		end
	end

end
