module Wages
	class WageEntry
	  include Mongoid::Document

	  embedded_in	:wage_report,
	  						class_name: 'Wages::WageReport'

	end
end
