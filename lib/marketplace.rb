module Marketplace

	# Namespaced nested exception.  Wraps any underlying exception that may have
	# resulted from a different failure
	# For example on how to construct Exception test, see:
	# 	https://gist.github.com/avdi/772356
	class Error < StandardError
		attr_reader :original

		def initialize(msg, original = $!)
			super(msg)
			@original = original
		end
	end
	
	# Pattern for raising Namespaced nested exceptions
	# rescue Marketplace::Error
	# 	raise
	# rescue error 
	# 	raise Marketplace::Error.new("#{error.class}: #{error.message}", error)

end