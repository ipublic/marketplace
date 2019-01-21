class Parties::Employer
  include Mongoid::Document

  	has_many		:notices

  	has_many 		:accounts

    has_many 		:wage_reports, 
    						class_name: "Wages::Report"

    embeds_many :contribution_rate_determinations, 
    						class_name: "Determinations::ContributionRateDetermination"
end
