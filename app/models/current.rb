class Current < ActiveSupport::CurrentAttributes
	attribute :account, :user
  attribute :request_id, :user_agent, :ip_address

  resets { Time.zone = nil }
  
end
