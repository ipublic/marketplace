require 'flipper'
# require 'mongo'
require 'flipper/adapters/mongo.rb'


# host = Mongoid::Config.clients[:default][:hosts].first
# database_name = Mongoid.client(:default).database.name
# flipper_client = Mongo::Client.new([ host ], :database => database_name)
# feature_collection = flipper_client[:my_flipper_settings]

mongo_client = Mongoid.client(:default)
feature_collection = mongo_client[:flipper_settings]

# require 'flipper/adapters/mongo'
# feature_collection = class FlipperFeature; include Mongoid::Document; include Mongoid::Timestamps; end

Flipper.configure do |config|
  config.default do
    adapter = Flipper::Adapters::Mongo.new(feature_collection)

    Flipper.new(adapter)
  end
end