module Notices
	class Notice
	  include Mongoid::Document

	  belongs_to	:party,
	  						class_name: 'PArties::Party'
	end
end
