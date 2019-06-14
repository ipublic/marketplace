module Quanta
  class Duration
    def initialize(duration)
      @duration = duration
    end

    # Converts an object of this instance into a database friendly value.
    def mongoize
    	@duration.iso8601
    end

    class << self
      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
  		def demongoize(object)
  			ActiveSupport::Duration.parse(object)
  		end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case object
        when Duration then object.mongoize
        when Integer then ActiveSupport::Duration.build(object).mongoize
        else object
        end
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
        when Duration then object.mongoize
        else object
        end
      end

    end
  end
end
