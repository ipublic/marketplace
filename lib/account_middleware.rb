# Rack Middleware extension that inspects the request string for an account value and populates  
# CurrentAttributes with information based on the account 

# Application URL includes the Account identifier as the first value
# in the request string.  For example a request formatted as: '/34bc21a3f4e/employers'
# where '34bc21a3f4e' is the Account ID and 'employers' is an index route
class AccountMiddleware

	def initialize(app)
		@app = app
	end

	def call(env)
		_, account_id, request_path = env["REQUEST_PATH"].split('/', 3)

		# Only process if first element of resource request is numeric or hex indicating presence of
		# an account_id.  Otherwise, ignore and pass request along rack chain
		if account_id =~ /^[0-9A-F]+$/i

			# Current model class is ActiveSupport::CurrentAttributes subclass
			# Store the User instance on user attribute
			# if account = Account.find(account_id)
   #      Current.account = account
   #    else
   #      return [302, { "Location" => "/" }, []]
			# end

			#### User model substituted for Account model for prototype only ####
			#### Expects design where Account has_many Users

			if user = User.find(account_id)
        Current.user = user
      else
        return [302, { "Location" => "/" }, []]
			end

			# Rewrite the env values to match pattern
      env["SCRIPT_NAME"]  = "/#{account_id}"

      env["PATH_INFO"]    = "/#{request_path}"
      env["REQUEST_PATH"] = "/#{request_path}"
      env["REQUEST_URI"]  = "/#{request_path}"
		end

		@app.call(env)
	end

end